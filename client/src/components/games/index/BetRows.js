import React from 'react';

const BetRows = ({ bets }) => {
  const rowHeaders = [{ text: "Spread", value: "spread" }, { text: "Total", value: "total" }];;
  const rows = rowHeaders.map((data, index) => {
    const wins = bets[data.value].wins;
    const losses = bets[data.value].losses;
    const total = wins + losses;
    return (
      <tr key={index}>
        <td>{data.text}</td>
        <td>{wins}</td>
        <td>{losses}</td>
        <td>{total === 0 ? 0.0 : ((wins/total).toFixed(4) * 100).toFixed(2)}</td>
        <td>{bets.total_bets - wins - losses}</td>
      </tr>
    );
  });
  return rows;
};

export default BetRows;
