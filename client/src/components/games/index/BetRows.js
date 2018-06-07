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
        <td>{total === 0 ? 0.0 : (wins/total).toFixed(3)}</td>
        <td>{total === 0 ? 0.0 : (losses/total).toFixed(3)}</td>
      </tr>
    );
  });
  return rows;
};

export default BetRows;
