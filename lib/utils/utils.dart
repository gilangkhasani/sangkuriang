import 'dart:math';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sangkuriang/model/users/users.dart';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

//confirmation
enum ConfirmAction { CANCEL, ACCEPT }

class Utils {

  UsersModel users;
  static SharedPreferences sharedPreferences;

  //routes
  static const String homeRoute = "/home";
  static const String profileOneRoute = "/View Profile";
  static const String profileTwoRoute = "/Profile 2";
  static const String notFoundRoute = "/No Search Result";
  static const String timelineOneRoute = "/Feed";
  static const String timelineTwoRoute = "/Tweets";
  static const String settingsOneRoute = "/Device Settings";
  static const String shoppingOneRoute = "/Shopping List";
  static const String shoppingTwoRoute = "/Shopping Details";
  static const String shoppingThreeRoute = "/Product Details";
  static const String paymentOneRoute = "/Credit Card";
  static const String paymentTwoRoute = "/Payment Success";
  static const String loginOneRoute = "/Login With OTP";
  static const String loginTwoRoute = "/Login 2";
  static const String dashboardOneRoute = "/Dashboard 1";
  static const String dashboardTwoRoute = "/Dashboard 2";

  //strings
  static const String appName = "Flutter UIKit";

  //fonts
  static const String quickFont = "Quicksand";
  static const String ralewayFont = "Raleway";
  static const String quickBoldFont = "Quicksand_Bold.otf";
  static const String quickNormalFont = "Quicksand_Book.otf";
  static const String quickLightFont = "Quicksand_Light.otf";

  //images
  static const String imageDir = "assets/images";
  static const String pkImage = "$imageDir/pk.jpg";
  static const String profileImage = "$imageDir/profile.jpg";
  static const String blankImage = "$imageDir/blank.jpg";
  static const String dashboardImage = "$imageDir/dashboard.jpg";
  static const String loginImage = "$imageDir/login.jpg";
  static const String paymentImage = "$imageDir/payment.jpg";
  static const String settingsImage = "$imageDir/setting.jpeg";
  static const String shoppingImage = "$imageDir/shopping.jpeg";
  static const String timelineImage = "$imageDir/timeline.jpeg";
  static const String verifyImage = "$imageDir/verification.jpg";

  //login
  static const String enter_code_label = "Phone Number";
  static const String enter_code_hint = "10 Digit Phone Number";
  static const String enter_otp_label = "OTP";
  static const String enter_otp_hint = "4 Digit OTP";
  static const String get_otp = "Get OTP";
  static const String resend_otp = "Resend OTP";
  static const String login = "Login";
  static const String enter_valid_number = "Enter 10 digit phone number";
  static const String enter_valid_otp = "Enter 4 digit otp";

  //gneric
  static const String error = "Error";
  static const String success = "Success";
  static const String ok = "OK";
  static const String forgot_password = "Forgot Password?";
  static const String something_went_wrong = "Something went wrong";
  static const String coming_soon = "Coming Soon";

  static const MaterialColor ui_kit_color = Colors.grey;

//colors
  static List<Color> kitGradients = [
    // new Color.fromRGBO(103, 218, 255, 1.0),
    // new Color.fromRGBO(3, 169, 244, 1.0),
    // new Color.fromRGBO(0, 122, 193, 1.0),
    Colors.blueGrey.shade800,
    Colors.black87,
  ];
  static List<Color> kitGradients2 = [
    Colors.cyan.shade600,
    Colors.blue.shade900
  ];

  //randomcolor
  static final Random _random = new Random();

  /// Returns a random color.
  static Color next() {
    return new Color(0xFF000000 + _random.nextInt(0x00FFFFFF));
  }

  static void openDialog(BuildContext context, AlertDialog dialog){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return dialog;
        }
    );
  }

  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context, AlertDialog dialog) async {
    return showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return dialog;
        }
    );
  }

  static Future<UsersModel> getPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String username = sharedPreferences.getString("username");
    int status = sharedPreferences.getInt("status");
    String fullname = sharedPreferences.getString("fullname");
    String id_nik = sharedPreferences.getString("id_nik");
    String cluster = sharedPreferences.getString("cluster");
    String foto = sharedPreferences.getString("foto");
    UsersModel users;
    users = new UsersModel(
      username: username,
      fullname: fullname,
      status: status,
      id_nik: id_nik,
      cluster_name: cluster,
      foto: foto,
    );
    return users;
  }

  static void showSnackBar(BuildContext context, String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    final snackBar = new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.pink,
      duration: Duration(seconds: 3),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static const String apiUrl = "https://itbsjabartsel.com/ticket_sangkuriang/";

  static checkConnection() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }

  static openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static openRoute(double latitude1, double longitude1, double latitude2,
      double longitude2) async {
    String googleUrl =
        'https://www.google.com/maps?saddr=$latitude1,$longitude1&daddr=$latitude2,$longitude2';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}