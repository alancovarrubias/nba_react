class Stat < ApplicationRecord
  STATS = [:id, :sp, :fgm, :fga, :thpm, :thpa, :ftm, :fta, :orb, :drb, :ast, :stl, :blk, :tov, :pf, :pts, :ortg, :drtg]
  STAT_CONTAINER = [:sp, :fgm, :fga, :thpm, :thpa, :ftm, :fta, :orb, :drb, :ast, :stl, :blk, :tov, :pf, :pts]
  belongs_to :statable, polymorphic: true
  belongs_to :intervalable, polymorphic: true

  def player
    @player ||= statable if statable_type == "Player"
  end

  def name
    player.name
  end

  def team
    @team ||= statable_type == "Team" ? statable : statable.team
  end

  def opp
    game = intervalable.game
    @opp ||= team == game.away_team ? game.home_team : game.away_team
  end

  def team_stat
    @team_stat ||= Stat.find_by(intervalable: intervalable, statable: team)
  end

  def opp_stat
    @opp_stat ||= Stat.find_by(intervalable: intervalable, statable: opp)
  end

  def method_missing(method, *args, &block)
    @player_stat ||= Stats::Player.new(self, team_stat, opp_stat) if statable_type == "Player"
    @team_stat ||= Stats::Team.new(self, opp_stat) if statable_type == "Team"
    return @player_stat.send(method, *args) if statable_type == "Player"
    return @team_stat.send(method, *args)  if statable_type == "Team"
  end

  def stat_container
    Hash[self.attributes.map{|key, value| [key.to_sym, value]}.select{|key, value| STAT_CONTAINER.include?(key)}]
  end

  def stat_hash
    hash = Hash[self.attributes.map{|key, value| [key.to_sym, value]}.select{|key, value| STATS.include?(key)}]
    hash[:name] = self.name
    hash
  end

  def self.stat_hash
    Hash[STAT_CONTAINER.map {|stat| [stat, 0]}]
  end

  def mp
    sp/60.0
  end

  def mp_str
    minutes = sp/60
    seconds = "#{sp%60}".rjust(2, "0")
    "#{minutes}:#{seconds}"
  end
end
