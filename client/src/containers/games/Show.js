import React, { Component } from 'react';
import GamesShow from '../../components/games/Show';

class Show extends Component {
  constructor(props) {
    super(props);
    this.state = {
      season: {},
      home_team: { players: [] },
      away_team: { players: [] }
    }
  }

  componentDidMount() {
    const game_id = this.props.match.params.id;
    const season_id = this.props.match.params.season_id;
    const url = `http://localhost:3001/api/seasons/${season_id}/games/${game_id}`;
    window.fetch(url)
      .then(response => response.json())
      .then(json => {
        this.setState({
          away_team: json.away_team,
          home_team: json.home_team,
          season: json.season
        });
      })
      .catch(error => console.log(error))
  }

  render() {
    const away_team = this.state.away_team;
    const home_team = this.state.home_team;
    const season = this.state.season;
    return <GamesShow season={season} away_team={away_team} home_team={home_team} />;
  }
}

export default Show;
