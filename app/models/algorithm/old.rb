module Algorithm
  class Old
    attr_reader :games
    def initialize(season, games=nil)
      @season = season
      @games = games || season.games
    end

    # Input: days back from 
    def run(days)
      @season_stats = {}
      @prev_stats = {}
      games.each do |game|
        predict_score(game)
      end
    end

    def predict_score(game)
      away_team = game.away_team
      home_team = game.home_team
      numerator = 0
      denominator = 0
      game.away_players.each do |player|
        season_stat = @season_stats[player]
        prev_stat = @orev_stat[player]
      end
    end
  end
end
