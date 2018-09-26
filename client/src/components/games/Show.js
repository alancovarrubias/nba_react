import React from 'react';
import { Row, Col } from 'react-bootstrap';
import Table from '../show/Table';
import './Show.css';

const Show = ({ season, away_team, home_team, away_players, home_players }) => {
  const headers = [
    { width: "16%", text: "Name" },
    "MP", "FGM", "FGA", "THPM", "THPA", "FTM", "FTA", "ORB", "DRB", "AST", "STL", "BLK", "TOV", "PF", "PTS", "ORTG", "DRTG"
  ]
  const keys= = ["name", "mp", "fgm", "fga", "thpm", "thpa", "ftm", "fta", "orb", "drb", "ast", "stl", "blk", "tov", "pf", "pts", "ortg", "drtg"]
  const away_table = <Table headers={headers} keys={keys} rows={away_players} maxHeight="300px"/>
  const home_table = <Table headers={headers} keys={keys} rows={home_players} maxHeight="300px"/>
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
