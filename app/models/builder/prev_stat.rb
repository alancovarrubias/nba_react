module Builder
  module PrevStat
    extend self
    def run(season, games, num=nil, period=0)
      games.each { |game| build_stats(season, game, num, period) }
    end

    def build_stats(season, game, num, period)
      puts "Game #{game.id} Build Prev Stats"
      return if num && (game.prev_away_games.size < num || game.prev_home_games.size < num)
      ["player", "team"].each do |model|
        game.send("game_#{model}_stats", period).each do |stat|
          build_stat(season, game, stat, num, period)
        end
      end
    end

    def build_stat(season, game, stat, num, period)
      stats = stat.prev_stats.limit(10)
      return if not_enough_stats(stats, num)
      stat = ::Stat.find_or_create_by({ season: season, game: game, model: stat.model, period: period,
                                      games_back: stats.size, season_stat: num == nil })
      stat_container = ::Stat.build_model(stats).stat_container
      stat.update(stat_container)
    end

    def not_enough_stats(stats, num)
      return (num != nil && stats.size < num)
    end
  end
end
