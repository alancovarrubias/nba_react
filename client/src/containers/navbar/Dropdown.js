import React, { Component } from 'react';
import { Link } from 'react-router-dom';

class DropdownContainer extends Component {
  constructor(props) {
    super(props);
    this.state = {
      seasons: []
    }
  }
  componentDidMount() {
    const url = "http://localhost:3000/api/seasons";
    window.fetch(url)
      .then(response => response.json())
      .then(json => {
        this.setState({
          seasons: json.seasons
        });
      })
      .catch(error => console.log(error));
  }

  gameLinks() {
    return seasons.map(season => {
      const params = {
        pathname: "/games",
        search: `?seasonId=${season.id}`,
        state: {
          seasonId: season.id
        }
      };
      return (
            <li key={season.id}><Link to={params}>{season.year}</Link></li>
          );
    });
  }

  render() {
    const gameLinks = this.gameLinks();
  }
}

export default NavbarContainer;
