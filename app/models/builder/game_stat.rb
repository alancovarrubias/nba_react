module Builder
  module GameStat
    include BasketballReference
    extend self
    ROW_INDICES = { sp: 1, fgm: 2, fga: 3, thpm: 5, thpa: 6, ftm: 8, fta: 9, orb: 11, drb: 12, ast: 14, stl: 15, blk: 16, tov: 17, pf: 18, pts: 19 }
    def run(season, games)
      period = 0
      games_back = 10
      games.each do |game|
        build_stats(season, game)
        TeamStat.build_team_stats(game, period)
        PrevStat.build_season_stats(game, period)
        PrevStat.build_prev_stats(game, period, games_back)
      end
    end
    private
      def build_stats(season, game)
        puts "#{game.url} #{game.id}"
        doc = basketball_reference("/boxscores/#{game.url}.html")
        game.teams.each do |team|
          abbr = team.abbr.downcase
          data = doc.css("#box_#{abbr}_basic tbody .right , #box_#{abbr}_basic tbody .left").to_a
          rows = create_rows(data)
          stats = create_stats(season, team, game, rows)
        end
      end

      def create_stats(season, team, game, rows)
        rows = rows.each_with_index.map do |row, index|
          player_stats = player_attr(row[0]).merge(season: season, team: team)
          player = ::Player.find_by(player_stats)
          starter = index <= 6
          stat = ::Stat.find_or_create_by(season: season, game: game, model: player, starter: starter, period: 0)
          next if row.size == 1
          stat_data = ROW_INDICES.map do |stat, index|
            text = row[index].text
            data = index == 1 && text.size != 0 ? parse_time(row[index]) : text.to_i
            [stat, data]
          end
          stat.update(Hash[stat_data])
        end
        return rows
      end

      def create_rows(data)
        rows = []
        row_num = 0
        row_size = data[20].name == "td" ? 21 : 20
        until data.empty?
          row_num += 1
          if data[0].text == "+/-"
            data.shift(1) 
            next
          end
          size = !data[1] || data[1].name == "td" ? row_size : 1
          row = data.shift(size)
          rows << row
        end
        return rows
      end
  end
end
