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
    let game_id = this.props.match.params.id;
    let season_id = this.props.match.params.season_id;
    let url = `http://localhost:3000/api/seasons/${season_id}/games/${game_id}`;
    window.fetch(url)
      .then(response => response.json())
      .then(json => {
        console.log(json);
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
