import React  from 'react';

const Dropdown = ({ title, links }) => {
  return (
        <div className="nav-item dropdown">
          <a className="nav-link dropdown-toggle" href="" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            { title }
          </a>
          <div className="dropdown-menu" aria-labelledby="navbarDropdown">
            { links.map(data => <a key={data.id} className="dropdown-item" href={data.link}>{data.text}</a>) }
          </div>
        </div>
      );
};

export default Dropdown;
