import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/classes/certificates.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';
import 'package:flutter_healthcare_app/src/widgets/certificate_card.dart';
import 'package:flutter_healthcare_app/src/widgets/common_widgets.dart';
import 'package:flutter_healthcare_app/src/theme/text_styles.dart';

class Education extends StatefulWidget {
  @override
  EducationState createState() => EducationState();
}

class EducationState extends State<Education> {
  static final String PAGE_TITLE = 'Education';
  static final String ICON_BUTTON_TIP = 'Add new certificate';
  static final String UPLOAD_ID = 'ID or passport scan';
  static final String UPLOAD_UNIVERSITY_CERT = 'University Certificate';
  static final String SAVE_AND_CONTINUE = 'Save And Continue';

  static List<Certificates> certificates = [];

  String idDocumentName = '';

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

  ListView getBody() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M * 2),
        Center(child: TextWidgets.getTitleText(title: PAGE_TITLE)),
        BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_X / 2),
        getIdentitiyAndCertificate(),
        getCertificatesCards(),
        BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M / 2),
        BoxesAndButtons.getIconButton(
            icon: Icon(Icons.add_rounded),
            color: LightColor.black,
            iconSize: 30,
            tip: ICON_BUTTON_TIP,
            onpressed: () => {
                  addNewCertificate(),
                }),
        BoxesAndButtons.getSizedBox(height: (BoxesAndButtons.SPACE_X / 2)),
        BoxesAndButtons.getFlatButton(
            text: SAVE_AND_CONTINUE, onPresssed: saveAndContinue)
      ],
    );
  }

  /// Contains widgets which are responsible for getting
  /// user identity document and university certificate*/
  Column getIdentitiyAndCertificate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BoxesAndButtons.getButtonIcon(
                icon: Icon(Icons.upload_rounded),
                onPressed: () {
                  setState(() {
                    getIdentityDocument();
                  });
                },
                label: TextWidgets.getText(
                    fontSize: FontSizes.body,
                    text: UPLOAD_ID,
                    color: LightColor.lightblack),
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                color: Theme.of(context).backgroundColor),
            BoxesAndButtons.getIconButton(
                icon: Icon(Icons.info_outline),
                onpressed: () {
                  displayInfoPopup(message: 'Identity needed for ...');
                },
                tip: 'More Info',
                iconSize: 24.0,
                color: LightColor.black),
          ],
        ),
        TextWidgets.getText(
            fontSize: FontSizes.bodySm,
            text: idDocumentName,
            color: LightColor.lightblack),
        BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BoxesAndButtons.getButtonIcon(
                icon: Icon(Icons.upload_rounded),
                onPressed: () {
                  setState(() {
                    getUniversityCertificate();
                  });
                },
                label: TextWidgets.getText(
                    fontSize: FontSizes.body,
                    text: UPLOAD_UNIVERSITY_CERT,
                    color: LightColor.lightblack),
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                color: Theme.of(context).backgroundColor),
            BoxesAndButtons.getIconButton(
                icon: Icon(Icons.info_outline),
                onpressed: () {
                  displayInfoPopup(message: 'Certificate needed for ...');
                },
                tip: 'More Info',
                iconSize: 24.0,
                color: LightColor.black)
          ],
        ),
        TextWidgets.getText(
            fontSize: FontSizes.bodySm,
            text: idDocumentName,
            color: LightColor.lightblack),
        BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
      ],
    );
  }

  Column getCertificatesCards() {
    if (certificates.isEmpty) {
      return Column();
    }
    return Column(
      children: certificates
          .map((certificate) => CertificateCard(
                certificate: certificate,
                onDeletePressed: () {
                  setState(() {
                    deleteCertificate(certificate: certificate);
                  });
                },
                onUploadPressed: () {
                  setState(() {
                    uploadCertificate(certificate: certificate);
                  });
                },
              ))
          .toList(),
    );
  }

  //region Documents Loaders
  void getIdentityDocument() {}

  void getUniversityCertificate() {}

  void uploadCertificate({Certificates certificate}) {
    print('in new upload certificate');
  }

  //endregion

  void deleteCertificate({Certificates certificate}) {
    print('in new delete certificate');
    certificates.remove(certificate);
  }

  void addNewCertificate() {
    print('in new certificate');
    setState(() {
      certificates.add(Certificates(
          organization: '',
          certificateScan: '',
          certificateName: '',
          fileName: '',
          scannedFileName: ''));
    });
  }

  void displayInfoPopup({String message}) {}

  void saveAndContinue() {}
}
