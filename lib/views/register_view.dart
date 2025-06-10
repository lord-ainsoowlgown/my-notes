import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilites/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text('Register')),
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
                await AuthService.firebase().createUser(
                      email: email,
                      password: password,
                    );

                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(
                  verifyEmailRoute,
                );
              } on InvalidEmailException {
                await showErrorDialog(context, 'Invalid email address');
              } on WeakPasswordException {
                await showErrorDialog(context, 'Weak password');
              } on EmailAlreadyInUseException {
                await showErrorDialog(context, 'Email already in use');
              } on InternetRequestFailedException {
                await showErrorDialog(
                  context,
                  'No Internet connection available',
                );
              } on GenericException {
                await showErrorDialog(context, 'Failde to register');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already registered? Login here!'),
          ),
        ],
      ),
    );
  }
}
