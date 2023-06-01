import 'package:flutter/material.dart';
import 'package:notable/services/auth_service.dart';

// late String userId;

class Login extends StatelessWidget {
  const Login({super.key});

  //LoginScreen route name
  static const routeName = '/login-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // UserCredential user =
            AuthService().signInWithGoogle();
            // .then((value) => userId = value.user!.uid);
            // final String userId = user.user!.uid;
          },
          child: const Text('SignIn'),
        ),
      ),
    );
  }
}
