module Builder
  module Rating
    extend self
    def run(games, period)
      games.each { |game| update_stats(game, period) }
    end

    def update_stats(game, period)
      puts "Game #{game.id}"
      game.stats.each do |stat|
        puts "Stat #{stat.id}"
        ortg = stat.calc_ortg
        drtg = stat.calc_drtg
        poss_percent = stat.calc_poss_percent
        stat.update(ortg: ortg, drtg: drtg, poss_percent: poss_percent)
      end
    end
  end
end
