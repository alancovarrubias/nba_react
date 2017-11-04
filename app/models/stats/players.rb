module Stats
  class Player
    attr_reader :player, :team, :opp
    def initialize(player, team, opp)
      @player = player
      @team = team
      @opp = opp
    end

    def q_5
     return 1.14 * ((team.ast - player.ast) / team.fgm)
    end

    def q_12
      q_12 = ((team.ast / team.mp) * player.mp * 5.0 - player.ast)/((team.fgm / team.mp) * player.mp * 5.0 - player.fgm)
      if q_12.nan? || q_12.to_s == 'Infinity' || q_12.to_s == '-Infinity'
        return 0.0
      end
      return q_12
    end

    def q_ast
      q_ast = player.mp / (team.mp/5.0) * player.q_5 + (1.0 - player.mp/(team.mp/5.0)) * player.q_12
      if q_ast.nan?
        return 0.0
      end
      return q_ast
    end

    # Parts

    def fg_part
      fgpart = player.fgm * (1.0 - 0.5 * (player.pts - player.ftm)/(2.0 * player.fga) * player.q_ast)
      if fgpart.nan?
        return 0.0
      end
      return fgpart
    end

    def ft_part
      (1 - (1 - player.ft_percent) ** 2) * 0.4 * player.fta
    end

    def ast_part
      0.5 * ((team.pts - team.ftm) - (player.pts - player.ftm)) / (2.0 * (team.fga - player.fga)) * player.ast
    end

    def orb_part
      player.orb * team.orb_weight * team.play_percent
    end

    # Possessions
    def fgx_poss
      (player.fga - player.fgm) * (1.0 - 1.07 * team.orb_percent)
    end

    def ftx_poss
      ((1.0 - player.ft_percent) ** 2) * 0.4 * player.fta
    end

    def sc_poss
      (player.fg_part + player.ast_part + player.ft_part) * (1 - (team.orb / team.sc_poss) * team.orb_weight * team.play_percent) + player.orb_part
    end

    def tot_poss
      player.sc_poss + player.fgx_poss + player.ftx_poss + player.tov
    end

    def plays
      player.fga + player.fta * 0.4 + player.tov
    end

    # Percentage

    # Percentage of a team's possessions on which the team scores at least 1 point
    def floor_percentage
      floor_percentage = player.sc_poss / player.tot_poss
      if floor_percentage.nan?
        return 0.0
      end
      return floor_percentage
    end

    # Percentage of a team's non-foul shot possessions on which the team socres a field goal
    def field_percent
      fieldPercent = player.fgm / (player.fga - (player.orb/(player.orb + player.drb)) * (player.fga - player.fgm) * 1.07)
      if fieldPercent.nan?
        return 0.0
      end
      return fieldPercent
    end

    # Percentage of a team's "plays" on which the team scores at least 1 point
    def play_percent
      play_percent = player.sc_poss / player.plays
      if play_percent.nan?
        return 0.0
      end
      return play_percentage
    end

    def ft_percent
      ftPercent = player.ftm/player.fta
      if ftPercent.nan?
        return 0.0
      end
      return ftPercent
    end


    def poss_percent
      player.tot_poss / team.tot_poss
    end

    def sc_poss_percent
      player.sc_poss / team.sc_poss
    end

    # Points Produced

    def p_prod_fg_part
      pprodfgpart = 2 * (player.fgm + 0.5 * player.thpm) * (1 - 0.5 * ((player.pts - player.ftm) / (2 * player.fga)) * player.q_ast)
      if pprodfgpart.nan?
        pprodfgpart = 0
      end
      return pprodfgpart
    end

    def p_prod_ast_part
      2 * ((team.fgm - fgm + 0.5 * (team.thpm - player.thpm)) / (team.fgm - player.fgm)) * 0.5 * (((team.pts - team.ftm) - (player.pts - player.ftm)) / (2 * (team.fga - player.fga))) * player.ast
    end

    def p_prod_orb_part
      pprodorbpart = player.orb * team.orb_weight * team.play_percent * (team.pts / (team.fgm + (1 - (1 - (team.ftm / team.fta)) ** 2) * 0.4 * team.fta))
      if pprodorbpart.nan?
        pprodorbpart = 0.0
      end
      return pprodorbpart
    end

    def p_prod
      pprod = (player.p_prod_fg_part + player.p_prod_ast_part + player.ftm) * (1 - (team.orb / team.sc_poss) * team.orb_weight * team.play_percent) + player.p_prod_orb_part
      if pprod.nan?
        return 0.0
      end
      return pprod
    end

    def ortg
      ortg = 100 * (player.p_prod / player.tot_poss)
      if ortg.nan?
        return 0.0
      end
      return ortg
    end

    def predicted_points
      player.poss_percent * player.ortg
    end

    # Defense

    def d_fg_percent
      var = opp.fgm / opp.fga
      if var.nan?
        return 0.0
      end
      return var
    end

    def d_orb_percent
      var = opp.orb / (opp.orb + team.drb)
      if var.nan?
        return 0.0
      end
      return var
    end

    def fmwt
      dfg = player.d_fg_percent
      dor = player.d_orb_percent
      var = (dfg * (1 - dor)) / (dfg * (1 - dor) + (1 - dfg) * dor)
      if var.nan?
        return 0.0
      end
      return var
    end

    def stops_1
      fmwt = player.fmwt
      var = player.stl + player.blk * fmwt * (1 - 1.07 * player.d_orb_percent) + player.drb * (1 - fmwt)
      if var.nan?
        return 0.0
      end
      return var
    end

    def stops_2
      var = (((opp.fga - opp.fgm - team.blk) / team.mp) * player.fmwt * (1 - 1.07 * player.d_orb_percent) + ((opp.tov - team.stl) / team.mp)) * player.mp + (player.pf / team.pf) * 0.4 * opp.fta * (1 - (opp.ftm / opp.fta)) ** 2
      if var.nan?
        return 0.0
      end
      return var
    end

    def stops
      player.stops_1 + player.stops_2
    end

    def stop_percent
      var = (player.stops * opp.mp) / (team.tot_poss * player.mp)
      if var.nan?
        return 0.0
      end
      return var
    end

    def def_points_per_sc_poss
      var = opp.pts / (opp.fgm + (1 - (1 - (opp.ftm / opp.fta)) ** 2) * opp.fta * 0.4)
      if var.nan?
        return 0.0
      end
      return var
    end

    def drtg
      team.drtg + 0.2 * (100 * player.def_points_per_sc_poss * (1 - player.stop_percent) - team.drtg)
    end

    def predict_poss_percent(past_number=10)
      previous_starters = Starter.where(:alias => player.alias, :quarter => player.quarter).where("id < #{player.id}").order('id DESC').limit(past_number)
      size = previous_starters.size
      if size == 0
        return 0.0
      end
      poss_percent = 0
      previous_starters.each do |starter|
        var = starter.poss_percent
        if var.nan?
          var = 0
        end
        poss_percent += var
      end
      return poss_percent/size
    end

    def predict_ortg(range=0.05, poss_percent)
      previous_starters = Starter.where(:alias => player.alias, :quarter => player.quarter).where("id < #{player.id} AND poss_percent > #{player.poss_percent - range} AND poss_percent < #{player.poss_percent + range}").order('id DESC')
      if previous_starters.size == 0
        return 90.0
      end
      stat = Starter.new
      team = Lineup.new
      opp = Lineup.new
      previous_starters.each do |starter|
        Store.add(stat, starter)
        Store.add(team, starter.team)
        Store.add(opp, starter.opp)
        if stat.mp > player.team.mp
          break
        end
      end
      ortg = stat.ortg
      if ortg.nan?
        ortg = 90.0
      end
      return ortg
    end

    def prediction(past_number=10)
      percentage = player.predict_poss_percent(past_number)
      if percentage == nil || percentage.nan?
        percentage = 0
      end
      ortg = player.predict_ortg(0.05, percentage)
      if ortg == nil || ortg.nan?
        ortg = 0
      end
      return [ortg, percentage]
    end
  end
end
