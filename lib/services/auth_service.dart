import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Google Sign In
  Future<UserCredential> signInWithGoogle() async {
    //Begin Interactive Sign In Process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    //Obtain outh details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    //finally lets Sign In
    return _auth.signInWithCredential(credential);
  }

  //sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    final UserCredential userCredential = await _auth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  // register with email and password

  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    final UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  // Sign Out

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
