module Database
  class PrevStatBuilder < Builder
    def run(num=nil)
      games.each { |game| build_stats(game, num, 0) }
    end

    def build_stats(game, num, period)
      puts "Game #{game.id} Build Prev Stats"
      return if num && (game.prev_away_games.size < num || game.prev_home_games.size < num)
      ["player", "team"].each do |model|
        game.send("#{model}_game_stats_#{period}").each do |stat|
          build_stat(game, stat, num, period)
        end
      end
    end

    def build_stat(game, stat, num, period)
      stats = stat.prev_stats(num)
      return if not_enough_stats(stats, num)
      stat = Stat.find_or_create_by({ season: season, game: game, model: stat.model, period: period,
                                      games_back: stats.size, season_stat: num == nil })
      stat_container = Stat.build_model(stats).stat_container
      stat.update(stat_container)
    end

    def not_enough_stats(stats, num)
      return (num != nil && stats.size != num)
    end
  end
end
