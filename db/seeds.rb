module Database
  (2010..2016).reverse_each do |year| 
    next unless year == 2016
    Builder.new(year).run
  end
end
