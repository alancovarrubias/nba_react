module Builder
  module QuarterStat
    include BasketballReference
    extend self
    def run(season, games)
      games.each do |game|
        quarter = build_stats(season, game)
        (1..quarter).each do |period|
          TeamStat.build_team_stats(game, period)
          PrevStat.build_season_stats(game, period)
          PrevStat.build_prev_stats(game, 10, period)
        end
      end
    end

    def build_stats(season, game)
      puts "#{game.url} #{game.id}"
      stats = initialize_stats(game)
      away_lineup = Set.new
      home_lineup = Set.new
      @params = { season: season, game: game, stats: stats, quarter: 0, away_lineup: away_lineup, home_lineup: home_lineup, possessions: 0 }
      data = basketball_data("/boxscores/pbp/#{game.url}.html", "#pbp td").to_a
      build_player_stats(data)
      return @params[:quarter]
    end

    def initialize_stats(game)
      stats = game.game_player_stats(0)
      player_id_hashes = stats.map(&:player).map do |player|
        { id: player.id, idstr: player.idstr, team: player.team }
      end
      return Hash[player_id_hashes.map do |id_hash|
        stat = Stat.new.stat_container
        stat[:time] = 0
        stat[:starter] = false
        stat[:player_id] = id_hash[:id]
        stat[:team] = id_hash[:team]
        [id_hash[:idstr], stat]
      end]
    end

    def build_player_stats(data)
      until data.empty?
        row = data.shift(size(data))
        time = parse_time(row[0])
        add_stats(row[1], time)
        add_stats(row[5], time) unless row.size == 2
      end
    end

    def size(data)
      data[2].nil? || data[2].text.include?(":") ? 2 : 6
    end

    def add_stats(play, time)
      if play.text.size > 1
        player1, player2 = find_player_idstrs(play)
        @params.merge!(play: play.text, player1: player1, player2: player2, time: time)
        PlayParser.new(@params).add_stats
      end
    end

    def find_player_idstrs(play)
      player_idstrs = play.children.select { |child| child.class == Nokogiri::XML::Element }.map {|player| player.attributes['href'].value }
      return player_idstrs.map {|string| string[string.rindex('/')+1...string.index('.')]}
    end
  end
end
