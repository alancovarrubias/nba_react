module Database
  class RatingBuilder < Builder
    def run
      build_interval_stats(season, 0)
    end

    private
      def build_interval_stats(season, quarter)
        team_data_hash = Hash[season.teams.map { |team| [team, { game_dates: [], stats: [] }] }]
        player_data_hash = Hash[season.players.map { |player| [player, { game_dates: [], stats: [] }] }]
        season.game_dates.each do |game_date|
          game_date.games.each do |game|
            away_team_hash = team_data_hash[game.away_team]
            home_team_hash = team_data_hash[game.home_team]
            game.periods.where(quarter: quarter).each do |period|
              home_team_hash[:game_dates] << game_date
              away_team_hash[:game_dates] << game_date
              away_team_hash[:stats] << period.away_team_stat.stat_container
              home_team_hash[:stats] << period.home_team_stat.stat_container
            end
          end
        end
        [player_data_hash, team_data_hash].each do |data_hash|
          data_hash.each do |model, data|
            stats = data[:stats]
            game_dates = data[:game_dates]
            puts "#{model.name} Interval Stats"
            build_season_intervals(model, game_dates, stats, season, quarter)
            build_games_played_intervals(10, model, game_dates, stats, season, quarter)
          end
        end
      end

      def build_season_intervals(model, game_dates, stats, season, quarter)
        game_dates.each_with_index do |game_date, index|
          next if index == 0
          interval = Interval.find_or_create_by(season: season, quarter: quarter, start_date: game_dates[0], end_date: game_date)
          interval_stats = stats[0..index]
          total_stat = sum_hashes(interval_stats)
          stat = Stat.find_or_create_by({ games_played: interval_stats.size, intervalable: interval, statable: model }.merge(total_stat))
        end
      end

      def build_games_played_intervals(games_played, model, game_dates, stats, season, quarter)
        game_dates.each_with_index do |game_date, index|
          end_index = index + games_played - 1
          start_date = game_date
          end_date = game_dates[end_index] 
          break if !end_date
          interval = Interval.find_or_create_by(start_date: start_date, end_date: end_date, quarter: quarter, season: season)
          interval_stats = stats[index..end_index]
          total_stat = sum_hashes(interval_stats)
          stat = Stat.find_or_create_by({ intervalable: interval, statable: model, games_played: games_played }.merge(total_stat))
        end
      end

      def build_rtgs(season, quarter)
        season.games.each do |game|
          puts game.url
          game.periods.each do |period|
            period.stats.each do |stat|
              stat.update(ortg: stat.calc_ortg, drtg: stat.calc_drtg)
            end
          end
        end
      end

      def sum_hashes(array)
        return array.inject { |mem, hash| mem.merge(hash) { |key, old, new| old + new } }
      end
  end
end
