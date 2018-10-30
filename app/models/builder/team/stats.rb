module Builder
  module Team
    module Stats
      extend self
      def build(game, period, prev_games=[])
        @season = game.season
        @game = game
        @period = period
        fields = ["away", "home"]
        types = ["game", "season", "prev"]
        types.each do |type|
          fields.each do |field|
            team = game.send("#{field}_team")
            if type == "prev"
              prev_games.each do |games_back|
                player_stats = @game.send("#{type}_#{field}_player_stats", games_back, @period).map(&:stat_container)
                build_stat(team, player_stats, field, type, games_back)
              end
            else
              player_stats = @game.send("#{type}_#{field}_player_stats", @period).map(&:stat_container)
              build_stat(team, player_stats, field, type)
            end
          end
        end
      end

      def build_stat(team, player_stats, field, type, games_back=nil)
        return if player_stats.empty?
        games_back = @game.send("prev_#{field}_games").size if type == "season"
        query_hash = { season: @season, game: @game, model: team, games_back: games_back, season_stat: type == "season", period: @period }
        team_stat = ::Stat.find_or_create_by(query_hash)
        team_stat_hash = player_stats.inject {|memo, el| memo.merge(el) {|key, old, new| old + new}}
        team_stat.update(team_stat_hash)
      end
    end
  end
end
