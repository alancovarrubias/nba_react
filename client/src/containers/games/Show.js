import React, { Component } from 'react';
import GamesShow from '../../components/games/Show';

class Show extends Component {
  constructor(props) {
    super(props);
    this.state = {
      game: undefined
    }
  }

  componentDidMount() {
    let gameId = this.props.match.params.id;
    let seasonId = this.props.match.params.seasonId;
    let url = `http://localhost:5000/api/seasons/${seasonId}/games/${gameId}`;
    window.fetch(url)
      .then(response => response.json())
      .then(json => {
        this.setState({
          game: json
        });
      })
      .catch(error => console.log(error))
  }

  render() {
    let game = this.state.game;
    return game ? <GamesShow game={game} /> : null;
  }
}

export default Show;
