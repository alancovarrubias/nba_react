import React from 'react';
import Dropdown from './Dropdown';

const Navbar = ({ brand, links }) => {
  return (
        <nav className="navbar navbar-expand-lg navbar-light bg-light">
          <a className="navbar-brand" href="/">{ brand }</a>
          <Dropdown title={links.title} links={links.data} />
        </nav>
      );
};

export default Navbar;
