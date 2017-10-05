import React from 'react';
import { Grid, Row, Col } from 'react-bootstrap';

const Main = ({ head, body }) => {
  return (
      <Grid fluid>
        <Row>
          <Col xs={12}>
            { head }
          </Col>
        </Row>
        <Row>
          <Col xs={12}>
            { body }
          </Col>
        </Row>
      </Grid>
    );
}

export default Main;
