import React from 'react';
import { Row, Col } from 'react-bootstrap';
import Table from '../common/Table';
import GameRow from './index/GameRow';
import './Index.css';

const Header = () => (
  <tr>
    <th>Date</th>
    <th>Away Team</th>
    <th>Home Team</th>
    <th>Away Predicted Score</th>
    <th>Home Predicted Score</th>
    <th>Away Score</th>
    <th>Home Score</th>
    <th>Spread</th>
    <th>Total</th>
  </tr>
);
const Index = ({ season, games, range, onChange }) => {
  const header = <Header />;
  console.log(games);
  const rows = games.map(game => <GameRow key={game.id} season={season} game={game} />);
  return (
    <div className="game-index">
      <Row>
        <Col lg={12}>
          <h1>{ season.year } NBA Games </h1>
        </Col>
      </Row>
      <Row>
        <Col lg={4}>
        </Col>
        <Col lg={4}>
          <label>
            Range:
            <div className="input-group mb-3">
              <input type="number" className="form-control" value={range} step="0.1" onChange={onChange} />
              <div className="input-group-append">
                <button className="btn btn-outline-secondary" type="button">Calculate</button>
              </div>
            </div>
          </label>
        </Col>
      </Row>
      <Row>
        <Col lg={12}>
          <Table header={header} rows={rows} /> 
        </Col>
      </Row>
    </div>
  );
};

export default Index;

