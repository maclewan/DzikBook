import React from "react";
import { Link } from "react-router-dom";
import classes from "./login.module.scss";
const login = () => {
  return (
    <div className={classes.loginContainer}>
      <form className={classes.loginForm}>
        <input type="text" placeholder="Nazwa użytkownika" required />
        <input type="password" placeholder="Hasło" required />
        <button className={classes.loginButton}>Zaloguj</button>
      </form>
      <p>
        Nie należysz jeszcze do stada?
        <br />
        <Link to="/auth/register">Zarejestruj się!</Link>{" "}
      </p>
    </div>
  );
};

export default login;
