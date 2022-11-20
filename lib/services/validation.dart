mixin Validators {
  String? emailValidator(String? value) {
    if (value == null || value == "") {
      return "Email can't be empty";
    } else if (!value.contains("@")) {
      return "Email is invalid";
    }
    return null;
  }

  String? passValidator(String? value) {
    if (value == null || value == "") {
      return "Password can't be empty";
    } else if (value.length < 6) {
      return "Minimum password length is 6";
    }
    return null;
  }
}
