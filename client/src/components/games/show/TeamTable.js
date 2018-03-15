import React from 'react';
import Table from '../../common/Table';
import TeamRow from './TeamRow';
import TeamHeader from './TeamHeader';

const TeamTable = ({ team }) => {
  let header = <TeamHeader />;
  let rows = team.players.map((player) => {
    return <TeamRow key={player.id} player={player} />;
  });
  return <Table header={header} rows={rows} />;
}

export default TeamTable;

