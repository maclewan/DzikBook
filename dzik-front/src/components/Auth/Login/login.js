import React from "react";
import { Link } from "react-router-dom";

import classes from "./login.module.scss";
import authClasses from "../auth.module.scss";
import Button from "../../Button/button";
import facebookLogo from "../../../assets/images/auth_icons/facebook_logo.svg";
import googleLogo from "../../../assets/images/auth_icons/google_logo.svg";
import instagramLogo from "../../../assets/images/auth_icons/instagram_logo.svg";

const login = () => {
  return (
    <div className={authClasses.signContainer}>
      <form className={authClasses.signForm}>
        <input type="text" placeholder="Nazwa użytkownika" required />
        <input type="password" placeholder="Hasło" required />
        <Button>Zaloguj</Button>
      </form>
      <div className={classes.imgContainer}>
        <div className={classes.logoImage}>
          <img src={facebookLogo} alt="facebook" />
        </div>
        <div className={classes.logoImage}>
          <img src={googleLogo} alt="google" />
        </div>
        <div className={classes.logoImage}>
          <img src={instagramLogo} alt="instagram" />
        </div>
      </div>

      <div className={classes.notRegistered}>
        <p>Nie należysz jeszcze do stada?</p>
        <Link className={classes.buttonRegister} to="/auth/register">
          Zarejestruj się!
        </Link>{" "}
      </div>
    </div>
  );
};

export default login;
