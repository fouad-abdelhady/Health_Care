import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_healthcare_app/src/config/route.dart';
import 'package:flutter_healthcare_app/src/widgets/dialogs.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';
import 'package:flutter_healthcare_app/src/widgets/common_widgets.dart';
import 'package:flutter_healthcare_app/src/theme/text_styles.dart';

class Authentication {
  static const String USER = "User";
  static const String DOCTOR = "Doctor";

  static Authentication _authentication = Authentication._internal();
  FirebaseAuth _auth;

  factory Authentication() => _authentication;

  Authentication._internal();

  FirebaseAuth getFireBaseAuthObj() {
    if(_auth == null)
      _auth = FirebaseAuth.instance;
    return _auth;
  }
  // Register user using email and password
  Future createAccount(
      {String email,
      String password,
      BuildContext context}) async {

    try {
      getFireBaseAuthObj();
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user.uid;
    } on FirebaseAuthException catch (e) {

      String messege = "";

      if (e.code == 'weak-password') {
        messege = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        messege = 'The account already exists for that email.';
      } else
        messege = e.message;

      showAlertError(context: context, messege: messege).then((value) => null);

    } catch (e) {
      showAlertError(context: context, messege: e.toString())
          .then((value) => null);
    }
  }

  Future signInWithEmailPassword(
      {String email, String password, BuildContext context}) async {
    try {
      print("---------------------------- in sign in user" );
      getFireBaseAuthObj();
      UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      print("---------------------------- user signed in" );
      return true;
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      showAlertError(context: context, messege: message);
      return false;
    } catch (e) {
      print("---------------------------- sign in other error" );
      showAlertError(context: context, messege: e.toString());
      return false;
    }
  }

  Future  signOutCurrentUser({BuildContext context})async{
    getFireBaseAuthObj();
    if(_auth.currentUser == null)
      return true;
    try{
      await _auth.signOut();
      Navigator.of(context).pushReplacementNamed(Routes.LOGIN_PAGE);
    } on FirebaseAuthException catch (e) {
      showAlertError(
          context: context,
          messege: "Error occurred while signing out");
    }
    return false;
  }

  Future setUserType({String userType, BuildContext context}) async {
    getFireBaseAuthObj();
    if (_auth.currentUser == null) return false;
    try {
      await _auth.currentUser.updateProfile(displayName: userType);
      return true;
    } on FirebaseAuthException catch (e) {
      showAlertError(
          context: context,
          messege: "Error occured while setting up the account");
    }
    return false;
  }

  Future showAlertError({BuildContext context, String messege}) async {
    await Dialogs.showInfoDialog(
      dismiss: (){EasyLoading.dismiss();},
        context: context,
        title: "Error",
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: LightColor.red,
              size: 35,
            ),
            TextWidgets.getText(
                text: messege,
                fontSize: FontSizes.title,
                color: LightColor.black)
          ],
        ));
  }

  bool checkAccountCompletion({BuildContext context}){
    getFireBaseAuthObj();
    if(_auth.currentUser == null)
      return false;
    if(_auth.currentUser.displayName == USER || _auth.currentUser.displayName == DOCTOR)
      return true;
    return false;
  }

  Future deleteUser({BuildContext context}) async {
    getFireBaseAuthObj();
    if(_auth.currentUser == null){
      return false;
    }
    try{
      await _auth.currentUser.delete();
      return true;
    } on FirebaseAuthException catch(e){

      showAlertError(context: context, messege: e.message);
    }
    return false;
  }
}
