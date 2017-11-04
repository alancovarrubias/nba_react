module Database
  class TeamStatBuilder < Builder
    def run
      games.each { |game| build_stats(game) }
    end

    def build_stats(game)
      puts "Game ID: #{game.id} Team Stats"
      period = game.periods.find_by(quarter: 0)
      player_stats = period.stats.where(statable_type: "Player")
      [game.away_team, game.home_team].each do |team|
        team_player_stats = player_stats.select {|player_stat| player_stat.team == team}.map(&:stat_container)
        team_stat = team_player_stats.inject {|memo, el| memo.merge(el) {|key, old, new| old + new}}.merge({intervalable: period, statable: team})
        team_stat = Stat.find_or_create_by!(team_stat)
      end
    end
  end
end
