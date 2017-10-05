import React from 'react';
import Layout from '../layouts/Main';
import TeamTable from './show/TeamTable';

const PageBody = ({ game }) => {
  let teamTables = {};
  for (let team in game) {
    teamTables[team] = <TeamTable team={game[team]} />;
  }
  return (
      <div>
        { teamTables.away_team }
        { teamTables.home_team }
      </div>
    );
}

const PageHeader = ({ game }) => {
  return <h1>{game.away_team.name} @ {game.home_team.name}</h1>;
}

const Show = ({ game }) => {
  let head = <PageHeader game={game} />;
  let body = <PageBody game={game} />;
  return <Layout head={head} body={body} />;
};

export default Show;
