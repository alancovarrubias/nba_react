module Stats
  class Period
    attr_reader :game, :period, :period_ids
    def initialize(period)
      @period = period
      @game = period.game
      @season = @game.season
      @period_ids = ::Period.joins(:game).where(:games => { :season_id => @season.id } ).where("quarter = #{period.quarter} AND game_id < #{@game.id}").map(&:id)
    end

    def prev_away_player_stats(num=nil)
      return period.away_player_stats.map do |stat|
        prev_player_stats(stat, num)
      end
    end

    def prev_home_player_stats(num=nil)
      return period.home_player_stats.map do |stat|
        prev_player_stats(stat, num)
      end
    end

    def prev_away_team_stat(num=nil)
      return prev_team_stats(period.away_team_stat, num)
    end
    
    def prev_home_team_stat(num=nil)
      return prev_team_stats(period.home_team_stat, num)
    end

    def prev_team_stats(stat, num=nil)
      stats = Stat.where("statable_id = #{stat.team.id} AND intervalable_type = 'Period' AND intervalable_id IN (?)", period_ids).order("intervalable_id DESC").limit(num)
      team_stat = build_stat(stats, stat.team)
      opp_stat = build_stat(stats.map(&:opp_stat), stat.opp)
      opp_stat.instance_variable_set(:@opp_stat, team_stat)
      team_stat.instance_variable_set(:@opp_stat, opp_stat)
      puts team_stat.calc_ortg
      return team_stat
    end

    def prev_player_stats(stat, num=nil)
      stats = Stat.includes(:statable).where("statable_id = #{stat.player.id} AND intervalable_type = 'Period' AND intervalable_id IN (?)", period_ids).order("intervalable_id DESC").limit(num)
      player_stat = build_stat(stats, stat.player)
      team_stat = build_stat(stats.map(&:team_stat), stat.team)
      opp_stat = build_stat(stats.map(&:opp_stat), stat.opp)
      player_stat.instance_variable_set(:@team_stat, team_stat)
      player_stat.instance_variable_set(:@opp_stat, opp_stat)
      team_stat.instance_variable_set(:@opp_stat, opp_stat)
      opp_stat.instance_variable_set(:@opp_stat, team_stat)
      return player_stat
    end

    def build_stat(stats, model)
      return Stat.new(sum_stats(stats.map(&:stat_container)).merge({ statable: model }))
    end

    def fill_stats(stats)
      team_stat = Stat.new(sum_stats(stats.map(&:team_stat).map(&:stat_container)))
      opp_stat = Stat.new(sum_stats(stats.map(&:opp_stat).map(&:stat_container)))
      player_stat = Stat.new(sum_stats(stats.map(&:stat_container)))
      team = Stats::Team.new(team_stat, opp_stat)
      opp = Stats::Team.new(opp_stat, team_stat)
      player = Stats::Player.new(player_stat, team_stat, opp_stat)
      puts player.p_prod
      puts player.tot_poss
      player_stat.ortg = player.calc_ortg
      player_stat.drtg = player.calc_drtg
      return player_stat
    end
    
    def sum_stats(stats)
      return stats.inject { |mem, hash| mem.merge(hash) { |key, old, new| old + new } }
    end
  end
end
