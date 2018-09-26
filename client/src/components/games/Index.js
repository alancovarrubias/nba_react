import React from "react";
import { Row, Col } from "react-bootstrap";
import "./Index.css";

// Components
import Table from "../common/Table";
import GameRow from "./index/GameRow";
import BetRows from "./index/BetRows";

// Constants
import { PERIODS } from "../../const/periods";


const Index = ({ season, games, range, bets, onChange, onClick, onPeriodChange }) => {
  const gameHeaders = [
    { text:"Date", width:  "16%" },
    "Away Team", "Home Team", "Away Predicted Score", "Home Predicted Score", "Away Score", "Home Score", "Spread", "Total"
  ];
  const gameKeys = ["date", "away_team", "home_team", "away_pred", "home_pred", "away_score", "home_score", "spread", "total"];
  const betHeaders = ["", "Wins", "Losses", "Win Percentage",  "Skipped Bets"];
  const betRows = <BetRows bets={bets} />;
  const options = Object.keys(PERIODS).map(period => <option key={period} value={period}>{PERIODS[period]}</option>);
  return (
    <div className="game-index">
      <Row>
        <Col lg={12}>
          <h1>{season.year} NBA Games </h1>
        </Col>
      </Row>
      <Row>
        <Col lgOffset={4} lg={2} className="mb-3">
          <label>
            Period:
            <select className="form-control" onChange={onPeriodChange}>
              {options}
            </select>
          </label>
        </Col>
        <Col lg={2} className="mb-3">
          <label>
            Range:
            <div className="input-group input-group-sm">
              <input type="number" className="form-control" value={range} onChange={onChange} step="0.1" min="0" />
              <div className="input-group-btn">
                <button className="btn btn-outline-secondary" type="button" onClick={onClick}>Calculate</button>
              </div>
            </div>
          </label>
        </Col>
      </Row>
      <Row>
        <Col lgOffset={4} lg={4} className="mb-3">
          <Table headers={betHeaders} rows={bettows} />
        </Col>
      </Row>
      <Row>
        <Col lg={12}>
          <Table headers={gameHeaders} rows={games} keys={gameKeys} /> 
        </Col>
      </Row>
    </div>
  );
};

export default Index;

