import React from 'react';
import { Row, Col } from 'react-bootstrap';
import TeamTable from './show/TeamTable';
import './Show.css';

const Show = ({ season, away_team, home_team }) => {
  const season_link = `/seasons/${season.id}/games`;
  const away_table = <TeamTable team={away_team} maxHeight="300px" />;
  const home_table = <TeamTable team={home_team} maxHeight="300px" />;
  return (
        <Row className="game-show">
          <Col lg={12}>
            <div>
              <a href={season_link}>{season.year} Games</a>
            </div>
            <h1>{away_team.name} @ {home_team.name}</h1>
          </Col>
          <Col className="away-table" lg={12}>
            <p>{away_team.name} Player Stats</p>
            { away_table }
          </Col>
          <Col className="home-table" lg={12}>
            <p>{home_team.name} Player Stats</p>
            { home_table }
          </Col>
        </Row>
      );
};

export default Show;
