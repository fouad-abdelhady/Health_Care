import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/pages/create_account_page.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';
import 'package:flutter_healthcare_app/src/theme/text_styles.dart';
import 'package:flutter_healthcare_app/src/theme/extention.dart';
import 'package:flutter_healthcare_app/src/pages/login_page.dart';
import 'package:flutter_healthcare_app/src/pages/home_page.dart';
import 'package:flutter_healthcare_app/src/pages/doctors/registration/personnal_info.dart';
import 'package:flutter_healthcare_app/src/model/dactor_model.dart';
import 'package:flutter_healthcare_app/src/pages/doctors/registration/education_info.dart';
import 'package:flutter_healthcare_app/src/pages/doctors/registration/clinic_info.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
     Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Clinic()));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
                Image.asset("assets/heartbeat.png", color: Colors.white,height: 100,),
                Text(
                  "Dotor appointment zone",
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
}
