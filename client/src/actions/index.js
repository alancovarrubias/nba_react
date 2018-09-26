import fetch from 'cross-fetch'

export const RECEIVE_SEASONS = 'RECEIVE_SEASONS'
export function receiveSeasons(seasons) {
  return {
    type: RECEIVE_SEASONS,
    seasons
  };
}


export function fetchSeasons() {
  return function(dispatch) {
    return fetch('/api/seasons.json').then(
      async response => await response.json(),
      error => console.log(error)
    ).then(
      json => dispatch(receiveSeasons(json.seasons))
    );
  }
}

export const RECEIVE_GAMES = 'RECEIVE_GAMES'
export function receiveGames(games) {
  return {
    type: RECEIVE_GAMES,
    games
  };
}

export function fetchGames() {
  return function(dispatch) {
    return fetch('/api/games.json').then(
      async response => await response.json(),
      error => console.log(error)
    ).then(
      json => dispatch(receiveGames(json.games))
    );
  }
}
