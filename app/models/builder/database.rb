module Builder
  class Database
    attr_reader :year, :season, :teams, :players
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
      Builder::Season::Builder.run(year)
      @season = ::Season.find_by_year(year)
    end

    def build_teams
      Builder::Team::Builder.run(season)
      @teams = @season.teams
    end

    def build_players
      Builder::Player::Builder.run(season, teams)
      @players = @season.players
    end

    def build_games
      Builder::Game::Builder.run(season, teams)
      @games = @season.games
    end

    def build_game_stats(games=nil)
      games = games ? games : @games
      Builder::Game::Stats.build(@season, games)
    end

    def build_quarter_stats(games=nil)
      games = games ? games : @games
      Builder::Quarter::Stats.build(@season, games)
    end

    def build_ratings
      stats = ::Stat.where("season_id = #{@season.id} AND ortg = 0.0 AND drtg = 0.0 AND poss_percent = 0.0").limit(100)
      Builder::Stats::Ratings.run(stats)
    end

    def build_bets
      Builder::Bet::Builder.run(@games)
    end
    
    def build_lines(dates=nil)
      dates = dates ? dates : @games.map(&:date).uniq
      Lines::Builder.run(season, @games, dates)
    end
  end
end
