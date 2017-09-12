import React from 'react';

const TableRow = ({ game }) => { 
  return (
      <tr>
        <td>{game.id}</td>
        <td>{game.away_team_id}</td>
        <td>{game.home_team_id}</td>
      </tr>
    );
}

const Index = ({ games }) => {
  let tableRows = games.map((game) => {
    return <TableRow key={game.id} game={game} />
  });
  return (
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Away Team</th>
              <th>Home Team</th>
            </tr>
          </thead>
          <tbody>
            { tableRows }
          </tbody>
        </table>
      );
}

export default Index;
