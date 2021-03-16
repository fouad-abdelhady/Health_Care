//region Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';
import 'package:flutter_healthcare_app/src/widgets/common_widgets.dart';
import 'package:flutter_healthcare_app/src/theme/text_styles.dart';
//endregion

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  //region TextFields Controllers
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  //endregion

  bool isPasswordVisible = false;
  bool isRePasswordVisible = false;

  static final String PAGE_TITLE = 'Create Account';
  static final String DOCTOR_ACCOUNT = 'Create Doctor Account';

  static final ENABLE = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: getAppBar(),
        body: SafeArea(
          child: getBody(),
        ),
      ),
    );
  }

  //region Main Page Widgets
  Widget getAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      leading: Icon(
        Icons.arrow_back_ios,
        size: 30,
        color: Colors.black,
      ),
    );
  }
  Widget getBody() {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(

            children: [
              Text(PAGE_TITLE,
              style: TextStyles.h1Style,
              ),
              BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_X),
              Column(
                children: [
                  TextFields.getTextField(
                    type: TextInputType.text,
                    hintText: 'User Name',
                    labelText: 'User Name',
                    prefixIcon: Icon(Icons.person),
                    controller: userNameController,
                    enabled: ENABLE
                  ),
                  BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M, width: 0),
                  TextFields.getTextField(
                      type: TextInputType.emailAddress,
                      hintText: "someone@domain.com",
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      controller: emailController,
                      enabled: ENABLE
                  ),
                  BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M, width: 0),
                  TextFields.getPasswordTextField(
                      isVisible: isPasswordVisible,
                      updateVisibility: setPasswordVisibility,
                      hintText: 'Password',
                      labelText: 'Password',
                      controller: passwordController
                  ),
                  BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M, width: 0),
                  TextFields.getPasswordTextField(
                      isVisible: isRePasswordVisible,
                      updateVisibility: setRePasswordVisibility,
                      hintText: 'Retype your password',
                      labelText: 'Re-Password',
                      controller: rePasswordController
                  ),
                ],
              ),
              BoxesAndButtons.getSizedBox(height: (BoxesAndButtons.SPACE_X/2)),
              BoxesAndButtons.getFlatButton(text: PAGE_TITLE, onPresssed: createAccount),
              BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
              TextWidgets.getClickableText(onPress: createDoctorAccount, text: DOCTOR_ACCOUNT)
            ],
          ),
        ),
      ],
    );
  }
  //endregion
  void createDoctorAccount(){
    print('Doctor Pressed');
  }

  void createAccount(){
    print('Create Account Pressed');
  }

  //region Password Visibility Setters
  void setPasswordVisibility(){
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void setRePasswordVisibility(){
    setState(() {
      isRePasswordVisible = !isRePasswordVisible;
    });
  }
  //endregion



}

