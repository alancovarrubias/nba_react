const calculateBets = (games, range) => {
  let spread_wins = 0;
  let spread_losses = 0;
  let total_wins = 0;
  let total_losses = 0;
  let bets = 0;
  games.forEach(game => {
    if (game.away_pred !== "N/A" && game.home_pred !== "N/A") {
      bets += 1;
      const game_total = game.total;
      const pred_total = game.home_pred + game.away_pred;
      const total_diff = game_total - pred_total;
      if (Math.abs(total_diff) > range) {
        const score_total = game.home_score + game.away_score;
        const win_bet = total_diff > 0 ? score_total > game_total : score_total < game_total;
        win_bet ? total_wins += 1 : total_losses += 1;
      }

      const game_spread = game.spread;
      const pred_spread = game.away_pred - game.home_pred;
      const spread_diff = game_spread - pred_spread;
      if (Math.abs(spread_diff) > range) {
        const score_spread = game.away_score - game.home_score;
        const win_bet = spread_diff > 0 ? score_spread > game_spread : score_spread < game_spread;
        win_bet ? spread_wins += 1 : spread_losses += 1;
      }
    }
  });

  return {
    spread: {
      wins: spread_wins,
      losses: spread_losses
    },
    total: {
      wins: total_wins,
      losses: total_losses
    },
    total_bets: bets
  };
}

export default calculateBets;
