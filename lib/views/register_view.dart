import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is InvalidEmailException) {
            await showErrorDialog(context, 'Invalid email address');
          } else if (state.exception is WeakPasswordException) {
            await showErrorDialog(context, 'Weak password');
          } else if (state.exception is InternetRequestFailedException) {
            await showErrorDialog(context, 'Internet Connection Not Available');
          } else if (state.exception is EmailAlreadyInUseException) {
            await showErrorDialog(context, 'Email already in use');
          } else if (state.exception is GenericException) {
            await showErrorDialog(context, 'Failed to register');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your email and password to see your notes!',
              ),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
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
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                              
                        context.read<AuthBloc>().add(
                          AuthEventRegister(
                            email,
                            password,
                          ),
                        );
                      },
                      child: const Text('Register'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(const AuthEventLogout());
                      },
                      child: const Text('Already registered? Login here!'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
