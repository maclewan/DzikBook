import 'package:dzikbook/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../models/HttpException.dart';
import '../widgets/social_icon.dart';

enum AuthMode { SignUp, SignIn }

class AuthScreen extends StatelessWidget {
  static final routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          SingleChildScrollView(
            child: Container(
              // height: deviceSize.height,
              width: deviceSize.width,
              padding: EdgeInsets.only(
                  top: deviceSize.height * 0.15,
                  bottom: deviceSize.height * 0.05),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment(-0.75, 0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment(-0.75, 0),
                            child: SvgPicture.asset('assets/images/dzik.svg'),
                          ),
                          SvgPicture.asset('assets/images/dzikbook.svg'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.05,
                  ),
                  AuthCard(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.SignIn;
  bool _authModeBool = false;
  bool _obscureTextPassword = true;
  Icon _visibility = Icon(Icons.visibility);
  String _changeAuthDesc = "Nie należysz jeszcze do stada?";
  String _btnText = "Zaloguj";
  String _changeAuthText = "Zarejestruj się";
  bool _isLoading = false;

  void _togglePassword() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
      if (_obscureTextPassword) {
        _visibility = Icon(Icons.visibility);
      } else {
        _visibility = Icon(Icons.visibility_off);
      }
    });
  }

  void _toggleAuthType() {
    setState(() {
      _authModeBool = !_authModeBool;
      if (_authMode == AuthMode.SignIn) {
        _authMode = AuthMode.SignUp;
        _changeAuthDesc = "Należysz do stada?";
        _btnText = "Zarejestruj";
        _changeAuthText = "Zaloguj się";
      } else {
        _authMode = AuthMode.SignIn;
        _changeAuthDesc = "Nie należysz jeszcze do stada?";
        _btnText = "Zaloguj";
        _changeAuthText = "Zarejestruj się";
      }
    });
  }

  Map<String, String> _authData = {
    'first-name': '',
    'last-name': '',
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.SignIn) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).signin(
          _authData['email'],
          _authData['password'],
        );

        Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
          // _authData['name'],
          // _authData['username],
        );
        _toggleAuthType();
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: deviceSize.width * 0.6,
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            contentPadding:
                                const EdgeInsets.only(bottom: -2, top: -5),
                            icon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty || !value.contains('@')) {
                              return 'Niepoprawny email!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['email'] = value;
                          },
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.01,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Hasło',
                            contentPadding:
                                const EdgeInsets.only(bottom: -2, top: -5),
                            icon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: _visibility,
                              onPressed: _togglePassword,
                            ),
                          ),
                          obscureText: _obscureTextPassword,
                          validator: (value) {
                            if (value.isEmpty || value.length < 5) {
                              return 'Hasło jest zbyt krótkie!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['password'] = value;
                          },
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.01,
                        ),
                        if (_authMode == AuthMode.SignIn)
                          Align(
                            alignment: Alignment(1, 0),
                            child: GestureDetector(
                              onTap: () {},
                              child: Text(
                                "Zapomniałeś hasła?",
                                style: TextStyle(
                                  color: Color.fromRGBO(77, 105, 204, 1),
                                ),
                              ),
                            ),
                          ),
                        if (_authMode == AuthMode.SignUp)
                          TextFormField(
                            enabled: _authMode == AuthMode.SignUp,
                            decoration: InputDecoration(
                              labelText: 'Imię',
                              contentPadding:
                                  const EdgeInsets.only(bottom: -2, top: -5),
                              icon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Podaj imię!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['first-name'] = value;
                            },
                          ),
                        SizedBox(
                          height: deviceSize.height * 0.01,
                        ),
                        if (_authMode == AuthMode.SignUp)
                          TextFormField(
                            enabled: _authMode == AuthMode.SignUp,
                            decoration: InputDecoration(
                              labelText: 'Nazwisko',
                              contentPadding:
                                  const EdgeInsets.only(bottom: -2, top: -5),
                              icon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value.isEmpty || value.length < 5) {
                                return 'Podaj nazwisko';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['second-name'] = value;
                            },
                          ),
                        SizedBox(
                          height: deviceSize.height * 0.02,
                        ),
                        Material(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: MaterialButton(
                            // onPressed: _submit,
                            onPressed: _submit,
                            height: deviceSize.height * 0.07,
                            minWidth: deviceSize.width * 0.45,
                            textColor: Colors.white,
                            color: Theme.of(context).primaryColor,
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : Text(
                                    _btnText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500),
                                  ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
            SizedBox(
              height: deviceSize.height * 0.05,
            ),
            // if (_authMode == AuthMode.SignIn)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialIcon(
                  deviceSize: deviceSize,
                  icon: 'assets/images/facebook.svg',
                  color: Color.fromRGBO(77, 105, 204, 1),
                  press: () {},
                ),
                SocialIcon(
                  deviceSize: deviceSize,
                  icon: 'assets/images/google.svg',
                  color: Color.fromRGBO(235, 65, 50, 1),
                  press: () {},
                ),
                SocialIcon(
                  deviceSize: deviceSize,
                  icon: 'assets/images/twitter.svg',
                  color: Color.fromRGBO(3, 169, 244, 1),
                  press: () {},
                ),
              ],
            ),
            // if (_authMode == AuthMode.SignIn)
            SizedBox(
              height: deviceSize.height * 0.05,
            ),
            Column(
              children: [
                Text(
                  _changeAuthDesc,
                ),
                SizedBox(height: deviceSize.height * 0.002),
                GestureDetector(
                  onTap: _toggleAuthType,
                  child: Text(
                    _changeAuthText,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
