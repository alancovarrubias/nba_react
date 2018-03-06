import React, { Component } from 'react';
import {
  BrowserRouter,
  Route,
  Link,
  Switch
} from 'react-router-dom';
import SeasonIndex from './containers/seasons/Index';
import GameIndex from './containers/games/Index';
import GameShow from './containers/games/Show';
import './App.css';

const GameDropdown = ({ seasons }) => {
  let gameLinks = seasons.map((season) => {
    let params = {
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
  return (
    <ul className="dropdown-menu">
      {gameLinks}
    </ul>
  );
}

class GameDropdownContainer extends Component {
  constructor(props) {
    super(props);
    this.state = {
      seasons: []
    }
  }

  componentDidMount() {
    let url = "http://localhost:3000/api/seasons";
    window.fetch(url)
      .then(response => response.json())
      .then(json => {
        this.setState({
          seasons: json.seasons
        });
      })
      .catch(error => console.log(error));
  }

  render() {
    let seasons = this.state.seasons;
    return seasons ? <GameDropdown seasons={seasons} /> : null;
  }
}

const App = () => (
  <BrowserRouter>
    <div>
      <nav className="navbar navbar-default">
        <div className="container-fluid">
          <div className="navbar-header">
            <a className="navbar-brand">Database</a>
          </div>

          <div className="collapse navbar-collapse">
            <ul className="nav navbar-nav">
              <li><Link to="/seasons">Seasons</Link></li>
              <li className="dropdown">
                <a className="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Games <span className="caret"></span></a>
                <GameDropdownContainer />
              </li>
            </ul>
          </div>
        </div>
      </nav>

      <Switch>
        <Route exact path="/" component={SeasonIndex}/>
        <Route exact path="/seasons" component={SeasonIndex}/>
        <Route exact path="/seasons/:season_id/games" component={GameIndex}/>
        <Route exact path="/seasons/:season_id/games/:id" component={GameShow}/>
      </Switch>

    </div>
  </BrowserRouter> 
)

export default App;
