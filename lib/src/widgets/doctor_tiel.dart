import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/model/dactor_model.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';
import 'package:flutter_healthcare_app/src/theme/text_styles.dart';
import 'package:flutter_healthcare_app/src/theme/extention.dart';

class DoctorTiel extends StatelessWidget {
  DoctorModel model;

  DoctorTiel({this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: _getDecoration(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                //color: randomColor(),
              ),
              child: _getProfileImage(),
            ),
          ),
          title: Text(model.name, style: TextStyles.title.bold),
          subtitle: Text(
          _getSubTitle(),
          style: TextStyles.bodySm.subTitleColor.bold,
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 30,
            color: Theme
                .of(context)
                .primaryColor,
          ),
        ),
      ).ripple(() {
        //Navigator.pushNamed(context, "/DetailPage", arguments: model);
      }, borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }

  _getDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          offset: Offset(4, 4),
          blurRadius: 10,
          color: LightColor.grey.withOpacity(.2),
        ),
        BoxShadow(
          offset: Offset(-3, 0),
          blurRadius: 15,
          color: LightColor.grey.withOpacity(.1),
        )
      ],
    );
  }

  _getProfileImage() {
    return model.image == null ? Image.asset(
      model.image,
      height: 50,
      width: 50,
      fit: BoxFit.contain,
    ) : Image.network(
      model.image,
      height: 50,
      width: 50,
      fit: BoxFit.contain,
    );
  }

  String _getSubTitle() =>
      model.specialization + ", " + model.address.state + ", " +
          model.address.city ?? "";
}
