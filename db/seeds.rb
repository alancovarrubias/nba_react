module Database
  (2010..2016).reverse_each do |year| 
    RatingBuilder.new(year).run
  end
end
