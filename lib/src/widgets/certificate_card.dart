import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/classes/certificates.dart';
import 'package:flutter_healthcare_app/src/widgets/common_widgets.dart';
import 'package:flutter_healthcare_app/src/theme/text_styles.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';

class CertificateCard extends StatelessWidget {
  static final String CERT_NAME_HINT = 'Certification ';
  static final String CERT_PROVIDER_HINT = 'Organization';
  static final String UPLOAD_BOTTON = 'Upload Scan';
  static final bool IS_ENABLED = true;

  Certificates certificate;
  final Function onDeletePressed;
  final Function onUploadPressed;

  CertificateCard(
      {this.certificate, this.onDeletePressed, this.onUploadPressed});

  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Card(
      margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
      elevation: 6.0,
      color: Theme.of(context).backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFields.getTextField(
            hintText: CERT_NAME_HINT,
            labelText: CERT_NAME_HINT,
            prefixIcon: Icon(Icons.insert_drive_file),
            controller: certificate.certificateNameController,
            enabled: true,
            type: TextInputType.text,
          ),
          BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M / 2),
          TextFields.getTextField(
            hintText: CERT_PROVIDER_HINT,
            labelText: CERT_PROVIDER_HINT,
            prefixIcon: Icon(Icons.school),
            controller: certificate.organizationController,
            enabled: true,
            type: TextInputType.text,
          ),
          BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                    child: BoxesAndButtons.getButtonIcon(
                        icon: Icon(Icons.delete),
                        onPressed: onDeletePressed,
                        label: Text(''),
                        color: Theme.of(context).backgroundColor)),
              ),
              BoxesAndButtons.getSizedBox(width: BoxesAndButtons.SPACE_X),
              Expanded(
                flex: 2,
                child: Center(
                  child: BoxesAndButtons.getButtonIcon(
                      icon: Icon(Icons.upload_rounded),
                      onPressed: onUploadPressed,
                      label: TextWidgets.getText(
                          fontSize: FontSizes.body,
                          text: UPLOAD_BOTTON,
                          color: LightColor.lightblack),
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      color: Theme.of(context).backgroundColor),
                ),
              ),
            ],
          ),
          TextWidgets.getText(
              fontSize: FontSizes.bodySm,
              text: certificate.fileName,
              color: LightColor.lightblack)
        ],
      ),
    );
  }

  static Card getUnremovableCard(
      {EdgeInsets edgeInsets, double elevation, Color color, Column column}) {
    return Card(
      margin: edgeInsets,
      elevation: elevation,
      color: color,
      child: column,
    );
  }
}
