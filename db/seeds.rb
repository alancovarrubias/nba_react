# Database::PrevStatBuilder.new(2016).run
# Database::PrevStatBuilder.new(2016).run(10)
# Database::PrevStatBuilder.new(2016).run
# Database::PrevStatBuilder.new(2016).run(10)
# Database::RatingBuilder.new(2016).run

=begin
games = Game.all[0..100]
games.each do |game|
  Algorithm::Old.new(game)
end
database = Builder::Database.new(2016)
database.build
=end

# (2017).downto(2006) do |year|
  year = 2017
  builder = Builder::Database.new(year)
  date = Date.new(2017, 1, 19)
  dates = Season.find_by_year(year).games.where("date >= ?", date).map(&:date).uniq
  builder.build_lines(dates)
=begin
=end
# end

