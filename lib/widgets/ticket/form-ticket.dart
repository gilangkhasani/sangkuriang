import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sangkuriang/model/ticket/ticket.dart';

import 'package:location/location.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'package:sangkuriang/database_helper/database_ticket.dart';
import 'package:http/http.dart' as http;
import 'package:sangkuriang/utils/utils.dart';

class FormTicketPage extends StatefulWidget {

  final TicketModel ticket;
  final String checkBeforeAfter;
  FormTicketPage({Key key, this.ticket, this.checkBeforeAfter}) : super(key: key);

  @override
  _StateFormTicketPage createState() => _StateFormTicketPage();
}

class _StateFormTicketPage extends State<FormTicketPage> {
  File _image, _image2;
  String _timeString, _time1 = "", _time2 = "", _image_meter_hour = "", _image_meter_pln = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey globalKey1 = new GlobalKey();
  GlobalKey globalKey2 = new GlobalKey();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  Decoration decoration1;
  Decoration decoration2;

  var location = new Location();
  Map<String, double> currentLocation = new Map();

  double _textformfield_running_hour, _textformfield_kwh_pln;

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    location.onLocationChanged().listen((value) {
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

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (!mounted) return;
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd kk:mm:ss').format(dateTime);
  }

  Future getImage(int index) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 640, maxWidth: 480);
    if (!mounted) return;
    setState(() {
      if (index == 1) {
        _image = image;
      } else {
        _image2 = image;
      }
    });
  }

  Future<File> cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );
    return croppedFile;
  }

  Widget _showCircularProgress(){
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } return Container(height: 0.0, width: 0.0,);

  }

  Future<String> _capturePng(GlobalKey globalKey, int index, String category) async {
    try {
      RenderRepaintBoundary boundary =
      globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      //var base64 = base64Encode(pngBytes);
      var base64 = "data:image/jpeg;base64," + base64Encode(pngBytes);
      setState(() {
        if(index == 1){
          _image_meter_hour = base64;
        } else {
          _image_meter_pln = base64;
        }
      });
      return base64;
    } catch (e) {
      print(e);
    }
  }

  Widget displaySelectedFile(BuildContext context, File file, GlobalKey globalKey, BoxDecoration decoration, int index, String category) {
    var screenWidth = MediaQuery.of(context).size.width;
    String time;
    if(index == 1){
      time = _time1;
    } else {
      time = _time2;
    }
    if (file == null) {
      return Container();
    } else {
      return Container(
          height: 180.0,
          width: 150.0,
          color: const Color(0xFFFFFFFF),
          //margin: EdgeInsets.all(5.0),
          child: RepaintBoundary(
              key: globalKey,
              child: Container(
                  margin: EdgeInsets.all(5.0),
                  height: 180.0,
                  width: screenWidth * 0.8,
                  decoration: new BoxDecoration(
                    image: DecorationImage(
                      image: new FileImage(file),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: new Stack(children: <Widget>[
                    new Positioned(
                      right: 0.0,
                      bottom: 0.0,
                      child: Text(
                        time,
                        style: TextStyle(
                            color: Colors.yellow,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                            fontSize: 4.0),
                      ),
                    ),
                    new Positioned(
                      right: 0.0,
                      bottom: 10.0,
                      child: Text(
                        "SANGKURIANG",
                        style: TextStyle(
                            color: Colors.yellow,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                            fontSize: 4.0),
                      ),
                    ),
                    new Positioned(
                      right: 0.0,
                      bottom: 20.0,
                      child: Text(
                        currentLocation["latitude"].toString() +
                            " " +
                            currentLocation["longitude"].toString(),
                        style: TextStyle(
                            color: Colors.yellow,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                            fontSize: 4.0),
                      ),
                    ),
                  ]))));
    }
  }

  final String url =
      'https://cdn3.iconfinder.com/data/icons/avatars-flat/33/man_3-512.png';
  final Color green = Color(0xFF1E8161);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          backgroundColor: Colors.black87,
          title: new Text("INFO KENDALA", style: TextStyle(fontFamily: 'Quicksand',),),
          centerTitle: true,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: 10,
                      left: 30,
                      right: 30,
                      bottom: 10
                  ),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(32),
                        bottomLeft: Radius.circular(32)),
                  ),
                  child: Column(
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'TIME REQUEST',
                              style: TextStyle(
                                color: Color(0xFF00BFA5),
                                fontFamily: 'Quicksand',
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              '${widget.ticket.time_request}',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
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
                                '${widget.ticket.status_ticket}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                'CLUSTER',
                                style: TextStyle(
                                  color: Color(0xFF00BFA5),
                                  fontFamily: 'Quicksand',
                                  fontSize: 12.5,
                                ),
                              ),
                              Text(
                                '${widget.ticket.site_id}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                'SITE',
                                style: TextStyle(
                                  color: Color(0xFF00BFA5),
                                  fontFamily: 'Quicksand',
                                  fontSize: 12.5,
                                ),
                              ),
                              Text(
                                '${widget.ticket.site_id}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text(
                              'ALAMAT',
                              style: TextStyle(
                                color: Color(0xFF00BFA5),
                                fontFamily: 'Quicksand',
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                          Text(
                            '${widget.ticket.alamat}',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w900,
                              fontSize: 12.5,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                _showCircularProgress(),
                Form(
                  key: _formKey,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.7,
                    padding: EdgeInsets.all(20),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new TextFormField(
                              keyboardType: TextInputType.number, // Use text input type for texts.
                              validator: (value){
                                if (value.isEmpty) {
                                  return 'Please enter a this field';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (!mounted) return;
                                setState(() {
                                  _textformfield_running_hour = double.parse(value);
                                });
                              },
                              decoration: new InputDecoration(
                                hintText: widget.checkBeforeAfter.toUpperCase() + ' RUNNING HOUR',
                                labelText: widget.checkBeforeAfter.toUpperCase() + ' RUNNING HOUR',
                              ),
                            ),
                            new TextFormField(
                              keyboardType: TextInputType.number, // Use text input type for texts.
                              validator: (value){
                                if (value.isEmpty) {
                                  return 'Please enter a this field';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (!mounted) return;
                                setState(() {
                                  _textformfield_kwh_pln = double.parse(value);
                                });
                              },
                              decoration: new InputDecoration(
                                  hintText: widget.checkBeforeAfter.toUpperCase() + ' kWh PLN',
                                  labelText: widget.checkBeforeAfter.toUpperCase() + ' kWh PLN'),
                            ),
                            new Container(
                              padding: EdgeInsets.only(top: 20),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'PHOTO ' + widget.checkBeforeAfter.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Quicksand',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    if (!mounted) return;
                                    setState(() {
                                      DateTime now = DateTime.now();
                                      _time1 = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
                                      getImage(1);
                                    });
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(top: 20),
                                      width: 155,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF00BFA5),
                                      ),
                                      child: _image == null
                                          ? Image.asset('assets/images/plus.png')
                                          : displaySelectedFile(context, _image, globalKey1, decoration1, 1, widget.checkBeforeAfter.toUpperCase() + "Meter Hour")
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (!mounted) return;
                                    setState(() {
                                      DateTime now = DateTime.now();
                                      _time2 = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
                                      getImage(2);
                                    });
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(top: 20),
                                      width: 155,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF00BFA5),
                                      ),
                                      child: _image2 == null
                                          ? Image.asset('assets/images/plus.png')
                                          : displaySelectedFile(context, _image2, globalKey2, decoration2, 2, widget.checkBeforeAfter.toUpperCase() + "Meter PLN")
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  'GENSET',
                                  style: TextStyle(
                                    fontFamily: 'Quicksand',
                                  ),
                                ),
                                Text(
                                  'KWH',
                                  style: TextStyle(
                                    fontFamily: 'Quicksand',
                                  ),
                                )
                              ],
                            ),
                            new Container(
                              height: 50,
                              width: 200,
                              child: new RaisedButton(
                                child: new Text(
                                  'SAVE',
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Quicksand',
                                  ),
                                ),
                                color: Color(0xFF00BFA5),
                                onPressed: () {
                                  if(_formKey.currentState.validate()){
                                    _formKey.currentState.save();
                                    DateTime now = DateTime.now();
                                    String formattedDate = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
                                    TicketModel t;
                                    if(widget.checkBeforeAfter.toLowerCase() == 'before'){
                                      t = new TicketModel(
                                        no_ticket: widget.ticket.no_ticket,
                                        site_id: widget.ticket.site_id,
                                        requestor : widget.ticket.requestor,
                                        longitude: widget.ticket.longitude,
                                        latitude: widget.ticket.latitude,
                                        alamat: widget.ticket.alamat,
                                        time_request: widget.ticket.time_request,
                                        time_accept:widget.ticket.time_accept,
                                        time_backup: formattedDate,
                                        time_finish: widget.ticket.time_finish,
                                        meter_hour_before: _textformfield_running_hour,
                                        meter_hour_after: widget.ticket.meter_hour_after,
                                        meter_pln_before: _textformfield_kwh_pln,
                                        meter_pln_after: widget.ticket.meter_pln_after,
                                        photo_meter_hour_before: _image_meter_hour,
                                        photo_meter_hour_after: widget.ticket.photo_meter_hour_after,
                                        photo_meter_pln_before: _image_meter_pln,
                                        photo_meter_pln_after: widget.ticket.photo_meter_pln_after,
                                        status_ticket: widget.ticket.status_ticket,
                                        cluster: widget.ticket.cluster,
                                        id_mbp: widget.ticket.id_mbp,
                                      );
                                    } else {
                                      t = new TicketModel(
                                          no_ticket: widget.ticket.no_ticket,
                                          site_id: widget.ticket.site_id,
                                          requestor : widget.ticket.requestor,
                                          longitude: widget.ticket.longitude,
                                          latitude: widget.ticket.latitude,
                                          alamat: widget.ticket.alamat,
                                          time_request: widget.ticket.time_request,
                                          time_accept: widget.ticket.time_accept,
                                          time_backup: widget.ticket.time_backup,
                                          time_finish: formattedDate,
                                          meter_hour_before: widget.ticket.meter_hour_before,
                                          meter_hour_after: _textformfield_running_hour,
                                          meter_pln_before: widget.ticket.meter_pln_before,
                                          meter_pln_after: _textformfield_kwh_pln,
                                          photo_meter_hour_before: widget.ticket.photo_meter_hour_before,
                                          photo_meter_hour_after: _image_meter_hour,
                                          photo_meter_pln_before: widget.ticket.photo_meter_pln_before ,
                                          photo_meter_pln_after: _image_meter_pln,
                                          status_ticket: widget.ticket.status_ticket,
                                          cluster: widget.ticket.cluster,
                                          id_mbp: widget.ticket.id_mbp,
                                      );
                                    }
                                    submitData(t, widget.checkBeforeAfter.toLowerCase());
                                  }
                                },
                              ),
                              margin: new EdgeInsets.only(top: 30.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )

              ],
            ),
          ],
        ),
      );
  }

  void submitData(TicketModel ticket, checkAfterBefore) async{
    DatabaseTicket databaseHelper = DatabaseTicket();
    setState(() {
      _isLoading = true;
    });
    String image_meter_hour = await _capturePng(globalKey1, 1, "adsf");
    String image_metter_pln = await _capturePng(globalKey2, 2, "adsf");
    if(widget.checkBeforeAfter.toLowerCase() == 'before'){
      ticket.photo_meter_hour_before =  image_meter_hour;
      ticket.photo_meter_pln_before =  image_metter_pln;
      _saveToDataStorage(ticket);
      print("save to storage");
      Navigator.pop(context,true);
    } else {
      ticket.photo_meter_hour_after =  image_meter_hour;
      ticket.photo_meter_pln_after =  image_metter_pln;
      ticket.status_ticket = "UP";
      _saveToDataStorage(ticket);
//      print("save to api");
//      await saveToAPI(context, Utils.apiUrl + "ticket", body: ticket.changeMap());
//      await databaseHelper.deleteAllTicket();
      Navigator.pop(context, true);
    }
    setState(() {
      _isLoading = false;
    });
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
}

void _saveToDataStorage(TicketModel ticket) async {
  DatabaseTicket databaseHelper = new DatabaseTicket();
  databaseHelper.initializeDatabase();
  int result = 0;

  result = await databaseHelper.addData(ticket);

}