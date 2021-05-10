import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/classes/system_users.dart';
import 'package:flutter_healthcare_app/src/config/route.dart';
import 'package:flutter_healthcare_app/src/data_manager/DataManager.dart';
import 'package:flutter_healthcare_app/src/model/dactor_model.dart';
import 'package:flutter_healthcare_app/src/model/user_model.dart';
import 'package:flutter_healthcare_app/src/widgets/common_widgets.dart';
import 'package:flutter_healthcare_app/src/data_manager/acuthentication.dart';
import 'package:flutter_healthcare_app/src/widgets/dialogs.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final emailController = new TextEditingController();
  final passwordController= new TextEditingController();

  static final String PAGE_TITLE = 'Login';
  static final String EMAIL_HINT_TEXT = 'E-mail Address';
  static final String PASSWORD_HINT_TEXT = 'Password';
  static final String EMAIL_LABLE_TEXT = 'E-Mail';
  static final String PASSWORD_LABLE_TEXT = 'Password';
  static final String CREATE_ACCOUNT = 'Create Account';

  static bool isVisible = false;
  static bool enabled = true;

  final _formKey = GlobalKey<FormState>();
  DataManager dataManager;

  Authentication auth;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = Authentication();
    dataManager = DataManager();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: SafeArea(
          child: getBody(),
        ),
      ),
    );
  }

  Padding getBody() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_X/2),
                TextWidgets.getTitleText(title: PAGE_TITLE),
                BoxesAndButtons.getSizedBox(height:BoxesAndButtons.SPACE_X),
                TextFields.getTextFormField(
                  hintText: EMAIL_HINT_TEXT,
                  labelText: EMAIL_LABLE_TEXT,
                  type: TextInputType.emailAddress,
                  controller: emailController,
                  enabled: enabled,
                  prefixIcon: Icon(Icons.person),
                ),
                BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
                TextFields.getPasswordTextField(
                  hintText: PASSWORD_HINT_TEXT,
                  labelText: PASSWORD_LABLE_TEXT,
                  isVisible: isVisible,
                  updateVisibility: setVisibilityState,
                  controller: passwordController,
                  errorMessage: ""
                ),
                BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_X/2),
                BoxesAndButtons.getFlatButton(text: PAGE_TITLE, onPresssed: loginUser),
                BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
                TextWidgets.getClickableText(onPress: moveToCreateAccount, text: CREATE_ACCOUNT),
              ],
            ),
          )
        ],
      ),
    );
  }

  void setVisibilityState(){
    setState(() {
      isVisible = !isVisible;
    });
  }

  void loginUser() async {
    try{
      if(!isValid()) return;
      await auth.signInWithEmailPassword(
          email: emailController.text,
          password: passwordController.text,
          context: context).then((value){
            if(!value){
              Dialogs.showErrorDialog(message: "Wrong email or password", context: context);
              return;
            }
            String userType = auth.getFireBaseAuthObj().currentUser.displayName;
            String userId = auth.getFireBaseAuthObj().currentUser.uid;
            SystemUsers user;
            String url;
            if(userType == Authentication.USER){
              user = UserModel();
              url = DataManager.getUserDataUrl(firebaseId: userId);
            }
            else{
              user = DoctorModel();
              url = DataManager.DOCTOR_DATA_URL+userId;
            }
            dataManager
                .getData(
                url: url)
                .then((value) {
              if(value == null){
                return;
              }
              if(userType  == Authentication.USER){
                user = UserModel();
                user = UserModel.fromJson(value);
                Navigator.of(context).pushReplacementNamed(Routes.HOME_PAGE, arguments: user);
              }
              else{
                user = DoctorModel();
                user = DoctorModel.fromJson(value);
                Navigator.of(context).pushReplacementNamed(Routes.HOME_PAGE, arguments: user);
              }
            });
            /*getUsersData(user, userId).then((value){
              print("in get users data call back");
              if(!value)
                Dialogs.showErrorDialog(message: "Error Occurred while getting your data", context: context);
              else{
                Navigator.of(context).pushReplacementNamed(Routes.HOME_PAGE, arguments: user);
              }
            });*/
      });
  }catch(e){
      Dialogs.showErrorDialog(message: "Check Email and password then try again", context: context);
    }
  }

  Future getUsersData(SystemUsers user, String uId) async {
    Map<String, dynamic> userMap;
    if(user is DoctorModel){
      userMap = await dataManager.getData(url: DataManager.DOCTOR_DATA_URL+uId);
      if(userMap == null) return false;
      user = DoctorModel.fromJson(userMap);
    }
    else{
      userMap = await dataManager.getData(url: DataManager.getUserDataUrl(firebaseId: uId));
      if(userMap == null) return false;
      user = UserModel.fromJson(userMap);
      print("User map ------------ "+userMap.toString());
    }
      return true;
  }




  bool isValid(){
    if(!_formKey.currentState.validate()){
      return false;
    }
    return true;
  }
  void moveToCreateAccount(){
    Navigator.of(context).pushReplacementNamed(Routes.CREATE_ACCOUNT_PAGE);
  }
}
