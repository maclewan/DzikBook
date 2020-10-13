import React from "react";
import { Link } from "react-router-dom";

import classes from "./register.module.scss";

const register = () => {
  return (
    <div className={classes.registerContainer}>
      <form className={classes.registerForm}>
        <input type="text" placeholder="Nazwa użytkownika" required />
        <input type="text" placeholder="Imię" required />
        <input type="text" placeholder="Nazwisko" required />
        <input type="email" placeholder="Adres e-mail" required />
        <input type="password" placeholder="Hasło" required />
        
        <button className={classes.registerButton}>Zarejestruj</button>
      </form>
      <p>
        Już należysz do stada? <br />
        <Link to="/auth/login">Zaloguj się!</Link>
      </p>
    </div>
  );
};

export default register;
