module SportsBookReview
  require 'open-uri'
  def sports_book_review(path)
    url = File.join('http://www.sportsbookreview.com', path)
    puts url
    return Nokogiri::HTML(open(url))
  end

  def sports_book_data(path, css)
    doc = sports_book_review(path)
    return doc.css(css) if doc
  end
end
