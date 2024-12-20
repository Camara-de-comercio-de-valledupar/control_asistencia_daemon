import 'dart:math';

import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<String> generatePassword() async {
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

  // Copy the password to the clipboard

  await Clipboard.setData(ClipboardData(text: password));
  Get.find<PushAlertController>().add(PushAlertSuccess(
    title: "Contraseña generada",
    body: "La contraseña ha sido copiada al portapapeles",
  ));

  return password;
}
