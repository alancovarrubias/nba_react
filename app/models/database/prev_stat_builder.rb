module Database
  class PrevStatBuilder < Builder
    def run
      games.each { |game| build_stats(game, nil) }
    end

    def build_stats(game, num)
      game.prev_away_player_stats.each do |stat|
        stat.game = game
        stat.season = true unless num
      end
    end
  end
end
