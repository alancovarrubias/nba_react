import React from 'react';
import './Table.css';

const Table = ({ caption, header, body, rows }) => {
  return (
      <div id="constrainer">
        <div className="scrolltable">
          <div className="header">
            <table className="table table-bordered table-condensed">
              <thead>
                  {header}
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

