module Builder
  module Lines
    module Builder
      extend self
      extend SportsBookReview
      URL_PATH = {
        0 => "",
        1 => "1st-quarter/",
        2 => "2nd-quarter/",
        3 => "3rd-quarter/",
        4 => "4th-quarter/",
        12 => "1st-half/",
        34 => "2nd-half/"
      }
      PERIODS = [0, 1, 2, 3, 4]
      def run(season, games, dates)
        @season = season
        dates.each do |date|
          PERIODS.each do |period|
            build_line(date, period, games)
          end
        end
      end

      def build_line(date, period, games)
        url_path = URL_PATH[period]
        date_str = date.to_s.tr("-", "")
        spread_path = "/betting-odds/nba-basketball/pointspread/#{url_path}?date=#{date_str}"; spread_css = "._2cc9d ._3Nv_7"
        total_path = "/betting-odds/nba-basketball/totals/#{url_path}?date=#{date_str}"; total_css = "._2cc9d span"
        teams, spreads = get_line_data("spread", spread_path, spread_css)
        teams, totals = get_line_data("total", total_path, total_css)
        date_games = games.where(date: date)
        teams.each_with_index do |team, index|
          game = date_games.find_by(home_team: team)
          spread = spreads[index]
          total = totals[index]
          line = ::Line.find_or_create_by(game: game, period: period, desc: "opener")
          line.update(total: total, spread: spread)
        end
      end

      def get_line_data(type, path, css)
        doc = sports_book_review(path)
        team_data = doc.css("._2nxl1").map do |element|
          id = element["href"].match(/\d{7}\//)[0].chomp("/")
          team = get_team(element.text)
          { id: id, team: team }
        end
        slice_size = type == "total" ? 6 : 2
        line_data = doc.css(css).each_slice(slice_size).map do |slice|
          element = slice[1]
          text = element.text
          get_line_number(type, text) unless text.length == 0
        end
        teams = []
        lines = []
        until team_data.empty?
          if team_data[0][:id] == team_data[1][:id]
            team_slice = team_data.shift(2)
            line_slice = line_data.shift(1)
            teams << team_slice[1][:team]
            lines << line_slice[0]
          else
            team_data.shift(1)
            line_data.shift(1)
          end
        end
        return teams, lines
      end

      def get_team(text)
        teams = @season.teams
        case text
        when /Clippers/
          return teams.find_by_name("Clippers")
        when /Lakers/
          return teams.find_by_name("Lakers")
        else
          return teams.find_by_city(text)
        end
      end

      def get_line_number(type, text)
        if type == "total"
          if text[-1].ord == 189
            return text[0...-1].to_i + 0.5
          else
            return text[0..-1].to_i
          end
        elsif type == "spread"
          if text[-1].ord == 189
            return text[0...-1].to_i.send(text[0], 0.5)
          else
            return text.to_i
          end
        end
      end
    end
  end
end
