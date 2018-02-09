class Stat < ApplicationRecord
  STATS = [:id, :sp, :fgm, :fga, :thpm, :thpa, :ftm, :fta, :orb, :drb, :ast, :stl, :blk, :tov, :pf, :pts, :ortg, :drtg]
  STAT_CONTAINER = [:sp, :fgm, :fga, :thpm, :thpa, :ftm, :fta, :orb, :drb, :ast, :stl, :blk, :tov, :pf, :pts]
  belongs_to :season
  belongs_to :game
  belongs_to :model, polymorphic: true
  belongs_to :team, -> { includes(:stats).where(stats: { model_type: 'Team' }) }, foreign_key: :model_id
  belongs_to :player, -> { includes(:stats).where(stats: { model_type: 'Player' }) }, foreign_key: :model_id
  def player
    return unless model_type == "Player"
    super
  end
  def team
    return player.team unless model_type == "Team"
    super
  end

  def self.stat_hash
    return Hash[STAT_CONTAINER.map {|stat| [stat, 0]}]
  end

  def self.build_model(stats)
    model_type = stats.first.model_type
    return Stat.new(sum_stats(stats.map(&:stat_container)).merge({ model_type: model_type }))
  end

  def self.sum_stats(stats)
    return stats.inject(self.stat_hash) { |mem, hash| mem.merge(hash) { |key, old, new| old + new } }
  end

  def stats
    query_hash = { season: season, season_stat: season_stat }
    query_hash.merge!({ games_back: games_back }) unless season_stat
    return Stat.where(query_hash)
  end

  def game_stats
    stats.where(game: game)
  end

  def model_stats
    stats.where(model: model)
  end

  def prev_stats
    model_stats.where("game_id < #{game_id}").order(game_id: :desc)
  end

  def prev_ranged_stats(poss_percent, range)
    prev_stats.where("poss_percent < #{poss_percent + range} AND poss_percent > #{poss_percent - range}")
  end

  def name
    model.name
  end

  def opp
    opp ||= (team == game.away_team) ? game.home_team : game.away_team if self.game
  end

  def team_stat
    @team_stat ||= game_stats.find_by(model: self.team) if self.game
    return @team_stat
  end

  def opp_stat
    @opp_stat ||= game_stats.find_by(model: self.opp) if self.game
    return @opp_stat
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
    @stat_proxy ||= Stats::Player.new(self, team_stat, opp_stat) if model_type == "Player"
    @stat_proxy ||= Stats::Team.new(self, opp_stat) if model_type == "Team"
    return @stat_proxy.send(method, *args)
  end
end
