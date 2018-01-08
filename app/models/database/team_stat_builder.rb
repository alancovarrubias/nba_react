module Database
  class TeamStatBuilder < Builder
    def run
      games.each { |game| build_stats(game) }
    end

    def build_stats(game)
      puts "Game ID: #{game.id} Team Stats"
      fields = ["away", "home"]
      fields.each do |field|
        team = game.send("#{field}_team")
        player_stats = game.send("#{field}_player_game_stats_0").map(&:stat_container)
        query_hash = {season: game.season, game: game, model: team, games_back: nil, season_stat: false, period: 0 }
        team_stat = Stat.find_or_create_by(query_hash)
        team_stat_hash = player_stats.inject {|memo, el| memo.merge(el) {|key, old, new| old + new}}
        team_stat.update(team_stat_hash)
      end
    end
  end
end
