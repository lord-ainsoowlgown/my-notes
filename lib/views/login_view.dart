import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilites/show_error_dialog.dart';
import 'dart:developer' as devtools show log; 

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _password,

            // Make our password text field secure
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,

            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password here',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );

                final user = AuthService.firebase().currentUser;
                devtools.log(
                  'User logged in: ${user?.isEmailVerified}',
                );
                if (user?.isEmailVerified ?? false) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                } else {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
                }
              } on InvalidCredentialsException {
                await showErrorDialog(
                  context,
                  'Invalid Credentials',
                );
              } on InternetRequestFailedException {
                await showErrorDialog(
                  context,
                  'Wrong credentials, please try again',
                );
              } on GenericException {
                await showErrorDialog(
                  context,
                  'Authentication error',
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Not register yet? Register here!'),
          ),
        ],
      ),
    );
  }
}
