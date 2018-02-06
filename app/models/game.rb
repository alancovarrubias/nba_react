class Game < ApplicationRecord
  belongs_to :season
  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"
  has_many :stats, -> { includes(:season, :game, :model).order(sp: :desc) }, dependent: :destroy
  has_many :bets
  default_scope { includes(:away_team, :home_team, :season) }

  fields = ["away", "home"]
  models = ["player", "team"]
  periods = [0]
  types = ["game", "season"]

  def teams
    return [self.away_team, self.home_team]
  end
  
  fields.each do |field|
    define_method("prev_#{field}_games") do
      team_id = self.send("#{field}_team_id")
      return self.prev_games.where("away_team_id=#{team_id} OR home_team_id=#{team_id}")
    end
  end

  def prev_games
    return Game.where(season: season).where("date < ?", self.date).order(date: :desc)
  end

  def game_stats
    stats.where(games_back: nil, season_stat: false)
  end

  def season_stats
    stats.where(season_stat: true)
  end

  def prev_stats(num)
    stats.where(season_stat: false, games_back: num)
  end

  models.each do |model|
    query = { model_type: model.capitalize }
    types.each do |type|
      define_method("#{type}_#{model}_stats") do |period=0|
        return self.send("#{type}_stats").where(query.merge({ period: period }))
      end
      define_method("prev_#{model}_stats") do |num, period=0|
        return self.send("prev_stats", num).where(query.merge({ period: period }))
      end
      fields.each do |field|
        stat = model == "player" ? "stats" : "stat"
        define_method("#{type}_#{field}_#{model}_#{stat}") do |period=0|
          stats = self.send("#{type}_#{model}_stats")
          team_id = self.send("#{field}_team_id")
          return model == "player" ? stats.select { |stat| stat.model.team_id == team_id } : stats.find_by(model_id: team_id)
        end
        define_method("prev_#{field}_#{model}_#{stat}") do |num, period=0|
          stats = self.send("prev_#{model}_stats", num, period)
          team_id = self.send("#{field}_team_id")
          return model == "player" ? stats.select { |stat| stat.model.team_id == team_id } : stats.find_by(model_id: team_id)
        end
      end
    end
  end

  def show_data
    away_team_name = self.away_team.name
    home_team_name = self.home_team.name
    away_players = self.away_player_game_stats_0.map(&:stat_hash)
    home_players = self.home_player_game_stats_0.map(&:stat_hash)
    return { away_team: { name: away_team_name, players: away_players }, home_team: { name: home_team_name, players: home_players } }
  end

  def url
    "%d%02d%02d0#{home_team.abbr}" % [date.year, date.month, date.day]
  end

  def method_missing(method, *args, &block)
    @game_stat ||= Stats::Game.new(self)
    return @game_stat.send(method, *args)
  end
end
