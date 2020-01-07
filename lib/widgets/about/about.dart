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
    String id_nik = sharedPreferences.getString("id_nik");
    String foto = sharedPreferences.getString("foto");
    int id_mbp = sharedPreferences.getInt("id_mbp");
    String mbp_name = sharedPreferences.getString("mbp_name");
    int id_cluster = sharedPreferences.getInt("id_cluster");
    String cluster_name = sharedPreferences.getString("cluster_name");
    setState(() {
      users = new UsersModel(
          username: username,
          status: status,
          fullname: fullname,
          id_mbp: id_mbp,
          mbp_name: mbp_name,
          id_cluster: id_cluster,
          cluster_name: cluster_name,
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
                    leading: new Icon(Icons.clear),
                    title: new Text('Cancel'),
                    onTap: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  Widget _buildActionButtons(BuildContext context) {
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
            backgroundColor: Color(0xFF00BFA5),
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
        child: new Text(text, style: TextStyle(fontFamily: "Quicksand"),),
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

  Widget _buildProfileImage() {
    return new Container(
        width: 130,
        height: 130.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            image: new DecorationImage(
              image: new NetworkImage(
                  "http://103.15.226.142/euis/rest/assets/images/" +
                      users.foto),
              fit: BoxFit.fill,
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 2.0,
                  offset: Offset(2.0, 2.0),
                  spreadRadius: 2.0)
            ]),
        child: new Stack(children: <Widget>[
          new Positioned(
            right: 0.0,
            bottom: 0.0,
            child: IconButton(
              icon: Icon(Icons.add_a_photo),
              color: Color(0xFF00BFA5),
              tooltip: 'Pick Image',
              onPressed: () {
                print("camera button click");
                _settingModalBottomSheet(context);
              },
            ),
          ),
          _showCircularProgress(),
        ]));
  }

  Widget _buildBio(BuildContext context) {
    TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400, //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: EdgeInsets.all(25.0),
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: 'Sangkuriang',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Quicksand',
                ),
              ),
              TextSpan(
                text:
                    ' adalah layanan aplikasi mobile online, yang memberikan kemudahan bagi para pengguna dalam melakukan pekerjaan. Aplikasi ini pertama kali dibuat pada pertengahan tahun 2019 ',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontFamily: 'Quicksand',
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget _buildGetInTouch(BuildContext context, String text) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 16.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: 30,
              ),
              width: MediaQuery.of(context).size.width,
              //height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(32),
                  bottomLeft: Radius.circular(32),
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      _buildProfileImage(),
                      _buildActionButtons(context),
                    ],
                  )
                ],
              ),
            ),
            _buildBio(context),
            _buildSeparator(screenSize),
            SizedBox(height: 10.0),
            Center(
              child: _buildGetInTouch(context, "(c) ITSB Jabar v.1.0"),
            ),
          ],
        )

    );
  }
}
