import React from "react";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import  Auth  from './containers/Auth/Auth';
import Profile from './containers/Profile/Profile'
import classes from './App.module.scss'; 
function App() {
  return (
    <Router>
      <div className={classes.mainContainer}>
        <Switch>
          <Route path="/auth" component={Auth} />
          <Route path="/profile" component={Profile}/>
        </Switch>
      </div>
    </Router>
  );
}

export default App;
