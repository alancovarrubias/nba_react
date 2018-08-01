module Builder
  class Database
    attr_reader :year, :season, :teams, :players, :games
    include BasketballReference
    def initialize(year)
      @year = year
      @season = ::Season.find_by_year(year)
      if @season
        @teams = @season.teams
        @players = @season.players
        @games = @season.games
      end
    end

    def build
      build_seasons
      build_teams
      build_players
      build_games
      build_game_stats
      build_quarter_stats
=begin
      build_ratings
      build_bets
      build_lines
=end
    end

    def build_seasons
      Builder::Season.run(year)
      @season = ::Season.find_by_year(year)
    end

    def build_teams
      Builder::Team.run(season)
      @teams = @season.teams
    end

    def build_players
      Builder::Player.run(season, teams)
      @players = @season.players
    end

    def build_games
      Builder::Game.run(season, teams)
      @games = @season.games
    end

    def build_game_stats
      Builder::GameStat.run(season, games)
    end

    def build_quarter_stats
      Builder::QuarterStat.run(season, games)
    end

    def build_ratings
      Builder::Rating.run(season)
    end

    def build_bets
      Builder::Bet.run(games)
    end
    
    def build_lines(dates=nil)
      dates = dates ? dates : games.map(&:date).uniq
      Builder::Line.run(season, games, dates)
    end
  end
end
