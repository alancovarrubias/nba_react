module Builder
  module Bet
    extend self
    def run(games)
      games.each do |game|
        build_bet(game)
      end
    end
    
    def build_bet(game)
      puts "Bet #{game.id}"
      algorithm = Algorithm::Old.new(game)
      score = algorithm.predict_score(10)
      bet = ::Bet.find_or_create_by(game: game, period: 0, desc: "old")
      bet.update(score: score)
    end
  end
end
