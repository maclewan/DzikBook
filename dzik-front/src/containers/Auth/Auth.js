import React from "react";
import { Route, Switch, Redirect } from "react-router";


import Login from "../../components/Auth/Login/login";
import Register from "../../components/Auth/Register/register";
import classes from './Auth.module.scss';
import logo from '../../assets/images/Logo.svg'
import video1 from '../../assets/videos/login_video.mp4'
import video2 from '../../assets/videos/login_video.webm'
const Auth = () => {
  return (
    <div className={classes.authContainer}>
        <img src={logo} alt="dziklogo" />
        <div className={classes.textContainer}>
          <p>Ćwicz.</p>
          <p>Rośnij.</p>
          <p>Dzikuj.</p>
        </div>
        <div className={classes.authVideo}>
          <video className={classes.authVideoContent} autoPlay  muted loop>
            <source src={video1} type="video/mp4" />
            <source src={video2} type="video/webm" />
            Your browser is not supported!
          </video>
        </div>
      <Redirect to="/auth/login" />
      <Switch>
        <Route path="/auth/login" render={() => <Login/>} exact />
        <Route path="/auth/register" component={() => <Register/>} exact />
      </Switch>
    </div>
  );
};

export default Auth;
