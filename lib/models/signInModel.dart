import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInModel {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> signInGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    print('1----------');
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    print('2----------');
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;
    assert(!user.isAnonymous);
    print('3----------');
    assert(await user.getIdToken() != null);
    print('4----------');
    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);
    print('currentUser ' + currentUser.email);
    return currentUser;
  }

  Future<bool> isGoogleSignedIn() async {
    bool result = await _googleSignIn.isSignedIn();
    return result;
  }

  Future signOutGoogle() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  User getCurrentUser() {
    return _auth.currentUser;
  }
}
