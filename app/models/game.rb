class Game < ApplicationRecord
  belongs_to :season
  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"
  has_many :stats, -> { includes(:player, :team).order(sp: :desc) }, dependent: :destroy
  has_many :bets
  has_many :lines

  fields = ["away", "home"]
  models = ["player", "team"]
  periods = [0]
  types = ["game", "season"]

  def teams
    return [self.away_team, self.home_team]
  end
  
  def prev_games
    return Game.where(season: season).where("date < ?", self.date).order(date: :desc)
  end

  fields.each do |field|
    define_method("prev_#{field}_games") do
      team_id = self.send("#{field}_team_id")
      return self.prev_games.where("away_team_id=#{team_id} OR home_team_id=#{team_id}")
    end
  end

  def period_stats(period=0)
    stats.where(period: period)
  end

  def game_stats(period=0)
    period_stats(period).where(games_back: nil, season_stat: false)
  end

  def season_stats(period=0)
    period_stats(period).where(season_stat: true)
  end

  def prev_stats(num, period=0)
    period_stats(period).where(season_stat: false, games_back: num)
  end

  models.each do |model|
    query = { model_type: model.capitalize }
    types.each do |type|
      define_method("#{type}_#{model}_stats") do |period=0|
        return self.send("#{type}_stats", period).where(query)
      end
      define_method("prev_#{model}_stats") do |num, period=0|
        return self.send("prev_stats", num, period).where(query)
      end
      fields.each do |field|
        stat = model == "player" ? "stats" : "stat"
        define_method("#{type}_#{field}_#{model}_#{stat}") do |period=0|
          stats = self.send("#{type}_#{model}_stats", period)
          team = self.send("#{field}_team_id")
          return model == "player" ? stats.where(players: { team: team }) : stats.find_by(team: team)
        end
        define_method("prev_#{field}_#{model}_#{stat}") do |num, period=0|
          stats = self.send("prev_#{model}_stats", num, period)
          team = self.send("#{field}_team")
          return model == "player" ? stats.where(players: { team: team }) : stats.find_by(team: team)
        end
      end
    end
  end

  def show_data
    away_team_name = self.away_team.name
    home_team_name = self.home_team.name
    away_players = self.game_away_player_stats.map(&:stat_hash)
    home_players = self.game_home_player_stats.map(&:stat_hash)
    return {
      season: { id: season.id, year: season.year },
      away_team: { name: away_team_name, players: away_players },
      home_team: { name: home_team_name, players: home_players }
    }
  end

  def url
    "%d%02d%02d0#{home_team.abbr}" % [date.year, date.month, date.day]
  end

  def method_missing(method, *args, &block)
    @game_stat ||= Stats::Game.new(self)
    return @game_stat.send(method, *args)
  end
end
