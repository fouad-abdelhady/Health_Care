import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';
import 'package:flutter_healthcare_app/src/theme/text_styles.dart';
import 'package:flutter_healthcare_app/src/widgets/common_widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class Dialogs {
  //region paddings values
  static const double LEFT_PADDING = 20;
  static const double RIGHT_PADDING = 20;
  static const double TOP_PADDING = 10;
  static const double BOTTOM_PADDING = 10;

  //endregion

  //region static values
  static const int BARS_OBICITY = 100;
  static const double ICONS_SIZE = 30;

  static const String PAGE_DESCRIPTION =
      "Place the marker on the clinic location";
  static const String CANCEL_BOTTON = "Cancel";
  static const String SAVE_BOTTON = "Save";
  static const String MARKER_ID = "Dragable Marker";
  static const String MARKER_INS =
      "Press and hold the marker to drag it to the clinic location";

  //endregion

  //region map variables
  static LatLng clinicLocation;

  static Set<Marker> markers = {};

  //endregion

  static Future<LatLng> showFullGoogleMapsDialog(
      //region params
      {BuildContext context,
      double animation1,
      double animation2,
      CameraPosition cameraPosition,
      LatLng latLng,
      bool viewOnly} //endregion
      ) {
    clinicLocation = latLng;
    return showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (context, animation1, animation2) {
          return Material(
            type: MaterialType.transparency,
            child: StatefulBuilder(builder: (context, setState) {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: MediaQuery.of(context).size.height - 50,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      GoogleMap(
                          onMapCreated: (googleMapController) {
                            setState(() {
                              if (!viewOnly)
                                markers.isEmpty
                                    ? addNewMarker(
                                        latLng: latLng, viewOnly: viewOnly)
                                    : print('');
                              else
                                addNewMarker(
                                    latLng: latLng, viewOnly: viewOnly);
                            });
                          },
                          markers: markers,
                          zoomControlsEnabled: false,
                          initialCameraPosition: cameraPosition),
                      viewOnly == true
                          ? BoxesAndButtons.getSizedBox(width: 0, height: 0)
                          : Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                      LEFT_PADDING,
                                      TOP_PADDING,
                                      RIGHT_PADDING,
                                      BOTTOM_PADDING),
                                  //TODO add the color to the Light colors class
                                  color: Colors.black87,
                                  child: TextWidgets.getText(
                                    color: LightColor.extraLightBlue,
                                    fontSize: FontSizes.bodySm,
                                    text: MARKER_INS,
                                  ),
                                ),
                              ),
                            ),
                      Positioned(
                          bottom: 0,
                          width: MediaQuery.of(context).size.width - 5,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(LEFT_PADDING,
                                TOP_PADDING, RIGHT_PADDING, BOTTOM_PADDING),
                            color: Colors.black87,
                            child: Row(
                              mainAxisAlignment: viewOnly == true
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        Navigator.of(context).pop(null);
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: LightColor.extraLightBlue,
                                      size: ICONS_SIZE,
                                    )),
                                viewOnly == true
                                    ? BoxesAndButtons.getSizedBox(
                                        width: 0, height: 0)
                                    : TextButton(
                                        onPressed: () {
                                          setState(() {
                                            Navigator.of(context)
                                                .pop(clinicLocation);
                                          });
                                        },
                                        child: Icon(
                                          Icons.add_location_alt,
                                          color: LightColor.extraLightBlue,
                                          size: ICONS_SIZE,
                                        )),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  static Future showMyDialog(
      {BuildContext context,
      String title,
      String body,
      String button1Lable,
      String button2Lable,
      Function dismiss}) async {
    //TODO add the dismiss function param to this function in education
    dismissLoadingDialog(dismiss: dismiss);
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(body),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(button1Lable),
              onPressed: () {
                Navigator.of(context).pop(0);
              },
            ),
            TextButton(
              child: Text(button2Lable),
              onPressed: () {
                Navigator.of(context).pop(1);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(-1);
              },
            ),
          ],
        );
      },
    );
  }

  static Future showInfoDialog(
      {BuildContext context,
      String title,
      Widget body,
      Function dismiss}) async {
    dismissLoadingDialog(dismiss: dismiss);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                body,
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  // ignore: missing_return
  static Future showErrorDialog({String message, BuildContext context}) {
    Dialogs.showInfoDialog(
        dismiss: () {
          EasyLoading.dismiss();
        },
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
                text: message,
                fontSize: FontSizes.title,
                color: LightColor.black)
          ],
        ));
  }

  static void showLoadingDialog({Function show}) {
    if (!EasyLoading.isShow) show();
  }

  static void dismissLoadingDialog({Function dismiss}) {
    if (EasyLoading.isShow) dismiss();
  }

  static Future<double> getRationDialog(BuildContext context, {String title}) {
    return showDialog<double>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        double rate = 0.5;
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RatingBar.builder(
                    itemCount: 5,
                    initialRating: 0.5,
                    minRating: 0,
                    itemSize: 30,
                    allowHalfRating: true,
                    direction: Axis.horizontal,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                    onRatingUpdate: (rating) {
                      rate = rating;
                    }),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(-1.0);
              },
            ),
            TextButton(
              child: Text('Rate'),
              onPressed: () {
                Navigator.of(context).pop(rate);
              },
            )
          ],
        );
      },
    );
  }

  static addNewMarker({LatLng latLng, bool viewOnly}) {
    markers.add(Marker(
        markerId: MarkerId(MARKER_ID),
        position: latLng,
        draggable: !viewOnly,
        icon: BitmapDescriptor.defaultMarker,
        onDragEnd: ((newPosition) {
          clinicLocation = newPosition;
        })));
  }
}
