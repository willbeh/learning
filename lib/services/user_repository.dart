import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learning/models/profile.dart';
import 'package:learning/models/profile.service.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
//  final FacebookLogin _facebookLogin;

  Stream<FirebaseUser> get onAuthStateChange {
    return _firebaseAuth.onAuthStateChanged.map((user) => user);
  }

//  FirebaseUser user;

  static final UserRepository _singleton = UserRepository._internal();

  factory UserRepository() {
    return _singleton;
  }

  UserRepository._internal()
      : _firebaseAuth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn();

//  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
//      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
//        _googleSignIn = googleSignin ?? GoogleSignIn();

//  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin, FacebookLogin facebookLogin})
//      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
//        _googleSignIn = googleSignin ?? GoogleSignIn(),
//        _facebookLogin = facebookLogin ?? FacebookLogin();


  /// Sign in using email and password

  Future<FirebaseUser> signInWithCredentials(String email, String password) async{
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return result.user;
  }


  /// Sign up new user with email and password

  Future<FirebaseUser> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return result.user;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if(googleUser == null)
      return null;

//    Profile profile = await profileFirebaseService.findOne(query: profileFirebaseService.colRef.where('email', isEqualTo: googleUser.email)).first;
//
//    if(profile == null) {
//      print('signInWithGoogle no profile');
//      throw 'No Profile';
//    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

//  Future<FirebaseUser> signInWithFacebook() async {
//    print('UserRepository signInWithFacebook');
//    final result = await _facebookLogin.logInWithReadPermissions(['email']);
//    print('UserRepository signInWithFacebook result $result');
//    switch (result.status) {
//      case FacebookLoginStatus.loggedIn:
//        print('UserRepository signInWithFacebook token ${result.accessToken.token}');
//        final token = result.accessToken.token;
//        final AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: token);
//        await _firebaseAuth.signInWithCredential(credential);
//        return _firebaseAuth.currentUser();
//        break;
//      case FacebookLoginStatus.cancelledByUser:
//        throw 'Cancelled';
////        return null;
////        break;
//      case FacebookLoginStatus.error:
//        print('UserRepository signInWithFacebook error ${result.errorMessage}');
//        throw result.errorMessage;
////
////        return null;
////        break;
//    }
//
//  }





  // Exmaple code of how to veify phone number
//  void verifyPhoneNumber(BuildContext context, String phoneNumber,
//      PhoneVerificationFailed verificationFailed, PhoneCodeSent codeSent, PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout ) async {
//    final PhoneVerificationCompleted verificationCompleted =
//        (AuthCredential phoneAuthCredential) {
//      print('_verifyPhoneNumber Received phone auth credential: $phoneAuthCredential');
//      Scaffold.of(context).showSnackBar(SnackBar(
//        content: Text('_verifyPhoneNumber Received phone auth credential: $phoneAuthCredential'),
//      ));
//      _firebaseAuth.signInWithCredential(phoneAuthCredential).then((user) {
//        print('_verifyPhoneNumber signInWithCredential user: $user');
////        AuthBLOC.loginRoute(context, user: user);
//      });
//
//    };
//
//    await _firebaseAuth.verifyPhoneNumber(
//        phoneNumber: phoneNumber,
//        timeout: const Duration(seconds: 5),
//        verificationCompleted: verificationCompleted,
//        verificationFailed: verificationFailed,
//        codeSent: codeSent,
//        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
//  }
//
//  Future<FirebaseUser> signInWithPhoneNumber(String verificationId, String sms) async {
//    final AuthCredential credential = PhoneAuthProvider.getCredential(
//      verificationId: verificationId,
//      smsCode: sms,
//    );
//    final FirebaseUser user = await _firebaseAuth.signInWithCredential(credential);
//    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
//    assert(user.uid == currentUser.uid);
//
//    return currentUser;
//  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getUser() async {
    return await _firebaseAuth.currentUser();
  }

//  Future changePassword(String current, String password) async {
//    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
//
//    return _firebaseAuth.signInWithEmailAndPassword(email: currentUser.email, password: current).then((user) {
//      return user.updatePassword(password);
//    }).catchError((error) => throw error);
//  }

  Future resetPassword(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}

UserRepository userRepository = UserRepository();