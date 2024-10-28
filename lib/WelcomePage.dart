import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greenland/LoginPage.dart';
import 'package:greenland/SignUpPage.dart';
import 'package:greenland/models/colors.dart';
import 'package:greenland/models/buttons.dart'; 

class WelcomePage extends StatelessWidget {
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
                ),
              ),
              SizedBox(height: 100),

              // "Welcome to Greenland" Text
              Text(
                'Welcome to Greenland',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: fern,
                ),
              ),
              SizedBox(height: 20),

              // Slogan
              Text(
                'Harvesting Health, Cultivating Taste – Your Organic Oasis for Vibrant Vegetables!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: pickle,
                ),
              ),

              SizedBox(height: 20), 
              // Get Started Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to the LoginPage when button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: fern, // Change button color
                  onPrimary: Colors.white, // Change text color
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40), // Adjust padding
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Apply rounded corners
                ),
                child: Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
