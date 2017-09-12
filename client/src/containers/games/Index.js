import React, { Component } from 'react';
import GamesIndex from '../../components/games/Index';

class Index extends Component {
  constructor(props) {
    super(props);
    this.state = {
      games: []
    }
  }

  componentDidMount() {
    window.fetch('api/games')
      .then(response => response.json())
      .then(json => {
        this.setState({
          games: json
        });
      })
      .catch(error => console.log(error))
  }

  render() {
    let games = this.state.games;
    return (<GamesIndex games={games} />);
  }
}

export default Index;
