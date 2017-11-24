class Game < ApplicationRecord
  belongs_to :season
  belongs_to :game_date
  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"
  has_many :periods, dependent: :destroy

  def away_season_stat(quarter)
    return season_stat(self.away_team, quarter)
  end

  def home_season_stat(quarter)
    return season_stat(self.home_team, quarter)
  end

  def season_stat(team, quarter)
    previous_game = n_game(1, team)
    season_game = season_game(team)
    interval = Interval.find_by(quarter: quarter, start_date: season_game.game_date, end_date: previous_game.game_date)
    return interval && interval.stats.find_by(statable: team)
  end

  def n_away_stat(n, quarter)
    return n_team_stat(self.away_team, n, quarter)
  end

  def n_home_stat(n, quarter)
    return n_team_stat(self.home_team, n, quarter)
  end

  def n_team_stat(team, n, quarter)
    first_game = n_game(n, team)
    last_game = n_game(1, team)
    interval = Interval.find_by(quarter: quarter, start_date: first_game.game_date, end_date: last_game.game_date)
    return interval.stats.find_by(games_played: n, statable: team)
  end

  def season_game(team)
    return Game.where("(away_team_id = #{team.id} OR home_team_id = #{team.id}) AND season_id = #{self.season.id}").order("id").first
  end

  def n_game(n, team)
    return Game.where("(away_team_id = #{team.id} OR home_team_id = #{team.id}) AND season_id = #{self.season.id} AND id < #{self.id}").order("id DESC").limit(n).last
  end

  def teams
    return away_team, home_team
  end

  def show_data
    away_team_name = self.away_team.name
    home_team_name = self.home_team.name
    period = self.full_game
    away_players = period.away_player_stats.map(&:stat_hash)
    home_players = period.home_player_stats.map(&:stat_hash)
    return { away_team: { name: away_team_name, players: away_players }, home_team: { name: home_team_name, players: home_players } }
  end

  def url
    "%d%02d%02d0#{home_team.abbr}" % [date.year, date.month, date.day]
  end

  def full_game
    periods.find_by(quarter: 0)
  end

  def quarters
    periods.where("quarter > 0 AND quarter < 5")
  end

  [0, 1, 2, 3, 4, 5, 6, 7].each do |quarter|
    define_method "stats#{quarter}" do
      period = periods.find_by(quarter: quarter)
      periods.stats.includes(:statable) if period
    end
  end

  def method_missing(name, *args, &block)
    game_date.send(name, *args, &block)
  end
end
