class ValidationService {
  bool validateFields(String username, String email, String password) {
    if (username.trim().isEmpty) {
      print('Please enter a username.');
      return false;
    }

    if (email.trim().isEmpty || !email.contains('@')) {
      print('Please enter a valid email address.');
      return false;
    }

    if (password.trim().isEmpty || password.trim().length < 6) {
      print('Please enter a password with at least 6 characters.');
      return false;
    }

    return true;
  }
}
