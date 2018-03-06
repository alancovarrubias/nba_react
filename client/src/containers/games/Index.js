import React, { Component } from 'react';
import GamesIndex from '../../components/games/Index';

class Index extends Component {
  constructor(props) {
    super(props);
    this.state = {
      season: undefined,
      games: []
    }
  }

  componentDidMount() {
    let season_id = this.props.match.params.season_id;
    let link = `http://localhost:3000/api/seasons/${season_id}/games`
    window.fetch(link)
      .then(response => response.json())
      .then(json => {
        this.setState({
          season: json.season,
          games: json.games
        });
      })
      .catch(error => console.log(error))
  }

  render() {
    let season = this.state.season;
    let games = this.state.games;
    return season ? <GamesIndex season={season} games={games} /> : null;
  }
}

export default Index;
