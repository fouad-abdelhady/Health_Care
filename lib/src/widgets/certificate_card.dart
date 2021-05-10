import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/classes/certificates.dart';
import 'package:flutter_healthcare_app/src/widgets/common_widgets.dart';
import 'package:flutter_healthcare_app/src/theme/text_styles.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';

class CertificateCard extends StatefulWidget {
  static final String CERT_NAME_HINT = 'Certification ';
  static final String CERT_PROVIDER_HINT = 'Organization';
  static final String UPLOAD_BOTTON = 'Upload Scan';
  static final bool IS_ENABLED = true;

  Certificates certificate;
  final Function onDeletePressed;
  final Function onUploadPressed;

  CertificateCard(
      {this.certificate, this.onDeletePressed, this.onUploadPressed});

  @override
  _CertificateCardState createState() => _CertificateCardState();

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

class _CertificateCardState extends State<CertificateCard> {
  BuildContext context;

  @override
  void initState() {
    // TODO: implement initState
    widget.certificate.getUpdes = () {
      setThisState();
    };

    super.initState();
  }

  void setThisState() {
    setState(() {});
  }

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
            hintText: CertificateCard.CERT_NAME_HINT,
            labelText: CertificateCard.CERT_NAME_HINT,
            prefixIcon: Icon(Icons.insert_drive_file),
            controller: widget.certificate.certificateNameController,
            enabled: true,
            type: TextInputType.text,
          ),
          BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M / 2),
          TextFields.getTextField(
            hintText: CertificateCard.CERT_PROVIDER_HINT,
            labelText: CertificateCard.CERT_PROVIDER_HINT,
            prefixIcon: Icon(Icons.school),
            controller: widget.certificate.organizationController,
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
                        onPressed: widget.onDeletePressed,
                        label: Text(''),
                        color: Theme.of(context).backgroundColor)),
              ),
              BoxesAndButtons.getSizedBox(width: BoxesAndButtons.SPACE_X),
              Expanded(
                flex: 2,
                child: Center(
                  child: BoxesAndButtons.getButtonIcon(
                      icon: Icon(Icons.upload_rounded),
                      onPressed: widget.onUploadPressed,
                      label: TextWidgets.getText(
                          fontSize: FontSizes.body,
                          text: CertificateCard.UPLOAD_BOTTON,
                          color: LightColor.lightblack),
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      color: Theme.of(context).backgroundColor),
                ),
              ),
            ],
          ),
          TextWidgets.getText(
              fontSize: FontSizes.bodySm,
              text: widget.certificate.fileName,
              color: LightColor.lightblack)
        ],
      ),
    );
  }
}
