
year = 2015
builder = Builder::Database.new(year)
builder.build
=begin
builder.build_quarter_stats(Game.where(id: 3882))

builder.build_ratings

(2008..2018).each do |year|
  puts "Build #{year} Stats"
  builder = Builder::Database.new(year)
  builder.build
end

=end
