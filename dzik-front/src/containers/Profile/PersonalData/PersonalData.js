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

  const changeSensData = (link) => {
    // exec link to change password/email
    console.log(link)
    return 0;
  };

  const [dataEdited, setDataEdited] = useState(false);
  
  const [name, setName] = useState({
    editable: false,
    value: dataList[0],
    buttonText: "Edytuj",
    type: "text",
  });
  const [username, setUsername] = useState({
    editable: false,
    value: dataList[1],
    buttonText: "Edytuj",
    type: "text",
  });
  const [email, setEmail] = useState({
    editable: false,
    value: dataList[2],
    buttonText: "Edytuj",
    type: "email",
    link: 'link to change email'
  });
  const [homeAddress, setHomeAddress] = useState({
    editable: false,
    value: dataList[3],
    buttonText: "Edytuj",
    type: "text",
  });
  const [gymAddress, setGymAddress] = useState({
    editable: false,
    value: dataList[4],
    buttonText: "Edytuj",
    type: "text",
  });
  const [password, setPassword] = useState({
    editable: false,
    value: dataList[5],
    buttonText: "Edytuj",
    type: "password",
    link: 'link to change password'
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
      <p key={id} className={classes.dataRow__type}>
        {type}
      </p>
    );
  });

  const data = dataList.map((data, id) => {
    const inputClasses = variables[id][0]["editable"]
      ? [classes.dataRow__input, classes.readWrite]
      : [classes.dataRow__input, classes.readOnly];

    return (
      <li key={id} className={classes.dataRow}>
        {infoTypes[id]}
        <input
          className={inputClasses.join(" ")}
          readOnly={!variables[id][0]["editable"]}
          value={variables[id][0]["value"]}
          type={variables[id][0]["type"]}
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
          className={classes.dataRow__button}
          onClick={(event) => {
            const type = variables[id][0];
            const setType = variables[id][1];
            let editable = type["editable"];
            let buttonText = type["buttonText"];

            const input = event.target.closest('li').querySelector('input')
            input.focus()

            if(type.hasOwnProperty('link')) {
              changeSensData(type['link'])
              editable = false;
              input.blur();
            }
            else {
              if (editable) {
                buttonText = 'Edytuj'
                input.blur();
              }
              else {
                buttonText = 'Zapisz'
                input.focus();
              }
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
      </li>
    );
  });

  const updateData = () => {
    // post updated data to database
    console.log('send post to backend with updated data')
  };

  const submitButton = dataEdited ? (
    <button className={classes.submitButton} onClick={updateData}>
      Submit changes
    </button>
  ) : null;
  return (
    <div className={classes.background}>
      <div className={classes.personalData}>
        {/* <ul className={classes.personalData__typesList}>{infoTypes}</ul> */}
        <ul className={classes.personalData__dataList}>{data}</ul>
        {submitButton}
      </div>    
    </div>
  );
};

export default PersonalData;
