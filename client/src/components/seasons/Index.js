import React from 'react';
import { Row, Col } from 'react-bootstrap';
import Table from '../common/Table';
import TableRow from './TableRow';

const Index = ({ seasons }) => {
  const tableHeaders = ["Year"];
  const tableRows = seasons.map(season => <TableRow key={season.id} season={season} />);
  return (
      <Row>
        <Col lg={12}>
          <h1>NBA Seasons</h1>
        </Col>
        <Col lg={12}>
          <Table headers={tableHeaders} rows={tableRows} />
        </Col>
      </Row>
    );
}


export default Index;
