import React, { Component } from 'react';
import { withRouter } from 'react-router';

class TableRow extends Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    let seasonId = this.props.season.id;
    let params = {
      pathname: `/seasons/${seasonId}/games`
    };
    this.props.history.push(params);
  }

  render() {
    let season = this.props.season;
    return (
      <tr onClick={this.handleClick}>
        <td>{season.year}</td>
      </tr>
      );
  }
}

const TableRowWithRouter = withRouter(TableRow);
export default TableRowWithRouter;
