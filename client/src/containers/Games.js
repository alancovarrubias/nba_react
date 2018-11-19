import React, { Component } from 'react'
import { connect } from 'react-redux'
import { fetchGames, selectPeriod } from '../actions'
import GamesIndex from '../components/games/Index'

class Games extends Component {
  constructor(props) {
    super(props);
    this.rowClick = this.rowClick.bind(this);
    this.rangeChange = this.rangeChange.bind(this);
  }

  componentDidMount() {
    this.seasonId = this.props.response.params.seasonId;
    this.props.dispatch(fetchGames(this.seasonId));
    this.setState({ range: 0 });
  }
  
  componentWillReceiveProps(props) {
    const seasonId = props.response.params.seasonId;
    if (this.seasonId !== seasonId) {
      this.componentDidMount();
    }
  }

  rowClick(game) {
    const { router } = this.props;
    router.navigate({ name: "Game", params: { seasonId: this.seasonId, gameId: game.id } });
  }
  
  rangeChange(event) {
    const range = event.target.value;
    this.setState({ range });
  }

  render() {
    return (<GamesIndex {...this.props} rowClick={this.rowClick} rangeChange={this.rangeChange} />);
  }
}

function mapStateToProps(state) {
  const { season, games, period, range } = state;
  return {
    season,
    games,
    period,
    range
  };
}

function mapDispatchToProps(dispatch) {
  return {
    dispatch,
    selectPeriod: (event) => dispatch(selectPeriod(event.target.value)),
    changeRange: (event) => console.log(event.target.value)
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(Games)
