import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  //endregion

  //region map variables
  static LatLng clinicLocation ;
  static Set<Marker> markers = {};
  //endregion

  static Future <LatLng> showFullGoogleMapsDialog(//region params
      {BuildContext context,
      double animation1,
      double animation2,
      CameraPosition cameraPosition,
      LatLng latLng}//endregion
      ) {
    clinicLocation = latLng;
    return showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (context, animation1, animation2) {
          return StatefulBuilder(builder: (context, setState) {
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
                            markers.isEmpty
                                ? addNewMarker(latLng: latLng)
                                : print('');
                          });
                        },
                        markers: markers,
                        zoomControlsEnabled: false,
                        initialCameraPosition: cameraPosition),
                    Positioned(
                        bottom: 0,
                        width: MediaQuery.of(context).size.width - 5,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(LEFT_PADDING,
                              TOP_PADDING, RIGHT_PADDING, BOTTOM_PADDING),
                          color: Colors.black87,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      Navigator.of(context).pop(clinicLocation);
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
          });
        });
  }

  static addNewMarker({LatLng latLng}) {
    markers.add(Marker(
        markerId: MarkerId(MARKER_ID),
        position: latLng,
        draggable: true,
        icon: BitmapDescriptor.defaultMarker,
        onDragEnd: ((newPosition) {
          clinicLocation = newPosition;
        })));
  }
}
