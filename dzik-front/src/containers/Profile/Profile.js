import React from "react";
import { Route, Switch, Redirect } from "react-router";
import PersonalData from "../../components/PersonalData/PersonalData";
const Auth = () => {
  return (
    <div>
      <Redirect to="/profile/personal-data" />
      <Switch>
        <Route path="/profile/personal-data" component={PersonalData} exact />
      </Switch>
    </div>
  );
};

export default Auth;
