import React, { Component } from 'react'
import { connect } from 'react-redux'
import { fetchSeasons } from '../actions'
import SeasonIndex from '../components/seasons/Index'

class Seasons extends Component {
  constructor(props) {
    super(props)
  }

  componentDidMount() {
    const { dispatch } = this.props;
    dispatch(fetchSeasons());
  }

  render() {
    const { seasons } = this.props;
    return (<SeasonIndex seasons={seasons} />)
  }
}

function mapStateToProps(state) {
  const { seasons } = state;
  return {
    seasons
  }
}
export default connect(mapStateToProps)(Seasons)
