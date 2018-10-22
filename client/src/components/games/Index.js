import React from "react";
import { Row, Col } from "react-bootstrap";
import "./Index.css";
import { Link } from "@curi/react-dom"

// Components
import Table from "../common/Table";

// Constants
import { PERIODS } from "../../const/periods";


const Index = ({ season, games, period, range, bets, rowClick, onChange, onClick, selectPeriod, rangeChange }) => {
  const gameHeaders = [
    { text: "Date", width: "16%" },
    "Away Team", "Home Team", "Away Predicted Score", "Home Predicted Score", "Away Score", "Home Score", "Spread", "Total"
  ];
  const gameKeys = ["date", "away_team", "home_team", "away_pred", "home_pred", "away_score", "home_score", "spread", "total"];
  // const betHeaders = ["", "Wins", "Losses", "Win Percentage",  "Skipped Bets"];
  const gameRows = games[period] || [];
  return (
    <div className="game-index">
      <Row>
        <Col lg={12}>
          <div>
            <Link to="Seasons">Seasons</Link>
          </div>
          <h1>{season.year} NBA Games </h1>
        </Col>
      </Row>
      <Row>
        <Col lgOffset={5} lg={2} className="mb-3">
          <label>
            Range:
            <div className="input-group input-group-sm">
              <input type="number" className="form-control" value={range} onChange={rangeChange} step="0.1" />
              <div className="input-group-btn">
                <button className="btn btn-outline-secondary" type="button" onClick={onClick}>Calculate</button>
              </div>
            </div>
          </label>
        </Col>
      </Row>
      <Row>
        <Col lgOffset={4} lg={4} className="mb-3">
        </Col>
      </Row>
      <Row>
        <Col lg={12}>
          <Table headers={gameHeaders} rows={gameRows} keys={gameKeys} rowClick={rowClick} /> 
        </Col>
      </Row>
    </div>
  );
};

export default Index;

