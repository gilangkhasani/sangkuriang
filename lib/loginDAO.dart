import 'package:shared_preferences/shared_preferences.dart';
class LoginDao{

  static final LoginDao _instance = LoginDao._internal();

  LoginDao._internal();

  factory LoginDao(){
    return _instance;
  }

  void getUsername() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

  }
}