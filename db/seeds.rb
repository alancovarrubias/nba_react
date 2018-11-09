
# (2016..2018).each do |year|
  year = 2015
  builder = Builder::Database.new(year)
  dates = [Date.new(2015, 4, 30)]
  builder.build_lines(dates)
# end
=begin
builder.build_quarter_stats(Game.where(id: 3882))

builder.build_ratings

(2008..2018).each do |year|
  puts "Build #{year} Stats"
  builder = Builder::Database.new(year)
  builder.build
end

=end

# delete 201503160GSW
