//region Imports
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/data_manager/ImagePicker.dart';
import 'package:flutter_healthcare_app/src/data_manager/media_storge.dart';
import 'package:flutter_healthcare_app/src/theme/extention.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_healthcare_app/src/config/route.dart';
import 'package:flutter_healthcare_app/src/data_manager/acuthentication.dart';
import 'package:flutter_healthcare_app/src/model/user_model.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';
import 'package:flutter_healthcare_app/src/widgets/common_widgets.dart';
import 'package:flutter_healthcare_app/src/theme/text_styles.dart';
import 'package:flutter_healthcare_app/src/widgets/dialogs.dart';
import 'package:flutter_healthcare_app/src/data_manager/DataManager.dart';
import 'package:csc_picker/csc_picker.dart';

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

  final _formKey = GlobalKey<FormState>();

  //endregion

  UsersImagePicker imagePcker = UsersImagePicker();
  MediaStorage storage;

  bool isPasswordVisible = false;
  bool isRePasswordVisible = false;

  int imageSource = -1;

  File profileImage;

  static final String PAGE_TITLE = 'Create Account';
  static final String DOCTOR_ACCOUNT = 'Create Doctor Account';

  static final ENABLE = true;

  String countryValue = null;
  String stateValue = null;
  String cityValue = null;

  UserModel user;
  Authentication auth = Authentication();
  DataManager dataManager = DataManager();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storage = MediaStorage();
    user = UserModel();
  }

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
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        color: LightColor.black,
        iconSize: 30,
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(Routes.LOGIN_PAGE);
        },
      ),
    );
  }

  Future showImagePickerSource() async {
    imageSource = -1;
    await Dialogs.showMyDialog(
      context: context,
      title: "Profile Picture",
      body: "How would you like to get the picture?",
      button1Lable: "Camera",
      button2Lable: "Gallery",
    ).then((value) {
      imageSource = value;
      print(value);
    });
  }

  void uploadProfileImage() async {
    showImagePickerSource().then((_) {
      if (imageSource > -1) {
        imagePcker.getImage(imageSource).then((file) {
          if (file == null)
            print("Null Value ");
          else {
            profileImage = file;
            setState(() {});
          }
        });
      }
    });
  }

  Widget getBody() {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                PAGE_TITLE,
                style: TextStyles.h1Style,
              ),
              BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(13)),
                child: Container(
                  height: 200,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                  ),
                  child: profileImage == null
                      ? Image.asset(
                          "assets/user.png",
                          fit: BoxFit.contain,
                        )
                      : Image.file(profileImage),
                ),
              ).ripple(() {
                uploadProfileImage();
              }),
              BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFields.getTextFormField(
                        type: TextInputType.text,
                        hintText: 'User Name',
                        labelText: 'User Name',
                        prefixIcon: Icon(Icons.person),
                        controller: userNameController,
                        enabled: ENABLE),
                    BoxesAndButtons.getSizedBox(
                        height: BoxesAndButtons.SPACE_M, width: 0),
                    TextFields.getTextFormField(
                        type: TextInputType.emailAddress,
                        hintText: "someone@domain.com",
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        controller: emailController,
                        enabled: ENABLE),
                    BoxesAndButtons.getSizedBox(
                        height: BoxesAndButtons.SPACE_M, width: 0),
                    TextFields.getPasswordTextField(
                        isVisible: isPasswordVisible,
                        updateVisibility: setPasswordVisibility,
                        hintText: 'Password',
                        labelText: 'Password',
                        controller: passwordController),
                    BoxesAndButtons.getSizedBox(
                        height: BoxesAndButtons.SPACE_M, width: 0),
                    TextFields.getPasswordTextField(
                        isVisible: isRePasswordVisible,
                        updateVisibility: setRePasswordVisibility,
                        hintText: 'Retype your password',
                        labelText: 'Re-Password',
                        controller: rePasswordController),
                  ],
                ),
              ),
              BoxesAndButtons.getSizedBox(
                  height: BoxesAndButtons.SPACE_M, width: 0),
              getCountriesPicker(),
              BoxesAndButtons.getSizedBox(
                  height: (BoxesAndButtons.SPACE_X / 2)),
              BoxesAndButtons.getFlatButton(
                  text: PAGE_TITLE, onPresssed: createAccountButtonAction),
              BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
              TextWidgets.getClickableText(
                  onPress: createDoctorAccountButtonAction,
                  text: DOCTOR_ACCOUNT)
            ],
          ),
        ),
      ],
    );
  }

  //endregion

  //region buttons actions
  void createDoctorAccountButtonAction() {
    Navigator.of(context).pushReplacementNamed(Routes.PERSONNAL_PAGE);
  }

  void createAccountButtonAction() {
    Dialogs.showLoadingDialog(show: () {
      EasyLoading.show();
    });
    if (!_formKey.currentState.validate()) return;
    checkPassword().then((value) {
      if (!value) return;
      checkCountryAndState().then((value) {
        if (!value) return;
        createUserAccount();
      });
    });
  }

  //endregion

  void createUserAccount() {
    //region user obj creation and initialization
    user = UserModel(
        name: userNameController.text,
        email: emailController.text,
        password: passwordController.text,
        country: countryValue,
        state: stateValue,
        city: cityValue);
    //endregion

    //region register the user in firebaseAuth
    auth
        .createAccount(
      email: user.email,
      password: user.password,
      context: context,
    )
        .then((value) {
      //endregion
      if (value != null) {
        user.fireBaseId = value.toString();
        //region sign in the user
        auth
            .signInWithEmailPassword(
                context: context, email: user.email, password: user.password)
            .then((value) {
          //endregion
          if (value) {
            //region set the user type whether User or Doctor
            auth
                .setUserType(userType: Authentication.USER, context: context)
                .then((value) async {
              //endregion

              //region send data to the application database
              String dir = user.fireBaseId + "/profileImage";

              user.image = profileImage == null
                  ? null
                  : await storage.upLoadImages(
                  context: context, dir: dir, image: profileImage);
              dataManager.openClientConnection();
              dataManager
                  .postData(
                      postBody: user.getObjJsonStr(),
                      url: DataManager.NEW_USER_URL)
                  .then((value) {
                if (!value) {
                  showErrorDialog(
                      message: "Error occurred while sending your data");
                  return;
                }
                Dialogs.dismissLoadingDialog(dismiss: () {
                  EasyLoading.dismiss();
                });
                Navigator.of(context).pushReplacementNamed(Routes.HOME_PAGE, arguments: user);
              });
              //endregion
            });
          }
        });
      }
    });
  }

  //region dialogs
  Future showErrorDialog({String message}) {
    Dialogs.showInfoDialog(
        dismiss: () {
          EasyLoading.dismiss();
        },
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
                text: message,
                fontSize: FontSizes.title,
                color: LightColor.black)
          ],
        ));
  }

  //endregion

  //region data checking
  Future checkPassword() async {
    if (passwordController.text != rePasswordController.text) {
      passwordController.clear();
      rePasswordController.clear();
      await showErrorDialog(message: "The two passwords must be identical");
      return false;
    }
    return true;
  }

  Future checkCountryAndState() async {
    print("in Check countryAndState ");
    if (countryValue == null || stateValue == null) {
      print("Country or state are empty");
      await showErrorDialog(message: "Missing city or state");
      return false;
    }
    return true;
  }

  Widget getCountriesPicker() {
    return Column(
      children: [
        CSCPicker(
          onCountryChanged: (value) {
            setState(() {
              countryValue = value;
            });
          },
          onStateChanged: (value) {
            setState(() {
              stateValue = value;
            });
          },
          onCityChanged: (value) {
            setState(() {
              cityValue = value;
            });
          },
        ),
      ],
    );
  }

  //endregion

  //region Password Visibility Setters
  void setPasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void setRePasswordVisibility() {
    setState(() {
      isRePasswordVisible = !isRePasswordVisible;
    });
  }
//endregion

}
