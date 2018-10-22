(2008..2018).each do |year|
  puts "Build #{year} Stats"
  builder = Builder::Database.new(year)
  builder.build
end
