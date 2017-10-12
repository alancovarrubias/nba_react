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
    let seasonId = this.props.location.state.seasonId;
    let link = `http://104.131.184.150:3000/api/games?seasonId=${seasonId}`
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
