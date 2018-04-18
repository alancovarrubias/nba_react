module Builder
  module Rating
    extend self
    def run(season)
      stats = Stat.where("season_id = #{season.id} AND ortg = 0.0 AND drtg = 0.0 AND poss_percent = 0.0").limit(100)
      while stats.length != 0
        stats.each do |stat|
          puts "Rating Stat #{stat.id}"
          ortg = stat.calc_ortg
          drtg = stat.calc_drtg
          poss_percent = stat.calc_poss_percent
          stat.update(ortg: ortg, drtg: drtg, poss_percent: poss_percent)
        end
        stats = Stat.where("season_id = #{season.id} AND ortg = 0.0 AND drtg = 0.0 AND poss_percent = 0.0").limit(100)
      end
    end
  end
end
