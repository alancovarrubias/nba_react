# (2017).downto(2000) do |year|
  year = 2017
  builder = Builder::Database.new(year)
  games = Game.where("id > 1321") 
  builder.build_quarter_stats(games)
# end
