import React from 'react';
import Table from '../../common/Table';
import GameHeader from './GameHeader';
import GameRow from './GameRow';

const GameTable = ({ games }) => {
  let header = <GameHeader />;
  let rows = games.map(function(game, index) {
    return <GameRow key={game.id} game={game} />;
  });
  return <Table header={header} rows={rows} />;
}

export default GameTable;

