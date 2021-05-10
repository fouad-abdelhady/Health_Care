import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_healthcare_app/src/classes/system_users.dart';
import 'package:flutter_healthcare_app/src/classes/appointment.dart';
import 'package:flutter_healthcare_app/src/data_manager/DataManager.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';
import 'package:flutter_healthcare_app/src/model/dactor_model.dart';
import 'package:flutter_healthcare_app/src/pages/home_page.dart';
import 'package:flutter_healthcare_app/src/theme/text_styles.dart';
import 'package:flutter_healthcare_app/src/theme/theme.dart';
import 'package:flutter_healthcare_app/src/theme/extention.dart';
import 'package:flutter_healthcare_app/src/widgets/common_widgets.dart';
import 'package:flutter_healthcare_app/src/widgets/dialogs.dart';
import 'package:flutter_healthcare_app/src/widgets/progress_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_healthcare_app/src/data_manager/acuthentication.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final DoctorModel model;
  final SystemUsers currentUser;

  DetailPage({Key key, this.model, this.currentUser}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  static const String ADDRESS_LINE = "Address: ";
  static const String CONTACT_INFO_TITLE = "Contact Info";
  static const String CERTIFICATES_TITLE = "Certificates";

  static const double SAT = 0.0;
  static const double MED = (5 / 3);
  static const double EXC = MED * 2;

  static const int PATIENT_PER_HOUR = 4;
  static const int AVERAGE_TIME = 15;

  static bool COMPLETE_DATA = false;
  static bool CERTS_SHOWED = false;

  Appointments appointments;
  Authentication auth;
  DataManager dataManager;
  DoctorModel doctor;
  SystemUsers currentUser;

  Color checkedColor;

  Color uncheckedColor;
  TextStyle titleStyle;

  Icon loading = Icon(Icons.cloud_download, size: 50);
  Icon locationIcon = Icon(
    Icons.location_history,
    size: 35,
    color: Colors.deepPurple,
  );
  Icon mobileIcon = Icon(
    Icons.call,
    color: Colors.deepPurple,
    size: 25,
  );
  Icon emailIcon = Icon(
    Icons.email_outlined,
    color: Colors.deepPurple,
    size: 25,
  );

  String selectedDate;

  @override
  void initState() {
    doctor = widget.model;
    currentUser = HomePage.SYSTEM_USER;
    super.initState();
    checkedColor = LightColor.purple;
    uncheckedColor = LightColor.grey;
    dataManager = DataManager();
    auth = Authentication();
    appointments = Appointments();
    getDoctorsFullData();
  }

  Widget _appbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        BackButton(color: Theme.of(context).primaryColor),
        /* IconButton(
            icon: Icon(
              Icons.calendar_today,
              color: LightColor.grey,
              size: 35,
            ),
            onPressed: () {
              setState(() {

              });
            })*/
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    titleStyle = TextStyles.title.copyWith(fontSize: 25).bold;
    if (AppTheme.fullWidth(context) < 393) {
      titleStyle = TextStyles.title.copyWith(fontSize: 23).bold;
    }
    return Scaffold(
      backgroundColor: LightColor.extraLightBlue,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            getDoctorsProfileImage(),
            DraggableScrollableSheet(
              maxChildSize: .8,
              initialChildSize: .6,
              minChildSize: .6,
              builder: (context, scrollController) {
                return Container(
                  height: AppTheme.fullHeight(context) * .5,
                  padding: EdgeInsets.only(left: 19, right: 19, top: 16),
                  //symmetric(horizontal: 19, vertical: 16),
                  decoration: getSheetContainerDecoration(),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        getTitleSection(titleStyle),
                        getDivider(),
                        getRatesSection(),
                        getDivider(),
                        getAboutSection(titleStyle),
                        getDivider(),
                        COMPLETE_DATA == false
                            ? Center(
                                child: loading,
                              )
                            : getAllDoctorsData(),
                      ],
                    ),
                  ),
                );
              },
            ),
            _appbar(),
          ],
        ),
      ),
    );
  }

  Widget getDoctorsProfileImage() {
    return doctor.image == null
        ? Image.asset('assets/doctor.png')
        : Image.network(doctor.image);
  }

  BoxDecoration getSheetContainerDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      color: Colors.white,
    );
  }

  Widget getAllDoctorsData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getAppointmentSection(),
        getContactInfo(),
        getDivider(),
        getCertificatesSection(),
      ],
    );
  }

  //region appointment section
  Widget getAppointmentSection() {
    return BoxesAndButtons.getTextButtonIcon(
        icon: Icon(
          Icons.calendar_today,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          openDatePicker();
        },
        label: "Set Appointment");
  }

  Future openDatePicker() async {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final weekAfter = DateTime(now.year, now.month, now.day + 7);

    String formatedDate;
    bool isDayAvalable = false;

    DateTime date = await showDatePicker(
        context: context,
        initialDate: tomorrow,
        firstDate: tomorrow,
        lastDate: weekAfter);

    if (date == null) {
      return;
    }
    formatedDate = DateFormat('MM-dd-yyyy').format(date);
    selectedDate = formatedDate;
    await getDayAvaliableHours(formatedDate);
    isDayAvalable = checkAvaliableTimeSlots(appointments: appointments);

    getAndSaveTime();
  }

  void getAndSaveTime() {
    if (appointments == null) return;
    List<Widget> timeSlots = [];
    int index = 0;
    appointments.hours.forEach((patients) {
      if (patients < 4) {
        timeSlots.add(getTimeSlotTiel(
            time: index,
            patientsNum: patients,
            onPressed: (int index) {
              showConfirmation(index);
            }));
      }
      index++;
    });
    showTimeSlotsDialog(timeSlots);
  }

  Future showConfirmation(int index) async {
    print("the time ia $index");
    Navigator.of(context).pop(index);
    int result = await showConfirmationDialog(index);
    if (result == -1) return;
    Dialogs.showLoadingDialog(show: (){
        EasyLoading.show();
    });
    appointments.firebaseId = doctor.fireBaseID;
    bool state = await dataManager.postData(
        url: DataManager.UPDATE_HOURS_URL,
        postBody: appointments.getObjJsonStr());

    Dialogs.dismissLoadingDialog(dismiss: (){
      EasyLoading.dismiss();
    });
  }

  Future getDayAvaliableHours(String date) async {
    String fireBaseId = doctor.fireBaseID;
    await dataManager
        .getData(url: DataManager.getDayAppointment(date, fireBaseId))
        .then((value) {
      if (value == null) return null;
      Appointments appoint = Appointments.fromJson(value);
      appointments.hours = appoint.hours;
      appointments.date = appoint.date;
      return appoint;
    });
  }

  bool checkAvaliableTimeSlots({Appointments appointments}) {
    bool isSlotAvaliable = false;
    for (int i = 0; i < appointments.hours.length; i++)
      if (appointments.hours[i] < PATIENT_PER_HOUR) {
        isSlotAvaliable = true;
        break;
      }
    if (!isSlotAvaliable) {
      Dialogs.showInfoDialog(
          context: context,
          title: "Appointment",
          dismiss: () {},
          body: TextWidgets.getText(
              text: "The day " +
                  appointments.date +
                  " is full, please select another day",
              color: LightColor.black,
              fontSize: 25));
    }
  }

  Future showConfirmationDialog(int index) {
    int time = index + appointments.workStart;
    String doctorName = doctor.name;
    int waitingTime = appointments.hours[index] * AVERAGE_TIME;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Reservation Details",
            style: TextStyle(
              fontSize: FontSizes.title,
              color: Colors.deepPurple,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                BoxesAndButtons.getSizedBox(height: 10),
                Text(
                  "Dr. $doctorName",
                  style: TextStyle(
                    fontSize: FontSizes.body,
                    color: Colors.black,
                  ),
                ),
                BoxesAndButtons.getSizedBox(height: 5),
                Text(
                  "Date : $selectedDate",
                  style: TextStyle(
                    fontSize: FontSizes.body,
                    color: Colors.black,
                  ),
                ),
                BoxesAndButtons.getSizedBox(height: 5),
                Text(
                  "Time : $time : 00",
                  style: TextStyle(
                    fontSize: FontSizes.body,
                    color: Colors.black,
                  ),
                ),
                BoxesAndButtons.getSizedBox(height: 5),
                Text(
                  "$waitingTime minutes expected waiting time",
                  style: TextStyle(
                    fontSize: FontSizes.bodySm,
                    color: Colors.black45,
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(-1);
              },
            ),
            TextButton(
              child: Text('Confirm Appointment'),
              onPressed: () {
                appointments.hours[index] += 1;
                Navigator.of(context).pop(1);
              },
            )
          ],
        );
      },
    );
  }

  Future showTimeSlotsDialog(List<Widget> slots) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose time"),
          content: SingleChildScrollView(
            child: ListBody(
              children: slots,
            ),
          ),
          actions: <Widget>[
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

  Widget getTimeSlotTiel({int time, int patientsNum, Function onPressed}) {
    int actualTime = appointments.workStart + time;
    int averageWaiting = patientsNum * AVERAGE_TIME;
    //TextWidgets.getTitleText(title: "$actualTime O'Clock")
    return Card(
      child: ListTile(
        title: Text(
          "$actualTime : 00",
          style: TextStyle(
            fontSize: FontSizes.body,
            color: Colors.deepPurple,
          ),
        ),
        leading: Icon(Icons.access_time),
        subtitle: TextWidgets.getText(
            fontSize: FontSizes.bodySm,
            color: Colors.black45,
            text: "Average waiting time is $averageWaiting mints"),
        contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        // onTap: onPressed(time),
      ).ripple(() {
        onPressed(time);
      }),
    );
  }

  //endregion

  //region certificates Section
  Widget getCertificatesSection() {
    Icon certsButtonIcon = Icon(Icons.arrow_drop_down);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(CERTIFICATES_TITLE, style: titleStyle).vP16,
            BoxesAndButtons.getIconButton(
                icon: CERTS_SHOWED == true
                    ? Icon(Icons.arrow_drop_up)
                    : Icon(Icons.arrow_drop_down),
                color: LightColor.black,
                iconSize: 25,
                tip: "",
                onpressed: () {
                  CERTS_SHOWED = !CERTS_SHOWED;
                  setPageState();
                })
          ],
        ),
        CERTS_SHOWED == true
            ? getAllCertificates()
            : BoxesAndButtons.getSizedBox(height: 0),
      ],
    );
  }

  Widget getAllCertificates() {
    return Column(
      children: [
        getCertificate(imageUrl: doctor.universityCertificate),
        BoxesAndButtons.getSizedBox(height: 10),
        getAllCerts()
      ],
    );
  }

  Widget getAllCerts() {
    List<Widget> certs = [];
    try {
      certs = doctor.certificates
          .map((e) => getCertificate(imageUrl: e.certifcateUrl))
          .toList();
    } catch (e) {}
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: certs,
    );
  }

  Widget getCertificate({String imageUrl}) {
    imageUrl = imageUrl ?? "";
    return Image.network(imageUrl);
  }

  //endregion

  //region contact info
  Widget getContactInfo() {
    String city = doctor.address.city == null ? "" : doctor.address.city + ", ";
    String scc = city + doctor.address.state + ", " + doctor.address.country;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(CONTACT_INFO_TITLE, style: titleStyle).vP16,
        getRowWithIcon(mobileIcon, doctor.mobileNumber),
        getRowWithIcon(emailIcon, doctor.email),
        doctor.address.addressLine != null
            ? getRowForAddress(ADDRESS_LINE, doctor.address.addressLine)
            : BoxesAndButtons.getSizedBox(height: 0),
        Text(scc, style: TextStyles.body).vP16,
        doctor.address.longitude != 0
            ? getLocationButton()
            : BoxesAndButtons.getSizedBox(height: 0),
      ],
    );
  }

  Widget getLocationButton() {
    LatLng location = LatLng(doctor.address.latitude, doctor.address.longitude);
    return Center(
      child: BoxesAndButtons.getIconButton(
          icon: locationIcon,
          tip: "Google Maps Location",
          color: LightColor.black,
          iconSize: 50,
          onpressed: () {
            Dialogs.showFullGoogleMapsDialog(
                context: context,
                animation1: 10,
                animation2: 15,
                cameraPosition: CameraPosition(target: location, zoom: 14),
                latLng: location,
                viewOnly: true);
          }),
    );
  }

  Widget getRowForAddress(String title, String text) {
    return Row(
      children: [
        Text(title, style: TextStyles.boldBody).vP16,
        Text(text, style: TextStyles.body).vP16
      ],
    );
  }

  Widget getRowWithIcon(Icon icon, String text) {
    text = text ?? "";
    return Row(
      children: [
        icon,
        BoxesAndButtons.getSizedBox(width: 10),
        Text(text, style: TextStyles.body).vP16
      ],
    );
  }

  //endregion

  //region title section
  Widget getCheckedIcon() {
    return Icon(Icons.check_circle,
        size: 18,
        color: doctor.isVerified == true ? checkedColor : uncheckedColor);
  }

  Widget getTitleSection(TextStyle titleStyle) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            doctor.name,
            style: titleStyle,
          ),
          BoxesAndButtons.getSizedBox(
            width: 10,
          ),
          getCheckedIcon(),
          Spacer(),
          getRateSection(),
        ],
      ),
      subtitle: Text(
        doctor.specialization,
        style: TextStyles.bodySm.subTitleColor.bold,
      ),
    );
  }

  //endregion

  //region rate section
  Widget getRateSection() {
    double totalRates =
        doctor.rate.good + doctor.rate.medieum + doctor.rate.bad;
    totalRates = totalRates == 0 ? 1 : totalRates;
    double goodValue = (doctor.rate.good / totalRates) * 5;
    double mediumValue = (doctor.rate.medieum / totalRates) * 5;
    double satValue = (doctor.rate.bad / totalRates) * 5;
    double rate;
    rate = goodValue >= mediumValue ? goodValue : mediumValue;
    rate = rate > satValue ? rate : satValue;
    return RatingBarIndicator(
      rating: rate,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: 5,
      itemSize: 20.0,
    ).ripple(() {
      if (currentUser.job == Authentication.DOCTOR) return;
      checkIsDocRatedByCurrentUser().then((value) {
        if (value) return;
        Dialogs.getRationDialog(context, title: "Rate Dr. " + doctor.name)
            .then((value) {
          if (value < 0) return;
          if (value >= EXC)
            doctor.rate.good += 1;
          else if (value >= MED)
            doctor.rate.medieum += 1;
          else
            doctor.rate.bad += 1;
          addDoctorToUsersRatedList();
          updateDoctorDate();
        });
      });
    });
  }

  Future addDoctorToUsersRatedList() async {
    dataManager
        .getData(
            url: DataManager.getAddRatedDocUrl(
                userId: auth.getFireBaseAuthObj().currentUser.uid,
                doctorId: doctor.fireBaseID))
        .then((value) {
      if (value == null)
        Dialogs.showErrorDialog(
            message: "Error occurred while setting the rate", context: context);
      else {}
    });
  }

  Future updateDoctorDate() async {
    String json = doctor.getObjJsonStr();
    bool done = await dataManager.postData(
        postBody: json, url: DataManager.REPLACE_DOCTOR);
    if (!done) {
      print("Error while updating the doctors data");
      return done;
    }
    setPageState();
    return done;
  }

  Future checkIsDocRatedByCurrentUser() async {
    var response = await dataManager.getData(
        url: DataManager.getRatedDocUrl(
            uid: auth.getFireBaseAuthObj().currentUser.uid,
            docId: doctor.fireBaseID));
    if (response == null)
      return false;
    else
      return true;
  }

  Widget getRatesSection() {
    double totalRates =
        doctor.rate.good + doctor.rate.medieum + doctor.rate.bad;
    return Row(
      children: <Widget>[
        ProgressWidget(
            value: doctor.rate.good,
            totalValue: totalRates,
            activeColor: LightColor.purpleExtraLight,
            backgroundColor: LightColor.grey.withOpacity(.3),
            title: "Excellent",
            durationTime: 500),
        ProgressWidget(
            value: doctor.rate.medieum,
            totalValue: totalRates,
            activeColor: LightColor.purpleLight,
            backgroundColor: LightColor.grey.withOpacity(.3),
            title: "Good",
            durationTime: 300),
        ProgressWidget(
            value: doctor.rate.bad,
            totalValue: totalRates,
            activeColor: LightColor.purple,
            backgroundColor: LightColor.grey.withOpacity(.3),
            title: "Satisfaction",
            durationTime: 800),
      ],
    );
  }

  //endregion

  //region about section
  Widget getAboutSection(TextStyle titleStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("About", style: titleStyle).vP16,
        Text(
          doctor.about,
          style: TextStyles.body,
        )
      ],
    );
  }

  //endregion

  //region other
  Widget getCallWidget() {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: LightColor.grey.withAlpha(150)),
      child: Icon(
        Icons.call,
        color: Colors.white,
      ),
    ).ripple(
      () {},
      borderRadius: BorderRadius.circular(10),
    );
  }

  Future getDoctorsFullData() async {
    loading = Icon(Icons.cloud_download, size: 30);
    Map<String, dynamic> doctorMap = await dataManager.getData(
        url: DataManager.getDoctorDataUrl(firebaseID: doctor.fireBaseID));

    if (doctorMap == null) {
      loading = Icon(Icons.error_outline, size: 30, color: LightColor.red);
      COMPLETE_DATA = false;
      setPageState();
      return;
    }

    doctor = DoctorModel.fromJson(doctorMap);

    Map<String, dynamic> workingHours = await dataManager.getData(
        url: DataManager.getWorkingHoursUrl(doctor.fireBaseID));

    appointments.duration = workingHours["workDuration"];
    appointments.workStart = workingHours["workBeginningTime"];
    COMPLETE_DATA = true;
    setPageState();
  }

  void setPageState() {
    setState(() {});
  }

  Widget getDivider() {
    return Divider(
      thickness: .3,
      color: LightColor.grey,
    );
  }
//endregion
}
