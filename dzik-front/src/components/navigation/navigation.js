import React from "react";
import { NavLink } from "react-router-dom";

import classnames from "./navigation.module.scss";
import logo from "../../assets/images/only_dzik_logo.svg";

const navigation = () => {
  return (
    <div className={classnames.navbar}>
      <img src={logo} alt="logo" />
      <NavLink
        to="/profile/personal-data"
        className={classnames.navbarLink}
        activeClassName={classnames.activeLink}
      >
        <p>Profil</p>
      </NavLink>
      <NavLink
        to="/profile/personal-data2"
        className={classnames.navbarLink}
        activeClassName={classnames.activeLink}
      >
        <p>Tablica</p>
      </NavLink>
      <NavLink
        to="/auth/login"
        className={classnames.navbarLink}
        activeClassName={classnames.activeLink}
      >
        <p>Wyloguj</p>
      </NavLink>
    </div>
  );
};

export default navigation;
