module Database
  (2010..2016).reverse_each do |year| 
    Builder.new(year).run
  end
end
