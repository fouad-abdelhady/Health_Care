import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/widgets/common_widgets.dart';
import 'package:flutter_healthcare_app/src/model/dactor_model.dart';

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

  static final String PAGE_TITLE = 'Personal Info';
  static final String CONTINUE_BOTTON = 'Save and Continue';
  static final String FULL_NAME = 'Full Name';
  static final String EMAIL = 'EMAIL';
  static final String MOBLILE_NUMBER = 'Mobile Number';
  static final String DESCRIPTION = 'About You';
  static final String DESCRIPTION_HINT = 'Note that this will appear in the search results';

  final bool allEnabled = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: getBody(),
        ),
      ),
    );
  }

  Widget getBody() {
    return ListView(
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        children: [
          BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M *2),
          Center(child: TextWidgets.getTitleText(title: PAGE_TITLE)),
          BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_X / 2),
          Center(
            child: TextFields.getTextField(
              hintText: FULL_NAME,
              labelText: FULL_NAME,
              type: TextInputType.text,
              controller: nameController,
              prefixIcon: Icon(Icons.person),
              enabled: allEnabled
            ),
          ),
          BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
          Center(
            child: TextFields.getTextField(
                hintText: EMAIL,
                labelText: EMAIL,
                type: TextInputType.emailAddress,
                controller: emailController,
                prefixIcon: Icon(Icons.alternate_email_outlined),
                enabled: allEnabled
            ),
          ),
          BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
          Center(
            child: TextFields.getTextField(
                hintText: MOBLILE_NUMBER,
                labelText: MOBLILE_NUMBER,
                type: TextInputType.number,
                controller: mobileController,
                prefixIcon: Icon(Icons.phone),
                enabled: allEnabled
            ),
          ),
          BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
          Center(
            child: TextFields.getTextField(
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
          BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_X/2),
          Center(child: BoxesAndButtons.getFlatButton(text: CONTINUE_BOTTON, onPresssed: continueButtonPressed))
        ]);
  }

  void continueButtonPressed(){

  }
}
