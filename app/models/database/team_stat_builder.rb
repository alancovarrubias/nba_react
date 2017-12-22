module Database
  class TeamStatBuilder < Builder
    def run
      games.each { |game| build_stats(game) }
    end

    def build_stats(game)
      puts "Game ID: #{game.id} Team Stats"
      player_stats = game.stats.where(model_type: "Player", period: 0)
      [game.away_team, game.home_team].each do |team|
        team_player_stats = player_stats.select {|player_stat| player_stat.team == team}.map(&:stat_container)
        team_stat = team_player_stats.inject {|memo, el| memo.merge(el) {|key, old, new| old + new}}.merge({season: season, game: game, model: team})
        team_stat = Stat.find_or_create_by(team_stat)
      end
      player_stats.each do |player_stat|
        player_stat.update(ortg: player_stat.calc_ortg)
        player_stat.update(drtg: player_stat.calc_drtg)
      end
    end
  end
end
