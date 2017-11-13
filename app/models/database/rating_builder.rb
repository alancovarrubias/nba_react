module Database
  class RatingBuilder < Builder
    def run
      games.each { |game| build_ratings(game) }
    end

    private
      def build_ratings(game)
        puts game.url
        game.periods.each do |period|
          period.stats.each do |stat|
            stat.update(ortg: stat.calc_ortg, drtg: stat.calc_drtg)
          end
        end
      end
  end
end
