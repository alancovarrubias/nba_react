import React  from 'react';
import {
  BrowserRouter,
  Route,
  Switch
} from 'react-router-dom';
import './App.css';
import Navbar from './containers/navbar/Navbar';
import SeasonIndex from './containers/seasons/Index.js';
import GameIndex from './containers/games/Index.js';
import GameShow from './containers/games/Show.js';

const App = () => (
  <BrowserRouter>
    <div className="container-fluid">
      <Navbar />
      <Switch>
        <Route exact path="/" component={SeasonIndex}/>
        <Route exact path="/seasons" component={SeasonIndex}/>
        <Route exact path="/seasons/:season_id/games" component={GameIndex}/>
        <Route exact path="/seasons/:season_id/games/:id" component={GameShow}/>
      </Switch>
    </div>
  </BrowserRouter> 
);

export default App;
