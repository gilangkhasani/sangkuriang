import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sangkuriang/model/users/users.dart';
import 'package:http/http.dart' as http;
import 'package:sangkuriang/utils/utils.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sangkuriang/widgets/themes.dart';

class LoginPage extends StatefulWidget {
  final Future<UsersModel> users;
  LoginPage({Key key, this.users}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;
  bool checkLogin = false;
  bool _isLoading = false;

  final FocusNode myFocusNodeUsernameLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  TextEditingController loginUsernameController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isLoading = false;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  void pressLogin() async {
    setState(() {
      _isLoading = true;
    });

    String username = loginUsernameController.text;
    String password = loginPasswordController.text;

    UsersModel users = new UsersModel(username: username, password: password);
    if (username.length != 0 || password.length != 0) {
      UsersModel u = await submitLogin(Utils.apiUrl + "auth/login",
          body: users.changeMapLogin());
    } else {
      setState(() {
        _isLoading = false;
      });
      showInSnackBar("Username or Password can't empty");
    }
  }

    Future<UsersModel> submitLogin(String url, {Map body}) async {
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;
      final result = jsonDecode(response.body);
      String msg = result['msg'];
      if (statusCode < 200 || statusCode > 400 || json == null) {
        showInSnackBar(msg);

        setState(() {
          _isLoading = false;
        });
        throw new Exception("Error Login");
      } else {
        setState(() {
          _isLoading = false;
        });
        UsersModel user = new UsersModel.fromJson(result['result']);
        showInSnackBar(msg);
        savePrefs(user);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => ThemesPage()));
      }
    });
  }

  savePrefs(UsersModel users) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkLogin = true;
      sharedPreferences.setBool("checkLogin", checkLogin);
      sharedPreferences.setString("username", users.username);
      sharedPreferences.setString("password", users.password);
      sharedPreferences.setInt("status", users.status);
      sharedPreferences.setString("id_nik", users.id_nik);
      sharedPreferences.setString("fullname", users.fullname);
      sharedPreferences.setString("foto", users.foto);
      sharedPreferences.setInt("id_mbp", users.id_mbp);
      sharedPreferences.setString("mbp_name", users.mbp_name);
      sharedPreferences.setInt("id_cluster", users.id_cluster);
      sharedPreferences.setString("cluster_name", users.cluster_name);
    });
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
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
    ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(key: _scaffoldKey, body: _buildLogin(context));
  }

  Widget _buildLogin(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Color(0xFFF5F5F5),
        radius: 90.0,
        child: Image.asset('assets/images/logo.png'),
      ),
    );

    final email = TextField(
      focusNode: myFocusNodeUsernameLogin,
      controller: loginUsernameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(myFocusNodePasswordLogin),
      style: TextStyle(
          fontFamily: "WorkSansSemiBold", fontSize: 16.0, color: Colors.black),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        hintText: "Username",
        hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
      ),
    );

    final password = TextField(
      focusNode: myFocusNodePasswordLogin,
      controller: loginPasswordController,
      obscureText: _obscureTextLogin,
      style: TextStyle(
          fontFamily: "WorkSansSemiBold", fontSize: 16.0, color: Colors.black),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        hintText: "Password",
        hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
        suffixIcon: GestureDetector(
          onTap: _toggleLogin,
          child: Icon(
            FontAwesomeIcons.eye,
            size: 15.0,
            color: Colors.black,
          ),
        ),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        borderRadius: BorderRadius.circular(15.0),
        shadowColor: Colors.blueAccent,
        child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            height: 42.0,
            color: Color(0xFF00BFA5),
            child: Text(
              'Log In',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => pressLogin()),
      ),
    );

    return  ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 45.0),
                      child: logo,
                    ),
                    SizedBox(height: 48.0),
                    email,
                    SizedBox(height: 8.0),
                    password,
                    SizedBox(height: 24.0),
                    loginButton,
                  ],
                ),
              )
            ],
          ),
          _showCircularProgress(),
        ],
      );
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }
}
