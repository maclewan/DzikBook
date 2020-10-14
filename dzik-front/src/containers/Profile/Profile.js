import React from "react";
import { Route, Switch, Redirect } from "react-router";

import PersonalData from "./PersonalData/PersonalData";
import Navigation from "../../components/navigation/navigation";
const Auth = () => {
  return (
    <div>
      <Navigation />
      <Redirect to="/profile/personal-data" />
      <Switch>
        <Route path="/profile/personal-data" component={PersonalData} exact />
      </Switch>
    </div>
  );
};

export default Auth;
