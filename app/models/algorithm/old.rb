module Algorithm
  class Old
    attr_reader :game
    def initialize(game)
      @game = game
    end
    def predict_score(games_back)
      return if game.prev_away_games.size < 13 && game.prev_home_games.size < 13
      puts game.id
      #possessions = predict_possessions(games_back) / 100
#      away_player_stats = game.game_away_player_stats
      home_player_stats = game.game_home_player_stats
      # home_player_stats.prev_stats.limit(10)
#      away_team_ortg = predict_team_ortg(away_player_stats)
      home_team_ortg = predict_team_ortg(home_player_stats)
      # away_score = away_team_ortg * possessions
      # home_score = home_team_ortg * possessions
      # return away_score + home_score
    end

    def predict_team_ortg(stats)
      # BUG: The ORTG comes outs as nil for some stats
      poss_percent_sum = 0
      predictions = stats.map do |stat|
        poss_percent = self.predict_player_poss_percent(stat)
        poss_percent_sum += poss_percent
        ortg = self.predict_player_ortg(stat, poss_percent)
        ortg * poss_percent
      end
      return (predictions.inject(0) {|mem, num| mem + num}) / poss_percent_sum
    end

    def predict_possessions(games_back)
      away_team_season = game.season_away_team_stat
      home_team_season = game.season_home_team_stat
      away_team_season_poss = away_team_season.tot_poss/away_team_season.games_back
      home_team_season_poss = home_team_season.tot_poss/home_team_season.games_back
      away_team_prev = game.prev_away_team_stat(games_back)
      home_team_prev = game.prev_home_team_stat(games_back)
      away_team_prev_poss = away_team_prev.tot_poss/games_back
      home_team_prev_poss = home_team_prev.tot_poss/games_back

      away_poss = (away_team_season_poss + away_team_prev_poss) / 2
      home_poss = (home_team_season_poss + home_team_prev_poss) / 2
      return (away_poss + home_poss) / 2
    end

    def predict_player_poss_percent(stat)
      prev_stats = stat.prev_stats.limit(10)
      poss_percent = prev_stats.map(&:poss_percent).inject(0) { |mem, num| mem + num }
      return poss_percent/prev_stats.size
    end

    def predict_player_ortg(stat, predicted_poss_percent)
      prev_stats = stat.prev_ranged_stats(predicted_poss_percent, 0.05).includes(:model, :game, :season)
      minutes = prev_stats.map(&:mp)
      games_back = 0
      time_played = 0
      minutes.each do |minute|
        games_back += 1
        time_played += minute
        break if time_played > 240.0
      end
      prev_stats = prev_stats.limit(games_back)
      stat = Stats::Stat.new(prev_stats)
      ortg = stat.calc_ortg
      return ortg
    end
  end
end
