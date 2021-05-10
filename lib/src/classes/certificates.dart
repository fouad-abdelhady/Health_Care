import 'dart:io';

import 'package:flutter/cupertino.dart';

class Certificates {
  String certificateName;
  String organization;
  String certifcateUrl;
  File scannedFile;
  String fileName = '';

  Function getUpdes;
  Function validate;

  TextEditingController certificateNameController;
  TextEditingController organizationController;

  Certificates(
      {this.organization,
      this.certificateName,
      this.certifcateUrl,
      this.scannedFile,
      this.fileName}) {
    this.certificateNameController = new TextEditingController();
    this.organizationController = new TextEditingController();
  }

  factory Certificates.fromJson(dynamic jsonObj){
    print(jsonObj);
    return Certificates(
      certificateName:
      jsonObj["certificateName"] == null ? "" : jsonObj["certificateName"],
      organization: jsonObj["organization"]  == null? null : jsonObj["organization"],
      certifcateUrl: jsonObj["certUrl"] == null ? null : jsonObj["certUrl"],
      scannedFile: jsonObj["fileName"]  == null? null : jsonObj["fileName"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
    'certificateName': this.certificateName,
    'organization': this.organization,
    'certUrl': this.certifcateUrl,
  };}
}
