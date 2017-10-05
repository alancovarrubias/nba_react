import React, { Component } from 'react';
import { withRouter } from 'react-router';

class GameRow extends Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    let gameId = this.props.game.id;
    this.props.history.push(`/games/${gameId}`);
  }

  render() {
    let game = this.props.game;
    return (
      <tr onClick={this.handleClick}>
        <td>{game.date}</td>
        <td>{game.away_team}</td>
        <td>{game.home_team}</td>
      </tr>
    );
  }
}

const GameRowWithRouter = withRouter(GameRow);
export default GameRowWithRouter;
