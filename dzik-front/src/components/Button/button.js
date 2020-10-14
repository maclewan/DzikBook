import React from "react";
import classes from "./button.module.scss";
const button = (props) => {
    const classNames = [classes.button, {...props.classNames}];
  return <button className={classNames.join(' ')}>{props.children}</button>;
};

export default button;
