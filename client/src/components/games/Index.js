import React from 'react';
import Layout from '../layouts/Main';
import GameTable from './index/GameTable';

const PageBody = ({ games }) => {
  return <GameTable games={games} />;
}

const PageHeader = ({ season }) => {
  return <h1>{ season.year } Games</h1>;
}

const Index = ({ season, games }) => {
  let head = <PageHeader season={season} />;
  let body = <PageBody games={games} />;
  return <Layout head={head} body={body} />;
}

export default Index;

