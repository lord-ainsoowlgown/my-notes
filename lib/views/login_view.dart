import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                final userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(email: email, password: password);
                print('User logged In: ${userCredential}');
              } on FirebaseAuthException catch (e) {
                print('Error: ${e.code}');
                if (e.code == 'invalid-credential') {
                  print('Invalid credentials');
                } else if (e.code == 'network-request-failed') {
                  print('No Internet connection available');
                } else {
                  print('Something else happened!');
                  print(e.code);
                }
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/register/', (route) => false);
            },
            child: const Text('Not register yet? Register here!'),
          ),
        ],
      ),
    );
  }
}
