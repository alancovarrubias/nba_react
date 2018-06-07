import React from 'react';
import Table from '../../common/Table';
import TeamRow from './TeamRow';

const TeamTable = ({ team, headers }) => {
  let rows = team.players.map((player) => {
    return <TeamRow key={player.id} player={player} />;
  });
  return <Table headers={headers} rows={rows} />;
}

export default TeamTable;

