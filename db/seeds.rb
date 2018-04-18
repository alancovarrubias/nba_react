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
database = Builder::Database.new(2016)
database.build
