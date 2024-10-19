String? stringValidator(String? value) {
  if (value == null) {
    return 'Este campo es requerido';
  }
  if (value.isEmpty) {
    return 'Este campo es requerido';
  }
  return null;
}

String? emailValidator(String? value) {
  if (value == null) {
    return 'Este campo es requerido';
  }
  if (value.isEmpty) {
    return 'Este campo es requerido';
  }
  if (!value.contains('@')) {
    return 'Correo inválido';
  }
  return null;
}

// Debe tener letras, números y al menos un carácter especial
String? passwordValidator(String? value) {
  if (value == null) {
    return 'Este campo es requerido';
  }
  if (value.isEmpty) {
    return 'Este campo es requerido';
  }
  if (value.length < 6) {
    return 'La contraseña debe tener al menos 6 caracteres';
  }
  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{6,}$')
      .hasMatch(value)) {
    return 'La contraseña debe tener letras, números y al menos un carácter especial';
  }
  return null;
}

String? boolValidator(bool? value) {
  if (value == null) {
    return 'Este campo es requerido';
  }
  return null;
}
