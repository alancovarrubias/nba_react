module Stats
  class TeamOrtg
    attr_react :team, :opponent
    def initialize(team, opponent)
      @team = team
      @opponent = opponent
    end

    def drtg
      return 100 * (opponent.pts / team.tot_poss)
    end

    def ortg
      return 100 * team.pts / team.tot_poss
    end

    private
      def tot_poss
        return 0.5 * ((team.fga + 0.4 * team.fta - 1.07 * team.orb_percent * (team.fga - team.fgm) + team.tov) + (opponent.fga + 0.4 * opponent.fta - 1.07 * opponent.orb_percent * (opponent.fga - opponent.fgm) + opponent.tov))
      end

      def pace
        return 48 * ((team.tot_poss + opponent.tot_poss) / (2 * (team.mp / 5)))
      end

      def orb_percent
        return team.orb / (team.orb + opponent.drb)
      end
  end
end
