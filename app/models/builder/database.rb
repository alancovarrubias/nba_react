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
      build_team_stats
      build_season_stats
      build_prev_stats(10)
      build_ratings
      build_bets
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

    def build_team_stats
      Builder::TeamStat.run(games)
    end

    def build_game_stats
      Builder::GameStat.run(season, games)
    end

    def build_quarter_stats
      Builder::QuarterStat.run(games)
    end

    def build_season_stats(period=0)
      build_prev_stats(nil, period)
    end

    def build_prev_stats(num, period=0)
      Builder::PrevStat.run(season, games, num, period)
    end

    def build_ratings
      Builder::Rating.run(season)
    end

    def build_bets
      Builder::Bet.run(games)
    end
  end
end
