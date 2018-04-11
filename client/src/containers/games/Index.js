import React, { Component } from 'react';
import GamesIndex from '../../components/games/Index';

class Index extends Component {
  constructor(props) {
    super(props);
    this.state = {
      season: {},
      games: []
    }
  }

  componentDidMount() {
    const season_id = this.props.match.params.season_id;
    const link = `/api/seasons/${season_id}/games`;
    window.fetch(link)
      .then(response => response.json())
      .then(json => {
        this.setState({
          season: json.season,
          games: json.games
        });
      })
      .catch(error => console.log(error));
  }

  render() {
    const season = this.state.season;
    const games = this.state.games;
    return <GamesIndex season={season} games={games} />;
  }
}

export default Index;
