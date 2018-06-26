module Builder
  module Line
    extend self
    extend SportsBookReview
    def run(season, games, dates)
      @season = season
      dates.each do |date|
        date_str = date.to_s.tr("-", "")
        spread_path = "/betting-odds/nba-basketball/?date=#{date_str}"; spread_css = ".eventLine-opener .eventLine-book-value"
        total_path = "/betting-odds/nba-basketball/totals/?date=#{date_str}"; total_css = ".adjust"
        teams, spreads = get_line_data("spread", spread_path, spread_css)
        teams, totals = get_line_data("total", total_path, total_css)
        date_games = games.where(date: date)
        teams.each_with_index do |team, index|
          game = date_games.find_by(home_team: team)
          spread = spreads[index]
          total = totals[index]
          line = ::Line.find_or_create_by(game: game, period: 0, desc: "opener")
          line.update(total: total, spread: spread)
        end
      end
    end

    def get_line_data(type, path, css)
      puts type
      doc = sports_book_review(path)
      team_data = doc.css(".team-name a").map do |element|
        id = element["href"].match(/\d{5}\/$/)[0].chomp("/")
        team = get_team(element.text)
        { id: id, team: team }
      end
      line_data = doc.css(css).map do |element|
        text = element.text
        get_line_number(type, text) unless text.length == 0
      end
      teams = []
      lines = []
      until team_data.empty?
        if team_data[0][:id] == team_data[1][:id]
          team_slice = team_data.shift(2)
          line_slice = line_data.shift(2)
          teams << team_slice[1][:team]
          lines << line_slice[1]
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
        num = /.*-/.match(text).to_s[0..-3]
        if num[-1].ord == 189
          return num[0...-1].to_i.send(num[0], 0.5)
        else
          return num.to_i
        end
      end
    end
  end
end
