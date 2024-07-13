import 'dart:math';

class PasswordGenerate {
  static String generatePassword() {
    final random = Random();
    const upperCaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numericChars = '0123456789';

    String password = '';

    for (int i = 0; i < 4; i++) {
      password += upperCaseChars[random.nextInt(upperCaseChars.length)];
    }

    for (int i = 0; i < 4; i++) {
      password += numericChars[random.nextInt(numericChars.length)];
    }

    return password;
  }
}
