import React from "react";
import { Link } from "react-router-dom";


import classes from "./login.module.scss";
import authClasses from "../auth.module.scss";
import Button from '../../Button/button'


const login = () => {
  return (
    <div className={authClasses.signContainer}>
      <form className={authClasses.signForm}>
        <input type="text" placeholder="Nazwa użytkownika" required />
        <input type="password" placeholder="Hasło" required />
        <Button>Zaloguj</Button>
      </form>
      <div className={classes.notRegistered}>
        <p>
          Nie należysz jeszcze do stada?
        </p>
          <Link className={classes.buttonRegister} to="/auth/register">Zarejestruj się!</Link>{" "}
      </div>
    </div>
  );
};

export default login;
