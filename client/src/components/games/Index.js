import React from "react";
import { Row, Col } from "react-bootstrap";
import Table from "../common/Table";
import GameRow from "./index/GameRow";
import BetRows from "./index/BetRows";
import "./Index.css";

const Index = ({ season, games, range, onChange, onClick, bets }) => {
  const headers = [
    { text:"Date", width:  "16%" },
    "Away Team", "Home Team", "Away Predicted Score", "Home Predicted Score", "Away Score", "Home Score", "Spread", "Total"
  ];
  const betHeaders = ["", "Wins", "Losses", "Win Percentage",  "Skipped Bets"];
  const betRows = <BetRows bets={bets} />;
  const rows = games.map(game => <GameRow key={game.id} season={season} game={game} />);
  return (
    <div className="game-index">
      <Row>
        <Col lg={12}>
          <h1>{season.year} NBA Games </h1>
        </Col>
      </Row>
      <Row>
        <Col lgOffset={4} lg={4} className="mb-3">
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
          <Table headers={betHeaders} rows={betRows} />
        </Col>
      </Row>
      <Row>
        <Col lg={12}>
          <Table headers={headers} rows={rows} /> 
        </Col>
      </Row>
    </div>
  );
};

export default Index;

