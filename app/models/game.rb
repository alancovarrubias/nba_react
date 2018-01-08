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
  types = ["game", "season", "prev"]
  
  def teams
    return [self.away_team, self.home_team]
  end

  def prev_games
    return Game.where("date < ?", self.date).order(date: :desc)
  end

  fields.each do |field|
    define_method("prev_#{field}_games") do
      team_id = self.send("#{field}_team_id")
      return self.prev_games.where("away_team_id=#{team_id} OR home_team_id=#{team_id}")
    end
  end

  periods.each do |period|
    models.each do |model|
      query_hash = { model_type: model.capitalize, period: period }
      define_method("#{model}_stats_#{period}") do
        return self.stats.where(query_hash)
      end
      define_method("#{model}_game_stats_#{period}") do
        return self.stats.where(query_hash.merge({ games_back: nil, season_stat: false }))
      end
      define_method("#{model}_season_stats_#{period}") do
        return self.stats.where(query_hash.merge({ season_stat: true }))
      end
      define_method("#{model}_prev_stats_#{period}") do |games_back|
        return self.stats.where(query_hash.merge({ season_stat: false, games_back: games_back }))
      end
      fields.each do |field|
        define_method("#{field}_#{model}_stats_#{period}") do
          team = self.send("#{field}_team")
          return model == "player" ? stats.select{|stat| stat.team == team} : stats.where(model: team)
        end
        stat = model == "player" ? "stats" : "stat"
        types.each do |type|
          if type == "prev"
            define_method("#{field}_#{model}_#{type}_#{stat}_#{period}") do |games_back|
              stats = self.send("#{model}_#{type}_stats_#{period}", games_back)
              team = self.send("#{field}_team")
              return model == "player" ? stats.select{|stat| stat.team == team} : stats.find_by(model: team)
            end
          else
            define_method("#{field}_#{model}_#{type}_#{stat}_#{period}") do
              stats = self.send("#{model}_#{type}_stats_#{period}")
              team = self.send("#{field}_team")
              return model == "player" ? stats.select{|stat| stat.team == team} : stats.find_by(model: team)
            end
          end
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
