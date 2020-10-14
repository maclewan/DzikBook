import React from "react";
import { Link } from "react-router-dom";

import classes from "./register.module.scss";
import authClasses from "../auth.module.scss";

import Button from '../../Button/button'

const register = () => {
  return (
    <div className={authClasses.signContainer}>
      <form className={authClasses.signForm}>
        <input type="text" placeholder="Nazwa użytkownika" required />
        <input type="text" placeholder="Imię" required />
        <input type="text" placeholder="Nazwisko" required />
        <input type="email" placeholder="Adres e-mail" required />
        <input type="password" placeholder="Hasło" required />
        <input type="password" placeholder="Powtórz hasło" required />
        
        <Button>Zarejestruj</Button>
      </form>
      <div className={classes.registered} >
        <p>
          Już należysz do stada? 
        </p>
          <Link className={classes.buttonBackToLogin}to="/auth/login">Zaloguj się!</Link>
      </div>
    </div>
  );
};

export default register;
