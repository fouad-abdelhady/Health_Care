import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_healthcare_app/src/config/route.dart';
import 'package:flutter_healthcare_app/src/data_manager/DataManager.dart';
import 'package:flutter_healthcare_app/src/data_manager/ImagePicker.dart';
import 'package:flutter_healthcare_app/src/data_manager/acuthentication.dart';
import 'package:flutter_healthcare_app/src/data_manager/media_storge.dart';
import 'package:flutter_healthcare_app/src/theme/extention.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';
import 'package:flutter_healthcare_app/src/theme/text_styles.dart';
import 'package:flutter_healthcare_app/src/widgets/common_widgets.dart';
import 'package:flutter_healthcare_app/src/model/dactor_model.dart';
import 'package:flutter_healthcare_app/src/widgets/dialogs.dart';

class PersonalInformation extends StatefulWidget {
  DoctorModel doctor;

  PersonalInformation({this.doctor});

  @override
  _PersonalInformationState createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  final nameController = new TextEditingController();
  final emailController = new TextEditingController();
  final mobileController = new TextEditingController();
  final descriptionController = new TextEditingController();
  final passwordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  static final String PAGE_TITLE = 'Personal Info';
  static final String CONTINUE_BOTTON = 'Continue';
  static final String FULL_NAME = 'Full Name';
  static final String EMAIL = 'EMAIL';
  static final String MOBLILE_NUMBER = 'Mobile Number';
  static final String DESCRIPTION = 'About You';
  static final String DESCRIPTION_HINT =
      'Note that this will appear in the search results';

  final bool allEnabled = true;

  bool isPasswordVisible = false;

  int imageSource = -1;

  MediaStorage storage = MediaStorage();
  Authentication auth = Authentication();
  DoctorModel doctor = DoctorModel();
  DataManager dataManager = DataManager();
  UsersImagePicker imagePcker = UsersImagePicker();

  File profileImage;

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

  Widget getAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        color: LightColor.black,
        iconSize: 30,
        onPressed: () {
          moveToLoginPage();
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
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        children: [
          BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M * 2),
          Center(child: TextWidgets.getTitleText(title: PAGE_TITLE)),
          BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
          Center(
            child:  ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(13)),
              child: Container(
                height: 200,
                width: 150,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                ),
                child: profileImage == null
                    ? Image.asset(
                  "assets/doctor.png",
                  fit: BoxFit.contain,
                )
                    : Image.file(profileImage),
              ),
            ).ripple(() {
              uploadProfileImage();
            }),
          ),
          BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: TextFields.getTextFormField(
                        hintText: FULL_NAME,
                        labelText: FULL_NAME,
                        type: TextInputType.text,
                        controller: nameController,
                        prefixIcon: Icon(Icons.person),
                        enabled: allEnabled),
                  ),
                  BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
                  Center(
                    child: TextFields.getTextFormField(
                        hintText: EMAIL,
                        labelText: EMAIL,
                        type: TextInputType.emailAddress,
                        controller: emailController,
                        prefixIcon: Icon(Icons.alternate_email_outlined),
                        enabled: allEnabled),
                  ),
                  BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
                  Center(
                    child: TextFields.getTextFormField(
                        hintText: MOBLILE_NUMBER,
                        labelText: MOBLILE_NUMBER,
                        type: TextInputType.phone,
                        controller: mobileController,
                        prefixIcon: Icon(Icons.phone),
                        enabled: allEnabled),
                  ),
                  BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
                  TextFields.getPasswordTextField(
                      isVisible: isPasswordVisible,
                      updateVisibility: setPasswordVisibility,
                      hintText: 'Password',
                      labelText: 'Password',
                      controller: passwordController),
                  BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
                  Center(
                    child: TextFields.getTextFormField(
                      hintText: DESCRIPTION_HINT,
                      labelText: DESCRIPTION,
                      type: TextInputType.multiline,
                      controller: descriptionController,
                      prefixIcon: Icon(Icons.short_text),
                      maxLines: 3,
                      maxLength: 200,
                      enabled: allEnabled,
                    ),
                  ),
                ],
              )),
          BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_X / 2),
          Center(
              child: BoxesAndButtons.getFlatButton(
                  text: CONTINUE_BOTTON, onPresssed: continueButtonPressed))
        ]);
  }

  void continueButtonPressed() async {

    if (!_formKey.currentState.validate()) {
      return;
    }
    Dialogs.showLoadingDialog(show: (){EasyLoading.show();});
    doctor.fireBaseID = await auth.createAccount(
        email: emailController.text, password: passwordController.text, context: context);
    if (doctor.fireBaseID != null) {
      formDoctorObj();
    }
    else {
      doctor = DoctorModel();
      return;
    }

    if (await auth.signInWithEmailPassword(
            email: doctor.email, password: doctor.password) ==
        false) {
      return;
    }

    String dir = doctor.fireBaseID + "/profileImage";
    doctor.image = profileImage == null
        ? null
        : await storage.upLoadImages(
        context: context, dir: dir, image: profileImage);

    doctor.accountStatus = Routes.EDUCATION_PAGE;

    dataManager
        .postData(
            postBody: jsonEncode(doctor.toJson()),
            url: DataManager.NEW_DOCTOR_URL)
        .then((value) {

      if (value){
        Navigator.of(context)
            .pushReplacementNamed(Routes.EDUCATION_PAGE, arguments: doctor);
        Dialogs.dismissLoadingDialog(dismiss: (){EasyLoading.dismiss();});
      }
      else
        showAlertError(context: context, messege: "Error Occurred, Please try again");
    });
  }

  formDoctorObj() {
    doctor.name = nameController.text;
    doctor.email = emailController.text;
    doctor.mobileNumber = mobileController.text;
    doctor.about = descriptionController.text;
    doctor.password = passwordController.text;
  }

  void moveToLoginPage() {
    Navigator.of(context).pushReplacementNamed(Routes.LOGIN_PAGE);
  }

  //region password viability controller
  void setPasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }
//endregion

//region dialogs
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
//endregion
}
