module Builder
  module Rating
    extend self
    def run(season)
      Stat.where("season_id = #{season.id} AND (ortg = 0.0 OR drtg = 0.0 OR poss_percent = 0.0)").each do |stat|
        puts "Rating Stat #{stat.id}"
        ortg = stat.calc_ortg
        drtg = stat.calc_drtg
        poss_percent = stat.calc_poss_percent
        stat.update(ortg: ortg, drtg: drtg, poss_percent: poss_percent)
      end
    end
  end
end
