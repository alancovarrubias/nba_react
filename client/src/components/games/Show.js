import React from 'react';
import { Row, Col } from 'react-bootstrap';
import TeamTable from './show/TeamTable';
import './Show.css';

const Show = ({ game }) => {
  const teamTables = {};
  for (let team in game) {
    teamTables[team] = <TeamTable team={game[team]} />;
  }
  return (
        <Row>
          <Col lg={12}>
            <h1>{game.away_team.name} @ {game.home_team.name}</h1>
          </Col>
          <Col lg={12}>
            <p>{game.away_team.name} Player Stats</p>
            { teamTables.away_team }
          </Col>
          <Col lg={12}>
            <p>{game.home_team.name} Player Stats</p>
            { teamTables.home_team }
          </Col>
        </Row>
      );
};

export default Show;
