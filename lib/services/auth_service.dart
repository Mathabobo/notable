import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notable/constants.dart';
import 'package:notable/screens/login.dart';
import 'package:notable/screens/notes.dart';

class AuthService {
  // String userId;

  //*handleAuthState
  handleAuthState() {
    return StreamBuilder(
      stream: firebaseauth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // String userId = snapshot.data!.uid;
          // print(userId);
          return const Notes();
        }
        return const Login();
      },
    );
  }

  // void userId () async {
  //  final user = firebaseAuth.currentUser!.uid;
  // }

  late var userId = firebaseauth.currentUser!.uid;

  //currentUser
  // Future<String> get userId =>
  //     signInWithGoogle().then((value) => value.user!.uid);

  //signInWithGoogle
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await firebaseauth.signInWithCredential(credential);
  }

  //SignInOut
  Future signOut() async {
    await GoogleSignIn().disconnect();
    // GoogleUserCircleAvatar(identity: GoogleIdentity)
    await firebaseauth.signOut();
    // userIde = '';
  }
}
