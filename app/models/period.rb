class Period < ApplicationRecord
  # has_many :stats, -> { includes(:statable) }, as: :intervalable, dependent: :destroy
  has_many :stat_joins, as: :interval
  belongs_to :game
  def player_stats
    stats.where(statable_type: "Player")
  end

  def team_stats
    stats.where(statable_type: "Team")
  end

  def away_team_stat
    stats.find_by(statable: game.away_team)
  end

  def home_team_stat
    stats.find_by(statable: game.home_team)
  end

  def away_player_stats
    player_stats.select{|stat| stat.team == game.away_team}
  end

  def home_player_stats
    player_stats.select{|stat| stat.team == game.home_team}
  end

  def away_players
    away_player_stats.map(&:player)
  end

  def home_players
    home_player_stats.map(&:player)
  end

  def away_team
    game.away_team
  end

  def home_team
    game.home_team
  end

  def method_missing(method, *args, &block)
    @period_stat ||= Stats::Period.new(self)
    return @period_stat.send(method, *args)
  end
end
