import 'package:flutter/material.dart';
import 'package:greenland/models/colors.dart';

class GetStartButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const GetStartButton({
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.arrow_forward),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 131, 188, 99),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const LoginButton({
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: fern,
      ),
    );
  }
}


class SignUpButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const SignUpButton({
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: fern,
      ),
    );
  }
}



