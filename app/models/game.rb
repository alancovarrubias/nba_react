class Game < ApplicationRecord
  belongs_to :season
  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"
  has_many :stats, -> { includes(:season, :game, :model).order(sp: :desc) }, dependent: :destroy
  has_many :bets
  default_scope { includes(:away_team, :home_team, :season) }

  def player_stats
    stats.where(model_type: "Player")
  end

  def team_stats
    stats.where(model_type: "Team")
  end

  def away_team_stat
    stats.find_by(model: game.away_team)
  end

  def home_team_stat
    stats.find_by(model: game.home_team)
  end

  def away_player_stats
    player_stats.select{|stat| stat.team == self.away_team}
  end

  def home_player_stats
    player_stats.select{|stat| stat.team == self.home_team}
  end

  def away_players
    away_player_stats.map(&:model)
  end

  def home_players
    home_player_stats.map(&:model)
  end

  def method_missing(method, *args, &block)
    @game_stat ||= Stats::Game.new(self)
    return @game_stat.send(method, *args)
  end

  def teams
    return away_team, home_team
  end

  def show_data
    away_team_name = self.away_team.name
    home_team_name = self.home_team.name
    away_players = away_player_stats.map(&:stat_hash)
    home_players = home_player_stats.map(&:stat_hash)
    return { away_team: { name: away_team_name, players: away_players }, home_team: { name: home_team_name, players: home_players } }
  end

  def url
    "%d%02d%02d0#{home_team.abbr}" % [date.year, date.month, date.day]
  end
end
