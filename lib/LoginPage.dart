import 'package:flutter/material.dart';
import 'package:greenland/services/authentication.dart';
import 'HomePage.dart';
import 'SignUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:greenland/models/colors.dart';
import 'package:greenland/models/buttons.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthenticationService _authenticationService = AuthenticationService();
  String errorMessage = '';
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  _loadRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('rememberMe') ?? false;
      if (rememberMe) {
        emailController.text = prefs.getString('email') ?? '';
      }
    });
  }

  _saveRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', rememberMe);
    if (rememberMe) {
      prefs.setString('email', emailController.text);
    } else {
      prefs.remove('email');
    }
  }

  Future<void> _login(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Password is correct, navigate to HomePage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          errorMessage = 'Incorrect email or password.';
        } else {
          errorMessage = 'Incorrect email or password. Please try again!';
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signup(BuildContext context) async {
    try {
      await _authenticationService.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
   
        'exampleUsername',
      );
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpPage()),
        );

    } catch (e) {

      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  sage_green,
                  mint,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("lib/assets/images/logo.png"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(75),
                        border: Border.all(
                          color: Colors.white,
                          width: 3.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    errorMessage.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              errorMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.0,
                              ),
                            ),
                          )
                        : Container(),
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                        ),
                        Text('Remember Me', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    LoginButton(
                      onPressed: () {
                        _saveRememberMe();
                        _login(context);
                      },
                      label: 'Login',
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _saveRememberMe();
                            _signup(context);
                          },
                          child: Text(
                            'Register Here',
                            style: TextStyle(
                              color: fern,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
