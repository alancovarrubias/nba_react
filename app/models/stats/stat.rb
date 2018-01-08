module Stats
  class Stat
    attr_reader :stat
    def initialize(stats)
      @stat = build_stat(stats)
    end

    def build_stat(stats)
      model_type = stats.first.model_type
      team_stats = stats.map(&:team_stat)
      opp_stats = stats.map(&:opp_stat)
      self.stat = Stat.build_model(stats)
      team_stat = Stat.build_model(team_stats)
      opp_stat = Stat.build_model(opp_stats)
      self.stat.instance_variable_set(:@player_stat, Stats::Player.new(stat, team_stat, opp_stat)) if model_type == "Player"
      self.stat.instance_variable_set(:@team_stat, Stats::Team.new(stat, opp_stat)) if model_type == "Team"
    end

    def method_missing(method, *args, &block)
      self.stat.send(method, *args)
    end
  end
end
