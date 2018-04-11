import React, { Component } from 'react';
import Navbar from '../../components/navbar/Navbar';

class NavbarContainer extends Component {
  constructor(props) {
    super(props);
    this.state = {
      seasons: []
    }
  }

  componentDidMount() {
    const url = "http://159.89.138.230/api/seasons";
    window.fetch(url)
      .then(response => response.json())
      .then(json => {
        this.setState({
          seasons: json.seasons
        });
      })
      .catch(error => console.log(error));
  }

  seasonLinks() {
    const data = this.state.seasons.map(season => {
      return {
        id: season.id,
        link: `/seasons/${season.id}/games`,
        text: season.year
      };
    });
    return {
      title: "Seasons",
      data
    };
  }
  /*
    return this.seasons.map(season => {
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
    */

  render() {
    const links = this.seasonLinks();
    return <Navbar brand="NBA Database" links={links}/>;
  }
}

export default NavbarContainer;
