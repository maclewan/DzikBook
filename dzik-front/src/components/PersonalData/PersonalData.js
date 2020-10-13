import React, { useState } from "react";

import classes from "./PersonalData.module.scss";

const PersonalData = (props) => {
  const infoTypesList = [
    "Imię i nazwisko",
    "Nazwa użytkownika",
    "Adres e-mail",
    "Adres zamieszkania",
    "Adres siłowni",
    "Hasło",
  ];
  const dataList = [
    "Paweł Kubala",
    "kubciooo",
    "pkubala.1lo@gmail.com",
    "Wrocław",
    "Adres siłowni",
    "Hasło",
  ];

  const editEmail = () => {
    // send email with link enabling email change
    return false;
  };

  const editPassword = () => {
    // send email with link enabling password change
    return false;
  };

  const [dataEdited, setDataEdited] = useState(false);

  const [name, setName] = useState({
    editable: false,
    value: dataList[0],
    buttonText: "Edytuj",
  });
  const [username, setUsername] = useState({
    editable: false,
    value: dataList[1],
    buttonText: "Edytuj",
  });
  const [email, setEmail] = useState({
    editable: editEmail,
    value: dataList[2],
    buttonText: "Edytuj",
  });
  const [homeAddress, setHomeAddress] = useState({
    editable: false,
    value: dataList[3],
    buttonText: "Edytuj",
  });
  const [gymAddress, setGymAddress] = useState({
    editable: false,
    value: dataList[4],
    buttonText: "Edytuj",
  });
  const [password, setPassword] = useState({
    editable: editPassword,
    value: dataList[5],
    buttonText: "Edytuj",
  });

  const variables = [
    [name, setName],
    [username, setUsername],
    [email, setEmail],
    [homeAddress, setHomeAddress],
    [gymAddress, setGymAddress],
    [password, setPassword],
  ];

  const infoTypes = infoTypesList.map((type, id) => {
    return (
      <li key={id} className={classes.infoType}>
        {type}
      </li>
    );
  });

  const data = dataList.map((data, id) => {
    return (
      <div key={id} className={classes.DataRow}>
        <input
          className={classes.DataRow__input}
          readOnly={!variables[id][0]["editable"]}
          value={variables[id][0]["value"]}
          onChange={(event) => {
            const type = variables[id][0];
            const value = event.target.value;
            variables[id][1]({
              ...type,
              value: value,
            });
            setDataEdited(true);
          }}
        />

        <button
          className={[classes.Button, classes.DataRow__button].join(" ")}
          onClick={() => {
            const type = variables[id][0];
            const setType = variables[id][1];
            let editable = type["editable"];
            let buttonText = type["buttonText"];

            if (editable === true || editable === false) {
              buttonText = editable ? "Edytuj" : "Zapisz";
              editable = !type["editable"];
            }
            setType({
              ...type,
              editable: editable,
              buttonText: buttonText,
            });
          }}
        >
          {
            variables[id][0]["buttonText"] // buttonText
          }
        </button>
      </div>
    );
  });

  const updateData = () => {
    // post updated data to database
  }

  const submitButton = dataEdited ? (
    <button className={classes.Button} onClick={updateData}>Submit changes</button>
  ) : null;
  return (
    <React.Fragment>
      <div className={classes.PersonalData}>
        <ul className={classes.PersonalData__typesList}>{infoTypes}</ul>
        <ul className={classes.PersonalData__dataList}>{data}</ul>
      </div>
      {submitButton}
    </React.Fragment>
  );
};

export default PersonalData;
