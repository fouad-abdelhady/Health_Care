import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/pages/detail_page.dart';
import 'package:flutter_healthcare_app/src/pages/home_page.dart';
import 'package:flutter_healthcare_app/src/pages/splash_page.dart';
import 'package:flutter_healthcare_app/src/pages/doctors/registration/clinic_info.dart';
import 'package:flutter_healthcare_app/src/pages/doctors/registration/education_info.dart';
import 'package:flutter_healthcare_app/src/pages/doctors/registration/personnal_info.dart';
import 'package:flutter_healthcare_app/src/pages/create_account_page.dart';
import 'package:flutter_healthcare_app/src/pages/login_page.dart';
import 'package:flutter_healthcare_app/src/pages/user_profile.dart';
import 'package:flutter_healthcare_app/src/classes/system_users.dart';
import 'package:flutter_healthcare_app/src/model/dactor_model.dart';

class Routes {
  static const String SPLASH_PAGE = '/';
  static const String CREATE_ACCOUNT_PAGE = '/createAccount';
  static const String DETAILS_PAGE = '/details';
  static const String HOME_PAGE = '/home';
  static const String LOGIN_PAGE = '/login';
  static const String USER_PAGE = '/user';
  static const String CLINIC_PAGE = '/clinicInfo';
  static const String EDUCATION_PAGE = '/educationInfo';
  static const String PERSONNAL_PAGE = '/personnalInfo';

  static Route<dynamic> onGenerateRoute(RouteSettings settings){
    Object args = settings.arguments;

    switch(settings.name){
      case SPLASH_PAGE:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case CREATE_ACCOUNT_PAGE:
        return MaterialPageRoute(builder: (_) => CreateAccount());
      case DETAILS_PAGE:
        return MaterialPageRoute(builder: (_) => DetailPage(model: args));
      case HOME_PAGE:
        return MaterialPageRoute(builder: (_) => HomePage(args));
      case LOGIN_PAGE:
        return MaterialPageRoute(builder: (_) => Login());
      case USER_PAGE:
        return MaterialPageRoute(builder: (_) => UserProfile());
      case CLINIC_PAGE:
          return MaterialPageRoute(builder: (_) => Clinic(doctor: args));
      case EDUCATION_PAGE:
        return MaterialPageRoute(builder: (_) => Education(doctor: args));
      case PERSONNAL_PAGE:
        return MaterialPageRoute(builder: (_) => PersonalInformation());
    }
  }

}
