module Builder
  module Rating
    extend self
    def run(season)
      loop do
        stats = ::Stat.where("season_id = #{season.id} AND ortg = 0.0 AND drtg = 0.0 AND poss_percent = 0.0").limit(100)
        stats.each_slice(10) do |slice|
          threads = []
          slice.each do |stat|
            threads << Thread.new do
              data = {}
              data[:ortg] = stat.calc_ortg
              data[:drtg] = stat.calc_drtg
              data[:poss_percent] = stat.calc_poss_percent
              Thread.current[:output] = data
            end
          end
          stat_data = threads.map do |thread|
            thread.join
            thread[:output]
          end
          slice.zip(stat_data).each do |stat, data|
            puts "Stat Update #{stat.id}"
            stat.update(data)
          end
        end
        break if stats.size == 0
      end
    end
  end
end
