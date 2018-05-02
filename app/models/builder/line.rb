module Builder
  module Line
    extend self
    extend SportsBookReview
    def run(games)
      dates = games.map(&:date).uniq
      build_lines(games, dates)
    end
    def build_lines(games, dates)
      dates.each do |date|
        date_str = date.to_s.tr('-', '')
        spread_path = "/betting-odds/nba-basketball/?date=#{date_str}"; spread_css = '.eventLine-opener .eventLine-book-value'
        total_path = "/betting-odds/nba-basketball/totals/?date=#{date_str}"; total_css = '.adjust'
        teams, spreads = get_line_data('spread', spread_path, spread_css)
        teams, totals = get_line_data('total', total_path, total_css)
        date_games = games.where(date: date)
        teams.each_with_index do |team, index|
          game = date_games.find_by(home_team: team)
          spread = spreads[index]
          total = totals[index]
          line = ::Line.find_or_create_by(game: game, period: 0, desc: 'opener')
          line.update(total: total, spread: spread)
        end
      end
    end

    def get_line_data(type, path, css)
      doc = sports_book_review(path)
      teams = doc.css('.team-name a').each_slice(2).map do |slice|
        text = slice[1].text
        get_team(text)
      end
      lines = doc.css(css).each_slice(2).map do |slice|
        text = slice[1].text
        get_line_number(type, text) unless text.length == 0
      end
      return teams, lines
    end

    def get_team(text)
      case text
      when /Clippers/
        return Team.find_by_name('Clippers')
      when /Lakers/
        return Team.find_by_name('Lakers')
      else
        return Team.find_by_city(text)
      end
    end

    def get_line_number(type, text)
      if type == 'total'
        if text[-1].ord == 189
          return text[0...-1].to_i + 0.5
        else
          return text[0..-1].to_i
        end
      elsif type == 'spread'
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
