import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoggingIn = false;

  startAuthentication() {
    final validity = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (validity) {
      formKey.currentState!.save();
      submitForm(_email.trim(), _password.trim(), _username.trim());
    }
  }

  submitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;
    try {
      if (isLoggingIn) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String userId = authResult.user!.uid;
        await FirebaseFirestore.instance
            .collection('user')
            .doc(userId)
            .set({'username': username, 'email': email});
      }
    } on PlatformException catch (err) {
      var message = 'An error occured,please check your credentials';

      if (err.message == null) {
        message = err.message!;
      }

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //if (!isLoggingIn)
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          key: ValueKey('email'),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              enabledBorder:
                                  OutlineInputBorder(borderSide: BorderSide()),
                              border:
                                  OutlineInputBorder(borderSide: BorderSide()),
                              labelText: 'Enter Email'),
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Incorrect Email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                        ),
                      /////////////
                      SizedBox(
                        height: 10,
                      ),

                      if(!isLoggingIn)
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('username'),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide()),
                            border:
                                OutlineInputBorder(borderSide: BorderSide()),
                            labelText: 'Enter Username'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Username';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _username = value!;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        //obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('password'),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide()),
                            border:
                                OutlineInputBorder(borderSide: BorderSide()),
                            labelText: 'Enter Password'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        width: 225,
                        height: 50,
                        child: ElevatedButton(
                          child: isLoggingIn ? Text('Login') : Text('Sign Up'),
                          onPressed: startAuthentication,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(isLoggingIn
                              ? 'Not a Member ?'
                              : "Already have an Account ?"),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isLoggingIn = !isLoggingIn;
                              });
                            },
                            child: Text(
                              isLoggingIn ? "Sign Up" : 'Log In',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.red),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}

Widget makeInput({label, obscureText = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
      ),
      SizedBox(
        height: 5,
      ),
      TextFormField(
        key: ValueKey('email'),
        obscureText: obscureText,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(),
            border: OutlineInputBorder()),
      ),
      SizedBox(
        height: 30,
      )
    ],
  );
}
