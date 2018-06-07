import React, { Component } from "react";
import GamesIndex from "../../components/games/Index";
import calculateBets from "./index/calculateBets";

class Index extends Component {
  constructor(props) {
    super(props);
    this.state = {
      bets: {
        spread: {
          wins: 0,
          losses: 0
        },
        total: {
          wins: 0,
          losses: 0
        },
        total_bets: 0
      },
      season: {},
      games: [],
      range: 0
    };
    this.onChange = this.onChange.bind(this);
    this.onClick = this.onClick.bind(this);
  }

  onChange(event) {
    this.setState({ range: event.target.value });
  }

  onClick() {
    const range = this.state.range;
    const games = this.state.games;
    const betStats = calculateBets(games, range);
    this.setState({ bets: betStats });
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
    const bets = this.state.bets;
    return <GamesIndex season={season} games={games} range={range} onChange={this.onChange} onClick={this.onClick} bets={bets} />;
  }
}

export default Index;
