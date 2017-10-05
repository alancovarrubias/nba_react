import React from 'react';
import './Table.css';

const Table = ({ caption, header, rows }) => {
  return (
        <table className="table table-hover table-bordered">
          <caption>{caption}</caption>
          <thead>
            { header }
          </thead>
          <tbody>
            { rows }
          </tbody>
        </table>  
      );
}

export default Table;

