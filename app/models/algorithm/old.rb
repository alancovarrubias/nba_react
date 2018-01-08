module Algorithm
  class Old
    attr_reader :game
    def initialize(game)
      @game = game
    end
    def predict_score(games_back)
      possessions = predict_possessions(games_back)
      away_player_stats = game.away_player_game_stats_0
      home_player_stats = game.home_player_game_stats_0
      away_team_ortg = predict_team_ortg(away_player_stats)
      home_team_ortg = predict_team_ortg(home_player_stats)
      away_score = away_team_ortg * possessions / 100
      home_score = home_team_ortg * possessions / 100
      return away_score + home_score
    end

    def predict_team_ortg(stats)
      poss_percent_sum = 0
      predictions = stats.map do |stat|
        poss_percent = self.predict_player_poss_percent(stat)
        poss_percent_sum += poss_percent
        ortg = self.predict_player_ortg(stat)
        poss_percent * ortg
      end
      return (predictions.inject(0) {|mem, num| mem + num}) / poss_percent_sum
    end

    def predict_possessions(games_back)
      away_team_season = game.away_team_season_stat_0
      home_team_season = game.home_team_season_stat_0
      away_team_prev = game.away_team_prev_stat_0(games_back)
      home_team_prev = game.home_team_prev_stat_0(games_back)

      away_poss = (away_team_season.tot_poss + away_team_prev.tot_poss) / 2
      home_poss = (home_team_season.tot_poss + home_team_prev.tot_poss) / 2
      return (away_poss + home_poss) / 2
    end

    def predict_player_poss_percent(stat)
      previous_stats = stat.previous_stats.limit(10)
      poss_percent = previous_stats.map(&:poss_percent).inject(0) { |mem, num| mem + n }
      return poss_percent/previous_stats.size
    end

    def predict_player_ortg(stat)
      previous_stats = stat.previous_ranged_stats(0.05)
      minutes = previous_stats.map(&:mp)
      games_back = 0
      time_played = 0
      minutes.each do |minute|
        games_back += 1
        time_played += minute
        break if time_played > 240.0
      end
      previous_stats = previous_stats.limit(games_back)
      stat = Stats::Stat.new(previous_stats)
      return stat.calc_ortg
    end
  end
end
