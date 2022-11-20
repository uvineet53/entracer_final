import 'package:entracer/services/validation.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthWidgets with Validators {
  Widget entryField({
    required TextEditingController controller,
    String? title,
    bool isPass = false,
  }) {
    return TextFormField(
      controller: controller,
      autocorrect: false,
      style: const TextStyle(
        color: Vx.white,
        fontSize: 20,
      ),
      validator: (value) =>
          isPass ? passValidator(value) : emailValidator(value),
      obscureText: isPass,
      decoration: InputDecoration(
        hintText: title,
        hintStyle: const TextStyle(
          color: Vx.green300,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Vx.green300,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Vx.white,
            width: 1.5,
          ),
        ),
      ),
    ).py4();
  }
}
