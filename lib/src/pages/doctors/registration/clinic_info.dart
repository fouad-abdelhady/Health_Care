//region imports
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_healthcare_app/src/classes/Rating.dart';
import 'package:flutter_healthcare_app/src/classes/address.dart';
import 'package:flutter_healthcare_app/src/config/permissionsManager.dart';
import 'package:flutter_healthcare_app/src/config/route.dart';
import 'package:flutter_healthcare_app/src/theme/text_styles.dart';
import 'package:flutter_healthcare_app/src/widgets/common_widgets.dart';
import 'package:flutter_healthcare_app/src/data_manager/DataManager.dart';
import 'package:flutter_healthcare_app/src/model/dactor_model.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';
import 'package:flutter_healthcare_app/src/widgets/dialogs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

//endregion
class Clinic extends StatefulWidget {
  DoctorModel doctor;

  Clinic({this.doctor});

  @override
  _CareerState createState() => _CareerState(doctor: doctor);
}

class _CareerState extends State<Clinic> {
  //region static final valuables
  static final String PAGE_TITLE = "Clinic Info";
  static final String SPECIALIZATION = "Specialization";
  static final String SPECIALIZATION_HINT = "Select your specialization";
  static final String SET_MAP_LOCTION = "Set map location";
  static final String KEY_WORDS_DESCRIPTION =
      "Write down sentences or words that describes your specialization(illness, body part etc...) separate by - ";
  static final String KEY_WORDS = "Search Keywords";
  static final String CREATE_ACCOUNT = "Create Profile";

  //endregion
  //region static variables
  static bool SPECIALIZATION_ENEABLED = false;
  static bool MAPS_CHECKED = false;
  static final String ADDRESSLINE_HINT_TEXT = "Address Line";

  final _formKey = GlobalKey<FormState>();

  //endregion
  //region properties
  DoctorModel doctor;
  PermissionsManager permissionsManager;
  String specialization;
  String countryValue;
  String stateValue;
  String cityValue;
  TextEditingController keyWordsController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  LatLng currentLocation;
  LatLng clinicLocation;

  DataManager dataManager;

  //endregion

  _CareerState({this.doctor});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    permissionsManager = PermissionsManager();
    getSpecilizations();
    // getCurrentLocation();
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
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFields.getTextFormField(
                hintText: ADDRESSLINE_HINT_TEXT,
                labelText: "Address",
                type: TextInputType.text,
                controller: addressController,
                enabled: true,
              ),
              BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
              getLocation(),
              BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
              getDoctorsSpecializations(),
              BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
              TextFields.getTextFormField(
                hintText: KEY_WORDS_DESCRIPTION,
                labelText: KEY_WORDS,
                type: TextInputType.multiline,
                controller: keyWordsController,
                prefixIcon: Icon(Icons.short_text),
                maxLines: 3,
                maxLength: 200,
                enabled: true,
              ),
            ],
          ),
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
            onChanged: (value) {
              specialization = value;
            },
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
      onChanged: (value) async {
        if (value == true) {
          await getCurrentLocation();
          dismissLoading();
        }
        setState(() {
          MAPS_CHECKED = value;
          value
              ? Dialogs.showFullGoogleMapsDialog(
                      context: context,
                      animation1: 10,
                      animation2: 15,
                      cameraPosition:
                          CameraPosition(target: currentLocation, zoom: 14),
                      latLng: currentLocation,
                          viewOnly: false)
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
  Future getCurrentLocation() async {
    showLoading();

    bool isLocationGranted = await permissionsManager
        .checkAndRequestPermission(PermissionsManager.LOCATION_PERMISSIONS);
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationGranted) {
      currentLocation = LatLng(11.004556, 76.961632);
    } else if (!serviceEnabled)
      currentLocation = LatLng(11.004556, 76.961632);
    else {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentLocation = LatLng(position.latitude, position.longitude);
    }
    print("Current Location ------- > " + currentLocation.toString());

    dismissLoading();
  }

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
    } else {
      clinicLocation = latLng;
    }
  }

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

  void createProfile() {
    if (!validate()) return;
    showLoading();
    completeDoctorObj();
    uploadData().then((value) {
      dismissLoading();
      if (value) {
        Navigator.of(context)
            .pushReplacementNamed(Routes.HOME_PAGE, arguments: doctor);
      } else {
        Dialogs.showErrorDialog(
            message:
                "Make sure that you have internet connection and try again ",
            context: context);
      }
    });
  }

//endregion

//region data validation
  bool validate() {
    if (!_formKey.currentState.validate()) return false;
    if (countryValue == null || stateValue == null) {
      Dialogs.showErrorDialog(
          message: "Select your country and state where your clinic located",
          context: context);
      return false;
    }
    if (specialization == null) {
      Dialogs.showErrorDialog(
          message: "Select specialization please", context: context);
      return false;
    }
    return true;
  }

  void completeDoctorObj() {
    Address address = Address();
    address.country = countryValue;
    address.state = stateValue;
    address.city = cityValue;
    address.addressLine = addressController.text;
    if (MAPS_CHECKED) {
      address.latitude = clinicLocation.latitude;
      address.longitude = clinicLocation.longitude;
    }

    doctor.address = Address();
    doctor.address = address;
    doctor.keywords = keyWordsController.text;
    doctor.isVerified = false;
    doctor.rate = Rating();
    doctor.specialization = specialization;
    doctor.accountStatus = "Created Successfully";
  }

  Future<bool> uploadData() async {
    String json = doctor.getObjJsonStr();
    print(json);
    bool done = await dataManager.postData(
        postBody: json, url: DataManager.REPLACE_DOCTOR);

    if (!done) {
      Dialogs.showErrorDialog(
          message:
              "Something went wrong while creating account, Please try again",
          context: context);
    }
    return done;
  }
//endregion
}
