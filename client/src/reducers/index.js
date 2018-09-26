import { combineReducers } from 'redux'
import {
  REQUEST_SEASONS,
  RECEIVE_SEASONS
} from '../actions'

function seasons(state = [], action) {
  switch (action.type) {
    case RECEIVE_SEASONS:
      return action.seasons;
    default:
      return state;
  }
}

const rootReducer = combineReducers({
  seasons
})

export default rootReducer
