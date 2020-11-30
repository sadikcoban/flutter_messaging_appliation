import 'package:chat_app/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';
import "dart:io";

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
  AuthForm(this.submitFn, this._isLoading);

  final void Function(
    File image,
    String email,
    String username,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  final bool _isLoading;
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = "";
  var _userName = "";
  var _userPassword = "";
  File _userImage;

  void _pickedImage(File image) {
    _userImage = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImage == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text("Please pick an image."),
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState
          .save(); //triggers the onSsaved methods of textformfields in form
      widget.submitFn(
        _userImage,
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey("email"),
                    validator: (value) {
                      if (value.isEmpty || !value.contains("@")) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email address",
                    ),
                    onSaved: (newValue) {
                      _userEmail = newValue;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey("username"),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return "Usename must be at least 4 characters long";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Username",
                      ),
                      onSaved: (newValue) {
                        _userName = newValue;
                      },
                    ),
                  TextFormField(
                    key: ValueKey("password"),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return "Password must be at least 7 characters long";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    obscureText: true,
                    onSaved: (newValue) {
                      _userPassword = newValue;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget._isLoading) CircularProgressIndicator(),
                  if (!widget._isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? "Login" : "Signup"),
                      onPressed: () {
                        _trySubmit();
                      },
                    ),
                  if (!widget._isLoading)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      textColor: Theme.of(context).primaryColor,
                      child: Text(_isLogin
                          ? "Create new account"
                          : "I already have an account"),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
