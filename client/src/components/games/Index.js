import React from 'react';
import { Row, Col } from 'react-bootstrap';
import Table from '../common/Table';
import GameRow from './index/GameRow';

const Header = () => (
  <tr>
    <th>Date</th>
    <th>Away Team</th>
    <th>Home Team</th>
  </tr>
);
const Index = ({ season, games }) => {
  const header = <Header />;
  const rows = games.map(game => <GameRow key={game.id} season={season} game={game} />);
  return (
    <Row>
      <Col lg={12}>
        <h1>{ season.year } Games </h1>
      </Col>
      <Col lg={12}>
        <Table header={header} rows={rows} /> 
      </Col>
    </Row>
  );
};

export default Index;

