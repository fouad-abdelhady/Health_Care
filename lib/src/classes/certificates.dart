import 'package:flutter/cupertino.dart';

class Certificates{
  String certificateName;
  String organization;
  String certificateScan;
  String scannedFileName;
  String fileName = '';

  TextEditingController certificateNameController;
  TextEditingController organizationController;



  Certificates({this.organization, this.certificateName, this.certificateScan, this.scannedFileName, this.fileName}){
    this.certificateNameController = new TextEditingController();
    this.organizationController = new TextEditingController();
  }

}