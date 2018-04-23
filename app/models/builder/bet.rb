module Builder
  module Bet
    extend self
    extend SportsBookReview
    def run(games)
      dates = games.map(&:date).uniq
      build_lines(games, dates)
=begin
      games.each do |game|
        build_bet(game)
      end
=end
    end

    def build_lines(games, dates)
      dates.each do |date|
        date_str = date.to_s.tr('-', '')
        spread_path = "/betting-odds/nba-basketball/?date=#{date_str}"; spread_css = '.eventLine-opener .eventLine-book-value'
        total_path = "/betting-odds/nba-basketball/totals/?date=#{date_str}"; total_css = '.adjust'
        teams, spreads = get_line_data(spread_path, spread_css)
        teams, totals = get_line_data(total_path, total_css)
      end
    end

    def get_line_data(path, css)
      doc = sports_book_review(path)
      teams = doc.css('.team-name a').map { |elem| Team.find_by_city(elem.text) }
      lines = doc.css(css).each { |elem| puts elem }
      return teams, lines
    end
    
    def build_bet(game)
      puts "Bet #{game.id}"
      algorithm = Algorithm::Old.new(game)
      away_prediction, home_prediction = algorithm.predict_score(10)
      away_score = game.game_away_team_stat.pts
      home_score = game.game_home_team_stat.pts
      bet = ::Bet.find_or_create_by(game: game, period: 0, desc: 'old')
      bet.update(away_score: away_score, home_score: home_score, away_prediction: away_prediction, home_prediction: home_prediction)
    end
  end
end
