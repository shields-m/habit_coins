import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_coins/globals.dart' as globals;
import 'package:habit_coins/localData.dart';
import 'package:habit_coins/models.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<void> sendPasswordResetEmail();

  Future<bool> forgotPassword(String email);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    var user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    globals.UseCloudSync = true;
    globals.CurrentUser = user.user.uid;
    globals.userDetails = await getUserDetailsForCurrentUser();

    if (globals.userDetails.TeamID != 'null' &&
        globals.userDetails.TeamID != '') {
      globals.myTeam = new Team();
    }

    return user.user.uid;
  }

  Future<void> sendPasswordResetEmail() async
  {
    await _firebaseAuth.currentUser().then((u){
      _firebaseAuth.sendPasswordResetEmail( email: u.email);
    });
    
  }

  Future<bool> forgotPassword(String email) async
  {
    bool done = true;
    await  _firebaseAuth.sendPasswordResetEmail( email: email).catchError((e){
      done = false;
    });
    
    return done;
  }

  Future<String> signUp(String email, String password) async {
    var user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    return await signIn(email, password);
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    globals.UseCloudSync = false;
    globals.CurrentUser = '';
    globals.userDetails = new UserDetails();
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
