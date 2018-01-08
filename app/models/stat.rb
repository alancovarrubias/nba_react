class Stat < ApplicationRecord
  STATS = [:id, :sp, :fgm, :fga, :thpm, :thpa, :ftm, :fta, :orb, :drb, :ast, :stl, :blk, :tov, :pf, :pts, :ortg, :drtg]
  STAT_CONTAINER = [:sp, :fgm, :fga, :thpm, :thpa, :ftm, :fta, :orb, :drb, :ast, :stl, :blk, :tov, :pf, :pts]
  belongs_to :season
  belongs_to :game
  belongs_to :model, polymorphic: true

  def self.stat_hash
    return Hash[STAT_CONTAINER.map {|stat| [stat, 0]}]
  end

  def self.build_model(stats)
    return Stat.new(sum_stats(stats.map(&:stat_container)))
  end

  def self.sum_stats(stats)
    return stats.inject(self.stat_hash) { |mem, hash| mem.merge(hash) { |key, old, new| old + new } }
  end

  def previous_ranged_stats(range)
    return previous_stats.where("poss_percent < #{self.poss_percent + range} OR poss_percent > #{self.poss_percent - range}")
  end

  def previous_stats
    return Stat.where(season: self.season, model: self.model).where("game_id < #{self.game_id}").order(game_id: :desc)
  end

  def similar_stats
    query_hash = { season: self.season, game: self.game, season_stat: self.season_stat }
    query_hash.merge!({ games_back: self.games_back }) unless self.season_stat
    return Stat.where(query_hash)
  end

  def name
    model.name
  end

  def player
    @player ||= model if model_type == "Player"
    return @player
  end

  def team
    @team ||= model_type == "Team" ? model : model.team
    return @team
  end

  def opp
    opp ||= team == game.away_team ? game.home_team : game.away_team if self.game
  end

  def team_stat
    @team_stat ||= similar_stats.find_by(model: self.team) if self.game
    return @team_stat
  end

  def opp_stat
    @opp_stat ||= similar_stats.find_by(model: self.opp) if self.game
    return @opp_stat
  end

  def prev_stats(num=nil)
    return Stat.where(season: season, games_back: self.games_back, season_stat: self.season_stat, model: self.model)
           .where("game_id < #{self.game_id}").order(game_id: :desc).limit(num)
  end

  def stat_container
    return Hash[self.attributes.map{|key, value| [key.to_sym, value]}.select{|key, value| STAT_CONTAINER.include?(key)}]
  end

  def stat_hash
    hash = Hash[self.attributes.map{|key, value| [key.to_sym, value]}.select{|key, value| STATS.include?(key)}]
    hash[:name] = self.name
    return hash
  end

  def mp
    return sp/60.0
  end

  def mp_str
    minutes = sp/60
    seconds = "#{sp%60}".rjust(2, "0")
    return "#{minutes}:#{seconds}"
  end

  def method_missing(method, *args, &block)
    @player_stat ||= Stats::Player.new(self, team_stat, opp_stat) if model_type == "Player"
    @team_stat ||= Stats::Team.new(self, opp_stat) if model_type == "Team"
    return @player_stat.send(method, *args) if model_type == "Player"
    return @team_stat.send(method, *args)  if model_type == "Team"
  end
end
