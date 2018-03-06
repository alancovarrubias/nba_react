import React from 'react';
import Table from '../common/Table';
import GameRow from './index/GameRow';

const Header = () => (
  <tr>
    <th>Date</th>
    <th>Away Team</th>
    <th>Home Team</th>
  </tr>
);
const Index = ({ season, games }) => {
  const header = <Header />;
  const rows = games.map(game => <GameRow key={game.id} season={season} game={game} />);
  return (
    <div>
      <h1>{ season.year } Games </h1>
      <Table header={header} rows={rows} /> 
    </div>
  );
};

export default Index;

