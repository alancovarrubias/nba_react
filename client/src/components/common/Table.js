import React from 'react';
import './Table.css';

const Table = ({ caption, headers, body, rows }) => {
  const headerCols = headers.map((data, index) => {
    return data.text ? <th key={index} width={data.width}>{data.text}</th> : <th key={index}>{data}</th>;
  });
  return (
      <div id="constrainer">
        <div className="scrolltable">
          <div className="header">
            <table className="table table-bordered table-condensed">
              <thead>
                <tr>{headerCols}</tr>
              </thead>
            </table>
          </div>
          <div className="body">
            <table className="table table-bordered table-condensed table-hover">
              <tbody>
                {rows}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    );
}

export default Table;

