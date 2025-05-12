class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    print('Validating password: $value');

    final passwordRegex = RegExp(
        r'^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,}$');

    print('Password regex: $passwordRegex');
    print(value);
    print('Password regex match: ${passwordRegex.hasMatch(value)}');
    print('Password length: ${value.length}');
    if (!passwordRegex.hasMatch(value)) {
      return 'Password must contain at least 8 characters, '
          'one uppercase letter, one lowercase letter, and one number';
    }
    print('Password is valid');

    return null;
  }
}
