import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greenland/services/authentication.dart';
import 'package:greenland/services/validation.dart';
import 'package:greenland/models/colors.dart';
import 'package:greenland/models/buttons.dart';
import 'LoginPage.dart';

class SignUpPage extends StatelessWidget {
  
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthenticationService _authenticationService = AuthenticationService();
  final ValidationService _validationService = ValidationService();

  Future<void> _signUp(BuildContext context) async {
    try {
      if (_validationService.validateFields(
          usernameController.text, emailController.text, passwordController.text)) {
        await _authenticationService.signUp(
          emailController.text,
          passwordController.text,
          usernameController.text,
        );

        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up successful!'),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to the Login Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } else {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                // Logo Image
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

                // Username Input
                TextFormField(
                  controller: usernameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Username',
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a username.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Email Input
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
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Password Input
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
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Please enter a password with at least 6 characters.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Sign Up Button
                SignUpButton(
                  onPressed: () => _signUp(context),
                  label: 'Sign Up',
                ),

                // Already have an account? Login Link
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the login page
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );

                      },
                      child: Text(
                        'Login here',
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
      ),
    );
  }
}

