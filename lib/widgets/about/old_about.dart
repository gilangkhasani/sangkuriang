import 'package:flutter/material.dart';
import 'package:sangkuriang/widgets/about/diagonally_cut_colored_image.dart';
import 'package:sangkuriang/widgets/about/detail_body.dart';
import 'package:sangkuriang/model/users/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sangkuriang/utils/utils.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sangkuriang/widgets/login_screen/login_screen.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => new _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  SharedPreferences sharedPreferences;
  TabController _controller;

  UsersModel users;

  static const BACKGROUND_IMAGE = 'assets/images/profile_header_background.png';

  bool _isLoading = false;

  getPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String username = sharedPreferences.getString("username");
    int status = sharedPreferences.getInt("status");
    String fullname = sharedPreferences.getString("fullname");
    String cluster = sharedPreferences.getString("cluster");
    String id_nik = sharedPreferences.getString("id_nik");
    String foto = sharedPreferences.getString("foto");
    setState(() {
      users = new UsersModel(
          username: username,
          status: status,
          fullname: fullname,
          cluster_name: cluster,
          id_nik: id_nik,
          foto: foto);
    });
  }

  Future sourceImageFromCamera(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    String base64Image =
        "data:image/jpeg;base64," + base64Encode(image.readAsBytesSync());
    List<int> imageBytes = await image.readAsBytesSync();
    String fileName = image.path.split("/").last;
    submit(context, base64Image);
  }

  Future sourceImageFromGallery(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    String base64Image =
        "data:image/jpeg;base64," + base64Encode(image.readAsBytesSync());
    List<int> imageBytes = await image.readAsBytesSync();
    String fileName = image.path.split("/").last;
    submit(context, base64Image);
  }

  submit(BuildContext context, users_image) async {
    final response = await http.post(Utils.apiUrl + "api/upload", body: {
      'table_name': "users",
      'username': users.username,
      'users_image': users_image,
    });
    final int statusCode = response.statusCode;
    final result = jsonDecode(response.body);
    String msg = result['msg'];
    String file_name = result['file_name'];
    savePrefsImages(file_name);
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error Login");
    }
    setState(() {
      _isLoading = false;
      users.foto = file_name;
    });
    Utils.showSnackBar(context, msg);
  }

  savePrefsImages(String users_image) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("users_image", users_image);
  }

  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return new DiagonallyCutColoredImage(
      new Image.asset(
        BACKGROUND_IMAGE,
        width: screenWidth,
        height: 300.0,
        fit: BoxFit.cover,
      ),
      color: const Color(0xBB8338f4),
    );
  }

  Widget _buildAvatar(BuildContext context) {
//    return new FutureBuilder<String>(
//      future: getImage("http://103.15.226.142/euis/rest/assets/images/" + users.foto),
//      builder: (context, AsyncSnapshot<String> snapshot) {
//        if (!snapshot.hasData) return _showCircularProgress(); // or some other placeholder
//        return new Container(
//            width: 130,
//            height: 130.0,
//            decoration: new BoxDecoration(
//                shape: BoxShape.circle,
//                color: Colors.transparent,
//                image: new DecorationImage(
//                  image: new NetworkImage(snapshot.data),
//                  fit: BoxFit.fill,
//                ),
//                boxShadow: [
//                  BoxShadow(
//                      color: Colors.transparent,
//                      blurRadius: 2.0,
//                      offset: Offset(2.0, 2.0),
//                      spreadRadius: 2.0)
//                ]
//            ),
//            child: new Stack(children: <Widget>[
//              new Positioned(
//                right: 0.0,
//                bottom: 0.0,
//                child: IconButton(
//                  icon: Icon(Icons.add_a_photo),
//                  color: Colors.white70,
//                  tooltip: 'Pick Image',
//                  onPressed: () {
//                    print("camera button click");
//                    _settingModalBottomSheet(context);
//                  },
//                ),
//              ),
//              _showCircularProgress(),
//            ])
//        );
//      },
//    );
    // or some other placeholder
    return new Container(
        width: 130,
        height: 130.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            image: new DecorationImage(
              image: new NetworkImage("http://103.15.226.142/euis/rest/assets/images/" + users.foto),
              fit: BoxFit.fill,
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 2.0,
                  offset: Offset(2.0, 2.0),
                  spreadRadius: 2.0)
            ]
        ),
        child: new Stack(children: <Widget>[
          new Positioned(
            right: 0.0,
            bottom: 0.0,
            child: IconButton(
              icon: Icon(Icons.add_a_photo),
              color: Colors.white70,
              tooltip: 'Pick Image',
              onPressed: () {
                print("camera button click");
                _settingModalBottomSheet(context);
              },
            ),
          ),
          _showCircularProgress(),
        ])
    );
  }

  Future<String> getImage(url) async {
    return url;
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: () {
                      sourceImageFromCamera(context);
                      Navigator.pop(context);
                    }),
                new ListTile(
                  leading: new Icon(Icons.image),
                  title: new Text('Gallery'),
                  onTap: () {
                    sourceImageFromGallery(context);
                    Navigator.pop(context);
                  },
                ),
                new ListTile(
                    leading: new Icon(Icons.cancel),
                    title: new Text('Cancel'),
                    onTap: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    var screenWidth = MediaQuery.of(context).size.width;
    return new Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _createPillButton(
            'LOGOUT',
            screenWidth,
            context,
            backgroundColor: Colors.pinkAccent,
          ),
        ],
      ),
    );
  }

  Widget _createPillButton(
      String text,
      screenWidth,
      BuildContext context, {
        Color backgroundColor = Colors.transparent,
        Color textColor = Colors.white70,
      }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      child: new MaterialButton(
        minWidth: screenWidth * 0.7,
        color: backgroundColor,
        textColor: textColor,
        onPressed: () {
          openDialog(context);
        },
        child: new Text(text),
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
        height: 0.0,
        width: 0.0,
        color: Colors.transparent,
        child: Center(child: CircularProgressIndicator()));
  }

  void logout(BuildContext context) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(builder: (context) => new LoginPage()));
  }

  void openDialog(BuildContext context) {
    var dialog = AlertDialog(
      title: Text('Are you sure want to logout?'),
      //content: const Text('This will remove your item from your cart.'),
      actions: <Widget>[
        FlatButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true)
                .pop(ConfirmAction.CANCEL);
          },
        ),
        FlatButton(
          child: const Text('YES'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true)
                .pop(ConfirmAction.ACCEPT);
            logout(context);
          },
        )
      ],
    );
    Utils.openDialog(context, dialog);
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
    _controller = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          const Color(0xFF413070),
          const Color(0xFF2B264A),
        ],
      ),
    );

    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: <Widget>[
        new SingleChildScrollView(
          child: new Container(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    _buildDiagonalImageBackground(context),
                    new Align(
                      alignment: FractionalOffset.bottomCenter,
                      heightFactor: 1.3,
                      child: new Column(
                        children: <Widget>[
                          _buildAvatar(context),
                          _buildActionButtons(context, theme),
                        ],
                      ),
                    ),
                  ],
                ),
                new Container(
                  //decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
                  child: new TabBar(
                    controller: _controller,
                    labelColor: Colors.black54,
                    indicatorColor: Colors.pinkAccent,
                    tabs: [
                      new Tab(
                        icon: const Icon(Icons.info_outline),
                        text: 'Personal Information',
                      ),
                      new Tab(
                        icon: const Icon(Icons.account_box),
                        text: 'Last Absence',
                      ),
                    ],
                  ),
                ),
                new Container(
                  height: 300.0,
                  child: new TabBarView(
                    controller: _controller,
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: new DetailBody(users),
                      ),
                      new Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: new ListTile(
                            leading: const Icon(Icons.location_on),
                            title: new Text(
                                'Latitude: 48.09342\nLongitude: 11.23403'),
                            trailing: new IconButton(
                                icon: const Icon(Icons.my_location),
                                onPressed: () {}),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
