import React from 'react';

const TeamRow = ({ player }) => {
  return (
        <tr>
          <td width="16%">{player.name}</td>
          <td>{(player.sp/60.0).toFixed(2)}</td>
          <td>{player.fgm}</td>
          <td>{player.fga}</td>
          <td>{player.thpm}</td>
          <td>{player.thpa}</td>
          <td>{player.ftm}</td>
          <td>{player.fta}</td>
          <td>{player.orb}</td>
          <td>{player.drb}</td>
          <td>{player.ast}</td>
          <td>{player.stl}</td>
          <td>{player.blk}</td>
          <td>{player.tov}</td>
          <td>{player.pf}</td>
          <td>{player.pts}</td>
          <td>{player.ortg.toFixed(2)}</td>
          <td>{player.drtg.toFixed(2)}</td>
        </tr>
      );
}

export default TeamRow;

