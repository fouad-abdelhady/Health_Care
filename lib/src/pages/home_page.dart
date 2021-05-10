import 'dart:math';
import 'package:flutter_healthcare_app/src/classes/appointment.dart';
import 'package:flutter_healthcare_app/src/widgets/dialogs.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/classes/system_users.dart';
import 'package:flutter_healthcare_app/src/data_manager/DataManager.dart';
import 'package:flutter_healthcare_app/src/model/dactor_model.dart';
import 'package:flutter_healthcare_app/src/model/user_model.dart';
import 'package:flutter_healthcare_app/src/widgets/common_widgets.dart';
import 'package:flutter_healthcare_app/src/theme/extention.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';
import 'package:flutter_healthcare_app/src/theme/text_styles.dart';
import 'package:flutter_healthcare_app/src/theme/theme.dart';
import 'package:flutter_healthcare_app/src/data_manager/acuthentication.dart';
import 'package:flutter_healthcare_app/src/config/route.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  static SystemUsers SYSTEM_USER;

  HomePage(SystemUsers user) {
    SYSTEM_USER = user;
    print("Home");
  }

  @override
  _HomePageState createState() => _HomePageState(SYSTEM_USER);
}

class _HomePageState extends State<HomePage> {
  List<DoctorModel> doctorDataList;
  static const String SHOW_MORE_OPTIONS = "Show More Options";
  static const String SHOW_LESS_OPTIONS = "Hide";
  static final String SPECIALIZATION = "Specialization";
  static final String SPECIALIZATION_HINT = "Select Specialization";
  static final String SET_SEARCH_ADDRESS = "Change search address";
  static final String CATIGORY_SECTION_TITLE = "Our doctors";
  static final String DOCTORS_LIST_TITLE = "Doctors in your location";
  String moreOptionsIconTip = SHOW_MORE_OPTIONS;
  String specialization;
  String countryValue;
  String stateValue;
  String cityValue;

  static int NEXT;
  static int PREV;
  static int SEARCH_RESULT = 0; // 0 loading, 1 result, result not found
  static bool SPECIALIZATION_ENEABLED = false;
  static bool NEW_ADDRESS_SEARCH = false;
  static bool UP_ARROW = true;
  bool isMoreSearchOptions = false;

  SystemUsers systemUser;
  DataManager dataManager;
  Authentication auth;
  Appointments appointments;
  DoctorModel doctor;

  Icon moreSearchOptionsIcon = Icon(Icons.arrow_drop_down);
  Icon loading = Icon(Icons.cloud_download, size: 30);
  Icon noResult = Icon(Icons.priority_high, size: 35);
  TextEditingController searchFieldController = TextEditingController();

  _HomePageState(this.systemUser);

  @override
  void initState() {
    appointments = Appointments();
    super.initState();
    dataManager = DataManager();
    setAddressValues();
    getSpecilizations();
    getDoctorsList(1);
    auth = Authentication();
  }

  void setAddressValues() async{
    if (systemUser is DoctorModel) {
      doctor = systemUser;
      countryValue = doctor.address.country;
      stateValue = doctor.address.state;
      cityValue = doctor.address.city;
      await getDoctorsWorkingHours();
    } else {
      UserModel user = systemUser;
      countryValue = user.country;
      stateValue = user.state;
      cityValue = user.city;
    }
  }

  Future getDoctorsWorkingHours() async {
    Map<String, dynamic> workingHours = await dataManager.getData(
        url: DataManager.getWorkingHoursUrl(doctor.fireBaseID));

    appointments.duration = workingHours["workDuration"];
    appointments.workStart = workingHours["workBeginningTime"];

  }

  //region main page elements
  Widget _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      leading: getIconButton(
          icon: Icon(Icons.logout),
          hint: "Logout",
          onPressed: logoutIconPressed),
      actions: <Widget>[
        systemUser.job == Authentication.DOCTOR
            ? Icon(
                Icons.calendar_today,
                size: 30,
                color: Colors.deepPurple[400],
              ).ripple(() {openDatePicker();}).vP16
            : BoxesAndButtons.getSizedBox(width: 0),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          child: Container(
            // height: 40,
            // width: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
            child: _getProfileImage(systemUser),
          ),
        ).p(8),
      ],
    );
  }

  Future openDatePicker() async {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final weekAfter = DateTime(now.year, now.month, now.day + 7);

    String formatedDate;

    DateTime date = await showDatePicker(
        context: context,
        initialDate: tomorrow,
        firstDate: tomorrow,
        lastDate: weekAfter);

    if (date == null) {
      return;
    }
    formatedDate = DateFormat('MM-dd-yyyy').format(date);
    await getDayAvaliableHours(formatedDate);
    getReservations();
  }

  void getReservations() {
    if (appointments == null) return;
    List<Widget> timeSlots = [];
    int index = 0;
    appointments.hours.forEach((patients) {
      timeSlots.add(getTimeSlotTiel(index: index, patientsNum: patients));

      index++;
    });
    showTimeSlotsDialog(timeSlots);
  }

  Future showTimeSlotsDialog(List<Widget> slots) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reservations"),
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

  Widget getTimeSlotTiel({int index, int patientsNum}) {
    int actualTime = appointments.workStart + index;
    int numberOfReservation = appointments.hours[index];
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
          color: numberOfReservation == 0? Colors.black45: LightColor.red,
          text: "There are $numberOfReservation reservations"),
      contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      // onTap: onPressed(time),
    ));
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

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Hello,", style: TextStyles.title.subTitleColor),
        Text(systemUser.name, style: TextStyles.h1Style),
      ],
    ).p16;
  }

  void changeCatigoryArrowDir() {
    setState(() {
      UP_ARROW = !UP_ARROW;
    });
  }

  Widget _category() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(CATIGORY_SECTION_TITLE, style: TextStyles.title.bold),
              UP_ARROW
                  ? BoxesAndButtons.getIconButton(
                      icon: Icon(
                        Icons.arrow_drop_up,
                        color: LightColor.black,
                      ),
                      iconSize: 25,
                      onpressed: () {
                        changeCatigoryArrowDir();
                      })
                  : BoxesAndButtons.getIconButton(
                      icon:
                          Icon(Icons.arrow_drop_down, color: LightColor.black),
                      iconSize: 25,
                      onpressed: () {
                        changeCatigoryArrowDir();
                      })
            ],
          ),
        ),
        UP_ARROW
            ? SizedBox(
                height: AppTheme.fullHeight(context) * .28,
                width: AppTheme.fullWidth(context),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    _categoryCard("Chemist & Drugist", "350 + Stores",
                        color: LightColor.green,
                        lightColor: LightColor.lightGreen),
                    _categoryCard("Covid - 19 Specilist", "899 Doctors",
                        color: LightColor.skyBlue,
                        lightColor: LightColor.lightBlue),
                    _categoryCard("Cardiologists Specilist", "500 + Doctors",
                        color: LightColor.orange,
                        lightColor: LightColor.lightOrange)
                  ],
                ),
              )
            : BoxesAndButtons.getSizedBox(height: 0),
      ],
    );
  }

  Widget _categoryCard(String title, String subtitle,
      {Color color, Color lightColor}) {
    TextStyle titleStyle = TextStyles.title.bold.white;
    TextStyle subtitleStyle = TextStyles.body.bold.white;
    if (AppTheme.fullWidth(context) < 392) {
      titleStyle = TextStyles.body.bold.white;
      subtitleStyle = TextStyles.bodySm.bold.white;
    }
    return AspectRatio(
      aspectRatio: 6 / 8,
      child: Container(
        height: 280,
        width: AppTheme.fullWidth(context) * .3,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 10,
              color: lightColor.withOpacity(.8),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -20,
                  left: -20,
                  child: CircleAvatar(
                    backgroundColor: lightColor,
                    radius: 60,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      child: Text(title, style: titleStyle).hP8,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      child: Text(
                        subtitle,
                        style: subtitleStyle,
                      ).hP8,
                    ),
                  ],
                ).p16
              ],
            ),
          ),
        ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  Widget _doctorsList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(DOCTORS_LIST_TITLE, style: TextStyles.title.bold),
              BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M)
              // .p(12).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(20))),
            ],
          ).hP16,
          getdoctorWidgetList(),
        ],
      ),
    );
  }

  //endregion

  // region search section
  Widget _searchField() {
    return Container(
      // height: 40,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(13)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: LightColor.lightblack.withOpacity(.3),
            blurRadius: 15,
            offset: Offset(5, 5),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFields.searchField(
              controller: searchFieldController,
              searchBottonPressed: searchBottonPressed),
          isMoreSearchOptions == true
              ? getMoreSearchOptions()
              : BoxesAndButtons.getSizedBox(height: 0),
          getIconButton(
              icon: moreSearchOptionsIcon,
              hint: moreOptionsIconTip,
              onPressed: changeMoreOptionsState),
        ],
      ),
    );
  }

  Widget getMoreSearchOptions() {
    return Column(
      children: [
        BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
        getDoctorsSpecializations(),
        BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
        getLocation(),
        NEW_ADDRESS_SEARCH == true
            ? getCountriesPicker()
            : BoxesAndButtons.getSizedBox(height: 0),
      ],
    );
  }

  Widget getLocation() {
    return CheckboxListTile(
      title: TextWidgets.getText(
          fontSize: FontSizes.body, text: SET_SEARCH_ADDRESS),
      value: NEW_ADDRESS_SEARCH,
      secondary: Icon(
        Icons.location_on_outlined,
        color: LightColor.purple,
        size: 28,
      ),
      controlAffinity: ListTileControlAffinity.platform,
      onChanged: (value) {
        setState(() {
          setAddressValues();
          NEW_ADDRESS_SEARCH = value;
          value == false ? setAddressValues() : print('');
        });
      },
      activeColor: LightColor.purple,
    );
  }

  Widget getCountriesPicker() {
    return Column(
      children: [
        CSCPicker(
          onCountryChanged: (value) {
            setState(() {
              countryValue = value;
              stateValue = null;
              cityValue = null;
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

  //endregion

  //region doctors view
  Widget getdoctorWidgetList() {
    return Column(children: getResult());
  }

  List<Widget> getResult() {
    List<Widget> doctorsWidget;
    if (SEARCH_RESULT == 0)
      doctorsWidget = [
        Center(
          child: loading,
        )
      ];
    else if (SEARCH_RESULT == 1)
      doctorsWidget =
          doctorDataList.map((model) => _doctorTile(model)).toList();
    else {
      doctorsWidget = [
        Center(
          child: noResult,
        )
      ];
    }
    return doctorsWidget;
  }

  Widget _doctorTile(DoctorModel model) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
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
      ),
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
                color: randomColor(),
              ),
              child: _getDoctorImage(model),
            ),
          ),
          title: Text("Dr. " + model.name, style: TextStyles.title.bold),
          subtitle: Text(
            _getSubTitle(model),
            style: TextStyles.bodySm.subTitleColor.bold,
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ).ripple(() {
        Navigator.of(context).pushNamed(Routes.DETAILS_PAGE, arguments: model);
      }, borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }

  _getDoctorImage(DoctorModel model) {
    return model.image == null
        ? Image.asset(
            'assets/doctor.png',
            height: 50,
            width: 50,
            fit: BoxFit.contain,
          )
        : Image.network(
            model.image,
            height: 50,
            width: 50,
            fit: BoxFit.contain,
          );
  }

  _getProfileImage(SystemUsers user) {
    user.image = user.image == "" ? null : user.image;
    return user.image == null
        ? Image.asset(
            'assets/user.png',
            height: 50,
            width: 50,
            fit: BoxFit.contain,
          )
        : Image.network(
            user.image,
            height: 50,
            width: 50,
            fit: BoxFit.contain,
          );
  }

  String _getSubTitle(DoctorModel model) =>
      model.specialization +
          ", " +
          model.address.state +
          ", " +
          model.address.city ??
      "";

  //endregion

  Color randomColor() {
    var random = Random();
    final colorList = [
      Theme.of(context).primaryColor,
      LightColor.orange,
      LightColor.green,
      LightColor.grey,
      LightColor.lightOrange,
      LightColor.skyBlue,
      LightColor.titleTextColor,
      Colors.red,
      Colors.brown,
      LightColor.purpleExtraLight,
      LightColor.skyBlue,
    ];
    var color = colorList[random.nextInt(colorList.length)];
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: _appBar(),
        backgroundColor: Theme.of(context).backgroundColor,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  _header(),
                  _searchField(),
                  _category(),
                ],
              ),
            ),
            _doctorsList(),
            _getNextPrevWidgets()
          ],
        ),
      ),
    );
  }

  Widget _getNextPrevWidgets() {
    int page = PREV == null ? 1 : PREV + 1;
    return SliverList(
      delegate: SliverChildListDelegate([
        BoxesAndButtons.getSizedBox(height: BoxesAndButtons.SPACE_M),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PREV == null
                ? BoxesAndButtons.getSizedBox(height: 0, width: 0)
                : BoxesAndButtons.getIconButton(
                    icon: Icon(
                      Icons.navigate_before_outlined,
                      color: LightColor.black,
                    ),
                    iconSize: 35,
                    onpressed: () {
                      getDoctorsList(PREV);
                    }),
            (NEXT == null && PREV == null)
                ? BoxesAndButtons.getSizedBox(height: 0, width: 0)
                : TextWidgets.getSubTitleText(title: page.toString()),
            NEXT == null
                ? BoxesAndButtons.getSizedBox(height: 0, width: 0)
                : BoxesAndButtons.getIconButton(
                    icon: Icon(
                      Icons.navigate_next_outlined,
                      color: LightColor.black,
                    ),
                    iconSize: 35,
                    onpressed: NEXT == null
                        ? null
                        : () {
                            getDoctorsList(NEXT);
                          }),
          ],
        )
      ]),
    );
  }

  //region remote data getters
  void getSpecilizations() async {
    if (DoctorModel.SPECIALIZATION.length != 0) {
      SPECIALIZATION_ENEABLED = true;
    } else {
      dataManager = DataManager();
      await dataManager
          .getData(url: DoctorModel.DOCTORS_SPECIALIZATIONS_URL)
          .then((value) {
        DoctorModel.SPECIALIZATION = value["specializations"];
        SPECIALIZATION_ENEABLED = true;
        print(DoctorModel.SPECIALIZATION.toString());
      });
    }
    setState(() {
      if (DoctorModel.SPECIALIZATION.first.toString() != "None") {
        DoctorModel.SPECIALIZATION.insert(0, "None");
      }
    });
  }

  void getDoctorsList(int page, {String searchStr}) async {
    setResultState(0); // loading

    if (stateValue == null) {
      setResultState(2); // result not found
      Dialogs.showErrorDialog(message: "Please Select City", context: context);
      return;
    }

    String url = DataManager.getDoctorsList(page,
        country: countryValue,
        state: stateValue,
        city: cityValue,
        searchText: searchStr);
    Map<String, dynamic> resultMap = await dataManager.getData(url: url);
    var doctorsListJson = resultMap['results'] as List;
    setPrevNext(resultMap);

    print("------------------------------------------>" +
        doctorsListJson.toString());
    if (doctorsListJson == null) {
      setResultState(2);
      return;
    }

    doctorDataList =
        doctorsListJson.map((doc) => DoctorModel.fromJson(doc)).toList();
    setResultState(1);
  }

  void setPrevNext(Map<String, dynamic> resultMap) {
    Map<String, dynamic> extraInfo = resultMap['next'];
    NEXT = extraInfo == null ? null : extraInfo['page'] as int;

    extraInfo = resultMap['previous'];
    PREV = extraInfo == null ? null : extraInfo['page'] as int;
  }

  void setResultState(int num) {
    SEARCH_RESULT = num;
    setState(() {});
  }

  //endregion

  //region event handelers
  void searchBottonPressed() {
    if (countryValue == null || stateValue == null) {
      Dialogs.showErrorDialog(
          message: "Please, make sure to set Country and State");
      return;
    }
    String searchText;
    if (searchFieldController.text != null && searchFieldController.text != "")
      searchText = searchFieldController.text;
    if (specialization != null && specialization != "None") {
      // ignore: unnecessary_statements
      searchText = searchText == null
          ? specialization
          : searchText + " " + specialization;
    }
    if (searchText == null)
      getDoctorsList(1);
    else
      getDoctorsList(1, searchStr: searchText);
  }

  void logoutIconPressed() {
    auth.signOutCurrentUser(context: context);
  }

  //endregion

  IconButton getIconButton({Icon icon, String hint, Function onPressed}) {
    return BoxesAndButtons.getIconButton(
        onpressed: onPressed,
        icon: icon,
        tip: hint,
        iconSize: 25,
        color: LightColor.black);
  }

  void changeMoreOptionsState() {
    isMoreSearchOptions = !isMoreSearchOptions;
    if (isMoreSearchOptions) {
      moreSearchOptionsIcon = Icon(Icons.arrow_drop_up);
      moreOptionsIconTip = SHOW_LESS_OPTIONS;
    } else {
      moreSearchOptionsIcon = Icon(Icons.arrow_drop_down);
      moreOptionsIconTip = SHOW_MORE_OPTIONS;
    }
    setState(() {});
  }
}
