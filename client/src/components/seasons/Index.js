import React from 'react';
import Layout from '../layouts/Main';
import Table from '../common/Table';
import TableRow from './TableRow';

const Index = ({ seasons }) => {
  let head = <PageHeader />;
  let body = <PageBody seasons={seasons} />;
  return (
        <Layout head={head} body={body} />
      );
}

const PageHeader = () => {
  return <h1>MLB Seasons</h1>;
}

const PageBody = ({ seasons }) => {
  let tableHeader = <TableHeader />;
  let tableRows = [];
  seasons.forEach(function(season) {
    tableRows.push(<TableRow key={season.id} season={season} />);
  });
  return <Table header={tableHeader} rows={tableRows} />;
}

const TableHeader = () => {
  return (
        <tr>
          <th>Year</th>
        </tr>
      );
}

export default Index;
