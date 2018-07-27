module Builder
  module Bet
    extend self
    extend SportsBookReview
    PERIODS = [0, 1, 2, 3, 4]
    def run(games)
      PERIODS.each do |period|
        games.each { |game| build_bet(game, period) }
      end
    end

    def build_bet(game, period)
      puts "Bet #{game.id}"
      algorithm = Algorithm::Old.new(game)
      away_prediction, home_prediction = algorithm.predict_score(10)
      away_score = game.game_away_team_stat(period).pts
      home_score = game.game_home_team_stat(period).pts
      bet = ::Bet.find_or_create_by(game: game, period: period, desc: "old")
      bet.update(
        away_score: away_score, home_score: home_score,
        away_prediction: away_prediction, home_prediction: home_prediction
      )
    end
  end
end
