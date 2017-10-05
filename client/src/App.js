import React from 'react';
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

const App = () => (
  <BrowserRouter>
    <div>
      <nav className="navbar navbar-toggleable-md navbar-light bg-faded">
        <div className="collapse navbar-collapse" id="navbarSupportedContent">
          <ul className="navbar-nav mr-auto">
            <li className="nav-item"><Link to="/seasons">Seasons</Link></li>
            <li className="nav-item"><Link to="/games">Games</Link></li>
          </ul>
        </div>
      </nav>

      <hr/>

      <Switch>
        <Route exact path="/" component={SeasonIndex}/>
        <Route path="/seasons" component={SeasonIndex}/>
        <Route path="/games/:id" component={GameShow}/>
        <Route path="/games" component={GameIndex}/>
      </Switch>

    </div>
  </BrowserRouter> 
)

export default App;
