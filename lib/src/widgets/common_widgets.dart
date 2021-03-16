import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/classes/certificates.dart';
import 'package:flutter_healthcare_app/src/theme/text_styles.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';

class TextFields {
  static final double TEXT_FIELD_HEIGHT = 2.0;

  TextFields() {}

  //region Password fields
  static TextField getPasswordTextField({
    bool isVisible,
    Function updateVisibility,
    String hintText,
    String labelText,
    TextEditingController controller,
  }) {
    return TextField(
      keyboardType: TextInputType.text,
      style: getTextStyle(),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
          onPressed: updateVisibility,
        ),
        enabledBorder: getDecoration(),
        focusedBorder: getDecoration(),
      ),
      obscureText: !isVisible,
    );
  }

  //endregion

  //region text fields
  static TextField getTextField(
      {String hintText,
      String labelText,
      TextInputType type,
      TextEditingController controller,
      Icon prefixIcon,
      bool enabled,
      int maxLines,
      int maxLength}) {
    return TextField(
      style: getTextStyle(),
      keyboardType: type,
      maxLines: maxLines,
      maxLength: maxLength,
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        enabledBorder: getDecoration(),
        focusedBorder: getDecoration(),
      ),
    );
  }

  //endregion

  //region text fields styles
  static TextStyle getTextStyle() {
    return TextStyle(
        fontSize: FontSizes.body,
        height: TEXT_FIELD_HEIGHT,
        color: LightColor.black);
  }

  static OutlineInputBorder getDecoration() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: LightColor.purple, width: 1),
        borderRadius: BorderRadius.circular(10));
  }
//endregion
}

class BoxesAndButtons {
  static final double SPACE_X = 100.0;
  static final double SPACE_M = 20.0;

  static SizedBox getSizedBox({double width, double height}) {
    return SizedBox(
      width: width,
      height: height,
    );
  }

  static FlatButton getFlatButton({String text, void Function() onPresssed}) {
    return FlatButton(
      color: LightColor.purple,
      textColor: LightColor.black,
      minWidth: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Text(
          text,
          style: TextStyles.titleM,
        ),
      ),
      onPressed: onPresssed,
    );
  }
  static FlatButton getButtonIcon(
      {Icon icon, Text label, Function onPressed, EdgeInsets padding, Color color}) {
    return FlatButton.icon(
      onPressed: () => onPressed(),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(1.0),
      ),
      icon: icon,
      label: label,
      color: color,
      padding: padding,
    );
  }
  static IconButton getIconButton(
      {Icon icon,
      String tip,
      Function onpressed,
      double iconSize,
      Color color}) {
    return IconButton(
      icon: icon,
      tooltip: tip,
      onPressed: onpressed,
      color: color,
      iconSize: iconSize,
    );
  }
}

class TextWidgets {
  static Text getText({double fontSize, String text, Color color}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
      maxLines: 2,
    );
  }

  static Text getTitleText({String title}) {
    return Text(
      title,
      style: TextStyles.h1Style,
    );
  }

  static Text getSubTitleText({String title}) {
    return Text(
      title,
      style: TextStyles.title,
    );
  }

  static getClickableText({void Function() onPress, String text}) {
    return GestureDetector(
      onTap: onPress,
      child: TextWidgets.getText(
          fontSize: FontSizes.title, color: LightColor.purple, text: text),
    );
  }
}
