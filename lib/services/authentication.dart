import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'validation.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ValidationService _validationService = ValidationService();

  Future<void> signUp(String email, String password, String username) async {
    try {
      if (!_validationService.validateFields(username, email, password)) {
        // Validation failed, handle it as needed
        return;
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username.trim(),
        'email': email.trim(),
      });
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }
}
