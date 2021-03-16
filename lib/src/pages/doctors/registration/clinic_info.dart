//region imports
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter_healthcare_app/src/theme/text_styles.dart';
import 'package:flutter_healthcare_app/src/widgets/common_widgets.dart';
import 'package:flutter_healthcare_app/src/data_manager/DataManager.dart';
import 'package:flutter_healthcare_app/src/model/dactor_model.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';
import 'package:flutter_healthcare_app/src/widgets/dialogs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//endregion
class Clinic extends StatefulWidget {
  @override
  _CareerState createState() => _CareerState();
}

class _CareerState extends State<Clinic> {
  //region static final valuables
  static final String PAGE_TITLE = "Clinic Info";
  static final String SPECIALIZATION = "Specialization";
  static final String SPECIALIZATION_HINT = "Select your specialization";
  static final String SET_MAP_LOCTION = "Set map location";
  static final String KEY_WORDS_DESCRIPTION =
      "Write down sentences or words that describes your specialization(illness, body part etc...) separate by - ";
  static final String KEY_WORDS = "Keywords";
  static final String CREATE_ACCOUNT = "Create Profile";

  //endregion
  //region static variables
  static bool SPECIALIZATION_ENEABLED = false;
  static bool MAPS_CHECKED = false;

  //endregion
  //region properties
  String countryValue = "Egypt";
  String stateValue;
  String cityValue;
  TextEditingController keyWordsController;
  var dataManager;

  //endregion

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSpecilizations();
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

  //region widgets functions
  Widget getBody() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M * 2),
        Center(child: TextWidgets.getTitleText(title: PAGE_TITLE)),
        BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_X),
        getCountriesPicker(),
        BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
        getLocation(),
        BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
        getDoctorsSpecializations(),
        BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
        TextFields.getTextField(
          hintText: KEY_WORDS_DESCRIPTION,
          labelText: KEY_WORDS,
          type: TextInputType.multiline,
          controller: keyWordsController,
          prefixIcon: Icon(Icons.short_text),
          maxLines: 3,
          maxLength: 200,
          enabled: true,
        ),
        BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
        BoxesAndButtons.getFlatButton(
            text: CREATE_ACCOUNT, onPresssed: createProfile)
      ],
    );
  }

  Widget getCountriesPicker() {
    return Column(
      children: [
        CSCPicker(
          onCountryChanged: (value) {
            setState(() {
              countryValue = value;
            });
          },
          onStateChanged: (value) {
            setState(() {
              stateValue = value;
            });
          },
          onCityChanged: (value) {
            setState(() {
              cityValue = value;
            });
          },
        ),
      ],
    );
  }

  Widget getDoctorsSpecializations() {
    return Row(
      children: [
        SPECIALIZATION_ENEABLED
            ? BoxesAndButtons.getSizedBox(width: 0)
            : Expanded(
                flex: 1,
                child: Icon(Icons.hourglass_bottom),
              ),
        Expanded(
          flex: 5,
          child: DropdownSearch<String>(
            enabled: SPECIALIZATION_ENEABLED,
            mode: Mode.MENU,
            hint: SPECIALIZATION_HINT,
            showSelectedItem: true,
            items: List<String>.from(DoctorModel.SPECIALIZATION),
            label: SPECIALIZATION,
            showSearchBox: true,
            searchBoxDecoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ],
    );
  }

  Widget getLocation() {
    return CheckboxListTile(
      title:
          TextWidgets.getText(fontSize: FontSizes.body, text: SET_MAP_LOCTION),
      value: MAPS_CHECKED,
      secondary: Icon(
        Icons.location_on_outlined,
        color: LightColor.purple,
        size: 28,
      ),
      controlAffinity: ListTileControlAffinity.platform,
      onChanged: (value) {
        setState(() {
          MAPS_CHECKED = value;
          value
              ? Dialogs.showFullGoogleMapsDialog(
                      context: context,
                      animation1: 10,
                      animation2: 15,
                      cameraPosition: CameraPosition(
                          target: LatLng(11.004556, 76.961632), zoom: 14),
                      latLng: LatLng(11.004556, 76.961632))
                  .then((value) {
                  validateDialogResult(latLng: value);
                })
              : print('');
        });
      },
      activeColor: LightColor.purple,
    );
  }
  //endregion
  //region methods
  void getSpecilizations() {
    dataManager = DataManager();
    dataManager
        .getData(url: DoctorModel.DOCTORS_SPECIALIZATIONS_URL)
        .then((value) {
      setState(() {
        DoctorModel.SPECIALIZATION = value["specializations"];
        SPECIALIZATION_ENEABLED = true;
        print(DoctorModel.SPECIALIZATION.toString());
      });
    });
  }

  void validateDialogResult({LatLng latLng}) {
    if (latLng == null) {
      setState(() {
        MAPS_CHECKED = false;
      });
    } else {}
  }

  void createProfile() {}
  //endregion
}
