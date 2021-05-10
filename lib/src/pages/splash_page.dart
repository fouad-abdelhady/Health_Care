import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/classes/system_users.dart';
import 'package:flutter_healthcare_app/src/config/route.dart';
import 'package:flutter_healthcare_app/src/model/dactor_model.dart';
import 'package:flutter_healthcare_app/src/model/user_model.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';
import 'package:flutter_healthcare_app/src/theme/text_styles.dart';
import 'package:flutter_healthcare_app/src/theme/extention.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_healthcare_app/src/data_manager/acuthentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_healthcare_app/src/data_manager/DataManager.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const String CREATED = "Created Successfully";
  DataManager dataManager = DataManager();
  BuildContext context;
  Authentication authentication = Authentication();
  FirebaseAuth auth;

  @override
  void initState() {
    initializeFireBaseApp().then((value) {
      if (value) navigate();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/doctor_face.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: .6,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [LightColor.purpleExtraLight, LightColor.purple],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      tileMode: TileMode.mirror,
                      stops: [.5, 6]),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 20,
                child: SizedBox(),
              ),
              Image.asset(
                "assets/heartbeat.png",
                color: Colors.white,
                height: 100,
              ),
              Text(
                "Doctor appointment zone",
                style: TextStyles.h1Style.white.bold,
              ),
              Text(
                "By Egyption Care",
                style: TextStyles.bodySm.white.bold,
              ),
              Expanded(
                flex: 20,
                child: SizedBox(),
              ),
            ],
          ).alignTopCenter,
        ],
      ),
    );
  }

  Future initializeFireBaseApp() async {
    try {
      await Firebase.initializeApp();
      Future.delayed(Duration(seconds: 2));
      return true;
    } catch (e) {
      //TODO alert with error message
      print("errrrrrrrrrrrrrrrrror" + e.toString());
      return false;
    }
  }

  void navigate() async {
    auth = authentication.getFireBaseAuthObj();
    //await authentication.signOutCurrentUser(context: context);
    if (auth.currentUser == null) {
      Navigator.of(context).pushReplacementNamed(Routes.LOGIN_PAGE);
    } else {
      if (authentication.checkAccountCompletion(context: context)) {
        dataManager
            .getData(
                url: DataManager.getUserDataUrl(
                    firebaseId: auth.currentUser.uid))
            .then((value) {
              if(value == null){
                authentication.signOutCurrentUser(context: context);
                Navigator.of(context).pushReplacementNamed(Routes.LOGIN_PAGE);
                return;
              }
              SystemUsers user = UserModel();
              user = UserModel.fromJson(value);
              Navigator.of(context).pushReplacementNamed(Routes.HOME_PAGE, arguments: user);
        });

      } else
        moveToCompleteAccountRegistration(userId: auth.currentUser.uid);
    }
  }

  void moveToCompleteAccountRegistration({String userId}) async {
    Map<String, dynamic> doctorMap = await dataManager.getData(
        url: DataManager.getDoctorDataUrl(firebaseID: userId));
    if (doctorMap == null) return;
    print(doctorMap);
    DoctorModel doctor = DoctorModel.fromJson(doctorMap);

    if (doctor.accountStatus == Routes.EDUCATION_PAGE)
      Navigator.of(context)
          .pushReplacementNamed(Routes.EDUCATION_PAGE, arguments: doctor);
    else if (doctor.accountStatus == Routes.CLINIC_PAGE)
      Navigator.of(context)
          .pushReplacementNamed(Routes.CLINIC_PAGE, arguments: doctor);
    else if (doctor.accountStatus == CREATED)
      Navigator.of(context)
          .pushReplacementNamed(Routes.HOME_PAGE, arguments: doctor);
    else {
      await authentication.signOutCurrentUser(context: context);
      //TODO show error dialog
    }
  }


  Future deleteUser({String userId}) async {
    await dataManager
        .getData(url: DataManager.getTempUserDeleteUrl(firebaseID: userId))
        .then((value) {
      if (value == null)
        return false;
      else
        return true;
    });
  }
}
