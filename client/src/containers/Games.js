import React, { Component } from 'react'
import { connect } from 'react-redux'
import { fetchGames } from '../actions'
import GamesIndex from '../components/games/Index'

class Games extends Component {
  constructor(props) {
    super(props)
  }

  componentDidMount() {
    const { dispatch } = this.props;
    dispatch(fetchGames());
  }

  render() {
    const { games } = this.props;
    return (<GamesIndex games={games} />);
  }
}

function mapStateToProps(state) {
  const { games } = state;
  return {
    games
  };
}
export default connect(mapStateToProps)(Games)
