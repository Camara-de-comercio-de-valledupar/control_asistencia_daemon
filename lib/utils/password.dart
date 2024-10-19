import 'dart:math';

String generatePassword() {
  final random = Random.secure();
  const specialChars = '!@#%^&*()_+';
  const lowerCase = 'abcdefghijklmnopqrstuvwxyz';
  const upperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const numbers = '0123456789';

  const allChars = '$specialChars$lowerCase$upperCase$numbers';

  String password = '';

  for (var i = 0; i < 20; i++) {
    password += allChars[random.nextInt(allChars.length)];
  }

  return password;
}
