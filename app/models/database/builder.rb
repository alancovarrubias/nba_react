module Database
  class Builder
    attr_reader :year, :season, :teams, :players, :games
    include BasketballReference
    def initialize(year)
      @year = year
      @season = Season.find_by_year(year)
      if @season
        @teams = @season.teams
        @players = @season.players
        @games = @season.games
      end
    end

    def run
      [SeasonBuilder, TeamBuilder, GameBuilder, PlayerBuilder, GameStatBuilder, TeamStatBuilder].each do |klass|
        builder = klass.new(year)
        builder.run
      end
    end
  end
end
