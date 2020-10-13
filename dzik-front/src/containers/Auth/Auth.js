import React from "react";
import { Route, Switch, Redirect } from "react-router";
import Login from "../../components/Auth/Login/login";
import Register from "../../components/Auth/Register/register";
import classes from './Auth.module.scss';
import logo from '../../assets/images/Logo.svg'
import video from '../../assets/videos/login_video.mp4'
const Auth = () => {
  return (
    <div className={classes.authContainer}>
        <img src={logo} alt="dziklogo" />
        <div class={classes.authVideo}>
          <video class={classes.authVideoContent} autoPlay  muted loop>
            <source src={video} type="video/mp4" />
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
