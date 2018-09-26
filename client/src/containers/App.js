import React, { Component } from 'react'
import { Provider } from 'react-redux'
import { BrowserRouter as Router, Route } from 'react-router-dom'
import configureStore from '../configureStore'
import { fetchSeasons } from '../actions'
import Seasons from './Seasons'

const store = configureStore();
store.dispatch(fetchSeasons())
  .then(() => store.getState());
  

export default class App extends Component {
  render() {
    return (
      <Provider store={store}>
        <Router>
          <Route path="/seasons" component={Seasons} />
        </Router>
      </Provider>
    )
  }
}
