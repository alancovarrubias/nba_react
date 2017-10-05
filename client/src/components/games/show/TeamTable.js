import React from 'react';
import Table from '../../common/Table';
import TeamRow from './TeamRow';
import TeamHeader from './TeamHeader';

const TeamTable = ({ team }) => {
  let caption = `${team.name} Player Stats`;
  let header = <TeamHeader />;
  let rows = team.players.map((player) => {
    return <TeamRow key={player.id} player={player} />;
  });
  return <Table caption={caption} header={header} rows={rows} />;
}

export default TeamTable;

