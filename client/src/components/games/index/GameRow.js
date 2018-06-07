import React, { Component } from 'react';
import { withRouter } from 'react-router';

class GameRow extends Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    const season_id = this.props.season.id;
    const game_id = this.props.game.id;
    this.props.history.push(`/seasons/${season_id}/games/${game_id}`);
  }

  render() {
    const game = this.props.game;
    return (
      <tr onClick={this.handleClick}>
        <td width="16%">{game.date}</td>
        <td>{game.away_team}</td>
        <td>{game.home_team}</td>
        <td>{game.away_pred}</td>
        <td>{game.home_pred}</td>
        <td>{game.away_score}</td>
        <td>{game.home_score}</td>
        <td>{game.spread}</td>
        <td>{game.total}</td>
      </tr>
    );
  }
}

const GameRowWithRouter = withRouter(GameRow);
export default GameRowWithRouter;
