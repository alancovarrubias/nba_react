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
  </tr>
);
const Index = ({ season, games }) => {
  const header = <Header />;
  console.log(games);
  const rows = games.map(game => <GameRow key={game.id} season={season} game={game} />);
  return (
    <Row className="game-index">
      <Col lg={12}>
        <h1>{ season.year } NBA Games </h1>
      </Col>
      <Col lg={12}>
        <Table header={header} rows={rows} /> 
      </Col>
    </Row>
  );
};

export default Index;

