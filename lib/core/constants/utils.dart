bool isEmailValid(String email) {
  // Defined a regex pattern for a valid email address
  const String emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
  final RegExp regex = RegExp(emailPattern);
  return regex.hasMatch(email);
}
