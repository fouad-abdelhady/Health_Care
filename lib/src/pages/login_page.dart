import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/widgets/common_widgets.dart';

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
          Column(
            children: [
              BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_X/2),
              TextWidgets.getTitleText(title: PAGE_TITLE),
              BoxesAndButtons.getSizedBox(height:BoxesAndButtons.SPACE_X),
              TextFields.getTextField(
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
              ),
              BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_X/2),
              BoxesAndButtons.getFlatButton(text: PAGE_TITLE, onPresssed: loginUser),
              BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
              TextWidgets.getClickableText(onPress: moveToCreateAccount, text: CREATE_ACCOUNT),
            ],
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

  void loginUser(){

  }

  void moveToCreateAccount(){

  }
}
