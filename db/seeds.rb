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
=end

game = Game.last
alg = Algorithm::Old.new(game)
alg.predict_score(10)
