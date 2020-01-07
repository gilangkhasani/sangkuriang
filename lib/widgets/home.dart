import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sangkuriang/model/ticket/ticket.dart';
import 'package:sangkuriang/model/users/users.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sangkuriang/utils/utils.dart';
import 'package:sangkuriang/database_helper/database_ticket.dart';
import 'package:intl/intl.dart';
import 'package:sangkuriang/widgets/ticket/form-ticket.dart';

import 'package:location/location.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'swipe_button.dart';

import 'dart:io';

class HomePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  DatabaseTicket databaseHelper = DatabaseTicket();
  List<TicketModel> ticketList = List<TicketModel>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int count = 0;
  bool _isLoading = false;
  SharedPreferences sharedPreferences;
  bool checkConnection = false;

  UsersModel users;

  final String url =
      'https://cdn1.iconfinder.com/data/icons/avatars-55/100/avatar_profile_user_music_headphones_shirt_cool-512.png';

  var location = new Location();
  Map<String, double> currentLocation = new Map();

  @override
  void initState() {
    getPrefs();
    location.onLocationChanged().listen((value) {
      if(this.ticketList.length > 0){
        saveLongitudeLatitude(body: parseToMapLongLat(value["longitude"], value["latitude"]));
      }
      if (!mounted) return;
      setState(() {
        currentLocation = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

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

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      new HomePage();
    });

    return null;
  }

  saveLongitudeLatitude({Map body}) async{
    String url = Utils.apiUrl + "api/master/location_user_by_ticket";
    final response = await http.post (url, body : body);
    final data = jsonDecode (response.body);
  }

  Map parseToMapLongLat(double longitude, double latitude) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
    var map = new Map<String, dynamic>();
    map["username"] = users.username;
    map["no_ticket"] = this.ticketList[0].no_ticket;
    map["longitude"] = longitude.toString();
    map["latitude"] = latitude.toString();
    map["created_date"] = formattedDate;

    return map;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        key: _scaffoldKey,
        body: RefreshIndicator(
            child: _buildContent(context), onRefresh: refreshList));
  }

  Widget _buildContent(BuildContext context) {
//    databaseHelper.dropTable();
//    databaseHelper.createTableTicket();
    //databaseHelper.deleteAllTicket();
    getListData();
    return Stack(
      children: <Widget>[
        (this.count == 0)
            ? _buildClearedData(context)
            : getDataList(context, this.ticketList),
        _showCircularProgress()
      ],
    );
  }

  void getListData() {
    Future<List<TicketModel>> noteListFuture = databaseHelper.getTicketListByUsernameCluster(users);
    //Future<List<TicketModel>> noteListFuture = databaseHelper.getTicketList();
    noteListFuture.then((dataList) {
      int count = dataList.length;
      if (count == 0) {
        setState(() {
          this.ticketList = null;
          this.count = 0;
        });
        FutureBuilder<List<TicketModel>>(
          future: getData(http.Client(),
              '?search={"status_ticket":"down","id_mbp":"${users.id_mbp}"}'),
          builder: (context, snapshot) {
            if (snapshot.hasError) if (snapshot.hasData) {
              setState(() {
                this.ticketList = snapshot.data;
                this.count = snapshot.data.length;
              });
            }
          },
        );
      } else {
        setState(() {
          this.ticketList = dataList;
          this.count = dataList.length;
        });
      }
    });
  }

  Widget _buildClearedData(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 15,
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
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Color(0xFF00BFA5),
                      image: DecorationImage(
                        image: AssetImage('assets/images/avatar.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(100.0),
                      border: Border.all(
                        color: Color(0xFFF5F5F5),
                        width: 5.0,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'STATUS',
                            style: TextStyle(
                              color: Color(0xFF00BFA5),
                              fontFamily: 'Quicksand',
                              fontSize: 12.5,
                            ),
                          ),
                          Text(
                            'CLEARED',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'REQUEST',
                            style: TextStyle(
                              color: Color(0xFF00BFA5),
                              fontFamily: 'Quicksand',
                              fontSize: 12.5,
                            ),
                          ),
                          Text(
                            'BACKUP',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w900,
                              fontSize: 19,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    'WELCOME',
                    style: TextStyle(
                      color: Color(0xFFF5F5F5),
                      fontFamily: 'Quicksand',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: Text(
                    users.fullname,
                    style: TextStyle(
                        color: Color(0xFFF5F5F5),
                        fontFamily: 'Quicksand',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ]
            )
          ),
          SizedBox(height: 40.0,),
          Container(
            width: 200.0,
            height: 200.0,
            child: Center(
              child: Image.asset("assets/images/no-data.png"),
            ),
          )
        ]
        )
      ],
    );
  }

  Widget getDataList(BuildContext context, List<TicketModel> ticket) {
    Size screenSize = MediaQuery.of(context).size;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: ticket.length,
        itemBuilder: (BuildContext context, int counter) {
          String statusAction = "";
          String currentStatus = "";
          String checkBeforeAfter = "";
          if (ticket[counter].time_accept.toString() == "null") {
            statusAction = "ACCEPT";
            currentStatus = "REQUEST";
          } else if (ticket[counter].time_backup.toString() == "null") {
            statusAction = "BACKUP";
            currentStatus = "ACCEPT";
            checkBeforeAfter = "Before";
          } else if (ticket[counter].time_finish.toString() == "null") {
            statusAction = "FINISH";
            currentStatus = "BACKUP";
            checkBeforeAfter = "After";
          } else {
            currentStatus = "FINISH";
            statusAction = "SYNC";
          }
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: 15,
                ),
                width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height / 2.0,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(32),
                    bottomLeft: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Color(0xFF00BFA5),
                          image: DecorationImage(
                            image: AssetImage('assets/images/avatar.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(100.0),
                          border: Border.all(
                            color: Color(0xFFF5F5F5),
                            width: 5.0,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'STATUS',
                                style: TextStyle(
                                  color: Color(0xFF00BFA5),
                                  fontFamily: 'Quicksand',
                                  fontSize: 12.5,
                                ),
                              ),
                              Text(
                                '${ticket[counter].status_ticket.toUpperCase()}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'REQUEST',
                                style: TextStyle(
                                  color: Color(0xFF00BFA5),
                                  fontFamily: 'Quicksand',
                                  fontSize: 12.5,
                                ),
                              ),
                              Text(
                                'BACKUP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 19,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        'WELCOME',
                        style: TextStyle(
                          color: Color(0xFFF5F5F5),
                          fontFamily: 'Quicksand',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                      ),
                      child: Text(
                        users.fullname,
                        style: TextStyle(
                            color: Color(0xFFF5F5F5),
                            fontFamily: 'Quicksand',
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        'TICKET ID : ${ticket[counter].no_ticket}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 0, top: 5.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'TIME REQUEST',
                            style: TextStyle(
                              color: Color(0xFF00BFA5),
                              fontFamily: 'Quicksand',
                              fontSize: 19,
                            ),
                          ),
                          Text(
                            '${ticket[counter].time_request}',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                //height: MediaQuery.of(context).size.height / 3.5,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Utils.openRoute(
                                    currentLocation["latitude"],
                                    currentLocation["longitude"],
                                    ticket[counter].latitude,
                                    ticket[counter].longitude);
                              },
                              child: Image.asset(
                                'assets/images/maps.png',
                                height: 50,
                                width: 50,
                              ),
                            ),
                            Text(
                              'TRACK',
                              style: TextStyle(
                                color: Color(0xFF00BFA5),
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                        new Flexible(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFF00BFA5),
                              border: Border.all(
                                color: Color(0xFFF5F5F5),
                                width: 5.0,
                              ),
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(10.0),
                                topRight: const Radius.circular(10.0),
                                bottomLeft: const Radius.circular(10.0),
                                bottomRight: const Radius.circular(10.0),
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                new Text(
                                  'SITE : ${ticket[counter].site_id}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Quicksand',
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                new Text(
                                  'STATUS : ${currentStatus}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Quicksand',
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                new Text(
                                  'ALAMAT : ${ticket[counter].alamat}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Quicksand',
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 70,
                width: 320,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: SwipeButton(
                    thumb: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          widthFactor: 2.0,
                          child: Icon(
                            Icons.chevron_right,
                            size: 50.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    content: Center(
                      child: Text(
                        'SWIPE RIGHT TO $statusAction',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                        ),
                      ),
                    ),
                    onChanged: (result) {
                      if (result == SwipePosition.SwipeRight) {
                        setState(() {
                          _isLoading = true;
                        });
                        DateTime now = DateTime.now();
                        String formattedDate =
                            DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
                        TicketModel t = new TicketModel(
                            no_ticket: ticket[counter].no_ticket,
                            site_id: ticket[counter].site_id,
                            requestor: ticket[counter].requestor,
                            longitude: ticket[counter].longitude,
                            latitude: ticket[counter].latitude,
                            alamat: ticket[counter].alamat,
                            time_request: ticket[counter].time_request,
                            time_accept:
                                (ticket[counter].time_accept.toString() ==
                                        'null'
                                    ? formattedDate
                                    : ticket[counter].time_accept),
                            time_backup: ticket[counter].time_backup,
                            time_finish: ticket[counter].time_finish,
                            meter_hour_before:
                                ticket[counter].meter_hour_before,
                            meter_hour_after: ticket[counter].meter_hour_after,
                            meter_pln_before: ticket[counter].meter_pln_before,
                            meter_pln_after: ticket[counter].meter_pln_after,
                            photo_meter_hour_before:
                                ticket[counter].photo_meter_hour_before,
                            photo_meter_hour_after:
                                ticket[counter].photo_meter_hour_after,
                            photo_meter_pln_before:
                                ticket[counter].photo_meter_pln_before,
                            photo_meter_pln_after:
                                ticket[counter].photo_meter_pln_after,
                            cluster: ticket[counter].cluster,
                            id_mbp: ticket[counter].id_mbp,
                            status_ticket: ticket[counter].status_ticket);
                        if (statusAction == 'ACCEPT') {
                          _saveToDataStorage(t);
                          setState(() {
                            statusAction = "BACKUP";
                            _isLoading = false;
                          });
                        } else if(statusAction == 'SYNC'){
                          getConnection();
                          print('SYNC THIS DATA');
                          submitData(t, context);
                          setState(() {
                            _isLoading = false;
                          });
                        } else {
                          Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) => new FormTicketPage(
                                      ticket: t,
                                      checkBeforeAfter: checkBeforeAfter)));
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      } else {
                        print("swipe Left");
                      }
                    },
                  ),
                ),
              )
            ],
          );
        });
  }
  void submitData(TicketModel ticket, BuildContext context) async {
    if(checkConnection){
      showInSnackBar("Sync This Data"); 
      DatabaseTicket databaseHelper = DatabaseTicket();
      await saveToAPI(context, Utils.apiUrl + "ticket", body: ticket.changeMap());
      await databaseHelper.deleteAllTicket();
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => new HomePage()));
    } else {
      showInSnackBar("No Internet Connection");
    }
  }

  Future<TicketModel> saveToAPI(BuildContext context, String url, {Map body}) async {
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;
      final result = jsonDecode(response.body);
      String msg = result['msg'];
      if (statusCode < 200 || statusCode > 400 || json == null) {
        showInSnackBar(msg);
        throw new Exception("Error Save to API");
      } else {
        print(response.body);
        showInSnackBar(msg);
      }
    });
  }

  void deleteListDataStorage() {
    databaseHelper.deleteAllTicket();
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

  getConnection() async {
    try {
      var result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          checkConnection = true;
        });
        print('connected');
      }
    } on SocketException catch (_) {
      setState(() {
        checkConnection = false;
      });
      print('not connected');
    }
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
      backgroundColor: Color(0xFF00BFA5),
      duration: Duration(seconds: 3),
    ));
  }
}

Future<List<TicketModel>> getData(http.Client client, search) async {
  String url = Utils.apiUrl + "api/master/ticket" + search;
  print(url);
  final response = await client.get(url);
  if (response.statusCode == 200) {
    // Use the compute function to run parsePhotos in a separate isolate
    return parseData(response.body);
  } else {
    throw Exception('Failed to load post');
  }
}

// A function that converts a response body into a List<TicketModel>
List<TicketModel> parseData(String responseBody) {
  final res = json.decode(responseBody);
  final parsed = res['result'].cast<Map<String, dynamic>>();
  List<TicketModel> ticketList;
  ticketList =
      parsed.map<TicketModel>((json) => TicketModel.fromJson(json)).toList();
  for (int i = 0; i < ticketList.length; i++) {
    _saveToDataStorage(ticketList[i]);
  }

  return parsed.map<TicketModel>((json) => TicketModel.fromJson(json)).toList();
}

void _saveToDataStorage(TicketModel ticket) async {
  DatabaseTicket databaseHelper = new DatabaseTicket();
  databaseHelper.initializeDatabase();
  int result = 0;
  result = await databaseHelper.addData(ticket);
}
