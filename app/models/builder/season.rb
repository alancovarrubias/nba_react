module Builder
  module Season
    extend self
    def run(year)
      ::Season.find_or_create_by(year: year)
    end
  end
end
