import 'package:flutter/material.dart';

class LoginForm {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  LoginForm(this.emailController, this.passwordController);

  LoginForm.init() {
    emailController = TextEditingController(text: 'john@mail.com');
    passwordController = TextEditingController(text: 'changeme');
  }
}
