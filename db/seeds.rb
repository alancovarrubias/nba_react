year = 2015
(2014).downto(2000).each do |year|
  puts year
  builder = Builder::Database.new(year)
  builder.build
end
