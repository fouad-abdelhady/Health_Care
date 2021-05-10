import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_healthcare_app/src/classes/certificates.dart';
import 'package:flutter_healthcare_app/src/config/route.dart';
import 'package:flutter_healthcare_app/src/data_manager/DataManager.dart';
import 'package:flutter_healthcare_app/src/data_manager/ImagePicker.dart';
import 'package:flutter_healthcare_app/src/data_manager/media_storge.dart';
import 'package:flutter_healthcare_app/src/model/dactor_model.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';
import 'package:flutter_healthcare_app/src/widgets/certificate_card.dart';
import 'package:flutter_healthcare_app/src/widgets/common_widgets.dart';
import 'package:flutter_healthcare_app/src/theme/text_styles.dart';
import 'package:flutter_healthcare_app/src/widgets/dialogs.dart';

class Education extends StatefulWidget {
  DoctorModel doctor;

  Education({this.doctor});

  @override
  EducationState createState() => EducationState(doctor: doctor);
}

class EducationState extends State<Education> {
  static final String PAGE_TITLE = 'Education';
  static final String ICON_BUTTON_TIP = 'Add new certificate';
  static String UPLOAD_ID = 'ID or passport scan';
  static String UPLOAD_UNIVERSITY_CERT = 'University Certificate';
  static final String SAVE_AND_CONTINUE = 'Save And Continue';
  static final String CHANGE_KEYWORD = 'Change ';

  static List<Certificates> certificates = [];

  DataManager dataManager;
  MediaStorage storage;
  DoctorModel doctor;
  File idDocument;
  File universityCertificate;

  String idDocumentName = '';
  String universityCertificateName = '';

  UsersImagePicker imagePcker = UsersImagePicker();
  int imageSource = -1;

  EducationState({this.doctor});

  @override
  void initState() {
    dataManager = DataManager();
    storage = MediaStorage();
    // TODO: implement initState
    print("doctor objec - ----------------------------");
    print(jsonEncode(doctor.toJson()));
    super.initState();
  }

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
            text: universityCertificateName,
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
                  //  setState(() {
                  uploadCertificate(certificate: certificate);
                  //  });
                },
              ))
          .toList(),
    );
  }

  //region Documents Loaders --------------------------------------------
  void getIdentityDocument() {
    showImagePickerSource().then((_) {
      if (imageSource > -1) {
        imagePcker.getImage(imageSource).then((file) {
          if (file == null)
            idDocument = file;
          else {
            idDocumentName = file.path.split('/').last;
            idDocument = file;
            setState(() {});
          }
        });
      }
    });
  }

  void getUniversityCertificate() {
    showImagePickerSource().then((_) {
      if (imageSource > -1) {
        imagePcker.getImage(imageSource).then((file) {
          if (file == null)
            universityCertificate = file;
          else {
            universityCertificateName = file.path.split('/').last;
            universityCertificate = file;
            setState(() {});
          }
        });
      }
    });
  }

  void uploadCertificate({Certificates certificate}) async {
    print('in new upload certificate');
    showImagePickerSource().then((_) {
      if (imageSource > -1) {
        imagePcker.getImage(imageSource).then((file) {
          if (file == null)
            print("Null Value ");
          else {
            certificate.fileName = file.path.split('/').last;
            certificate.scannedFile = file;
            certificate.getUpdes();
          }
        });
      }
    });
  }

  //endregion

  //region certifices list management
  void deleteCertificate({Certificates certificate}) {
    print('in new delete certificate');
    certificates.remove(certificate);
  }

  void addNewCertificate() {
    print('in new certificate');
    setState(() {
      certificates.add(Certificates(
          organization: '',
          scannedFile: null,
          certificateName: '',
          fileName: '',
          certifcateUrl: ''));
    });
  }

//endregion

  //region dialogs manager
  void displayInfoPopup({String message}) {}

  void showLoading() {
    Dialogs.showLoadingDialog(show: () {
      EasyLoading.show();
    });
  }

  void dismissLoading() {
    Dialogs.dismissLoadingDialog(dismiss: () {
      EasyLoading.dismiss();
    });
  }

  Future showImagePickerSource() async {
    imageSource = -1;
    await Dialogs.showMyDialog(
      context: context,
      title: "Document Scan",
      body: "How would you like to get the scan?",
      button1Lable: "Camera",
      button2Lable: "Gallery",
    ).then((value) {
      imageSource = value;
      print(value);
    });
  }

  //endregion

  //region data validation

  bool validate() {
    bool isRequiredDocs = checkReqiredDocs();
    bool isCertificates = checkCertificates();
    if (isRequiredDocs == true && isCertificates == true) return true;
    return false;
  }

  bool checkReqiredDocs() {
    if (idDocument == null) {
      Dialogs.showErrorDialog(
          message:
              "ID or Passport scan required to verify your data integrity ",
          context: context);
      return false;
    }
    if (universityCertificate == null) {
      Dialogs.showErrorDialog(
          message:
              "University certificate required to verify your data integrity ",
          context: context);
      return false;
    }
    return true;
  }

  bool checkCertificates() {
    bool result = true;
    certificates.forEach((cert) {
      print("<<<<<<<<<<<<<<<<<<<<<< in certificates list");
      if (cert.certificateNameController.text == null ||
          cert.certificateNameController.text.isEmpty) {
        Dialogs.showErrorDialog(
            message: "Make sure that you fill the certificates section fields",
            context: context);

        print("<<<<<<<<<<<<<<<<<<<<<< in certificates list");
        result = false;
        return result;
      }

      if (cert.organizationController.text == null ||
          cert.organizationController.text.isEmpty) {
        Dialogs.showErrorDialog(
            message: "Make sure that you fill the certificates section fields",
            context: context);
        result = false;
        return result;
      }

      if (cert.scannedFile == null) {
        Dialogs.showErrorDialog(
            message: "A scan required for " + cert.certificateName,
            context: context);
        result = false;
        return result;
      }
    });
    return result;
  }

  //endregion

  //region upload section
  Future uploadData() async {
    bool requiredDocsUploaded = await uploadRequiredDocs();
    bool certificatesUploaded = await uploadCertificates();

    if (!requiredDocsUploaded || !certificatesUploaded) return false;

    doctor.accountStatus = Routes.CLINIC_PAGE;

    String json = doctor.getObjJsonStr();
    print(json);
    bool done = await dataManager.postData(
        postBody: json, url: DataManager.REPLACE_DOCTOR);

    if (!done) {
      Dialogs.showErrorDialog(
          message:
              "Something went wrong while saving your data, Please try again",
          context: context);
      return false;
    }
    return true;
  }



  Future uploadRequiredDocs() async {
    String idFileDir = doctor.fireBaseID + "/idScan";
    doctor.identitiyDocument =
        await storage.upLoadImages(dir: idFileDir, image: idDocument);
    if (doctor.identitiyDocument == null) return false;

    String UniversityDir = doctor.fireBaseID + "/universityCertScan";
    doctor.universityCertificate = await storage.upLoadImages(
        dir: UniversityDir, image: universityCertificate, context: context);
    if (doctor.universityCertificate == null) return false;

    //await uploadCertificates().then((value) => value);

    return true;
  }

  Future uploadCertificates() async {
    int counter = 0;
    String certificatesDir = doctor.fireBaseID + "/certificates/cert_";
    bool allRight = true;

    for (Certificates cert in certificates) {

      cert.certificateName = cert.certificateNameController.text;
      cert.organization = cert.organizationController.text;
      cert.certifcateUrl = await storage.upLoadImages(
          dir: certificatesDir + counter.toString(),
          image: cert.scannedFile,
          context: context);

      if (cert.certifcateUrl == null || cert.certifcateUrl.isEmpty) {
        allRight = false;
      }

      counter++;
    }
    doctor.certificates = certificates;
    return allRight;
  }
  //endregion

  void saveAndContinue() async {
    showLoading();
    if (validate() == false) return;

    if (await uploadData() == true) {
      dismissLoading();
      Navigator.of(context)
          .pushReplacementNamed(Routes.CLINIC_PAGE, arguments: doctor);
    }
    dismissLoading();
  }
}
