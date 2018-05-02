import React, { Component } from 'react';
import GamesIndex from '../../components/games/Index';

class Index extends Component {
  constructor(props) {
    super(props);
    this.state = {
      season: {},
      games: [],
      range: 0
    };
    this.onChange = this.onChange.bind(this);
  }

  onChange(event) {
    this.setState({ range: event.target.value });
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
    const range = this.state.range;
    return <GamesIndex season={season} games={games} range={range} onChange={this.onChange}/>;
  }
}

export default Index;
