import 'dart:async';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sangkuriang/model/history.dart';
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  @override
  _historyPageState createState() => _historyPageState();
}

class _historyPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  int count = 0;
  String id_user, auth;

  @override
  void initState() {
    setState(() {
      id_user = "1";
      auth = "c2c0fd90a5a417ee860da09ab42ae63c";
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      new HistoryPage();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    var lebar = MediaQuery.of(context).size.width;
    var panjang = MediaQuery.of(context).size.height;
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.black,
          title: new Text("History Ticket",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Quicksand',
              )),
          centerTitle: true,
        ),
        body: RefreshIndicator(
            child: Container(
                height: panjang,
                width: lebar,
                padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: _buildData(context)),
            onRefresh: refreshList));
  }

  Map changeMap() {
    var map = new Map<String, dynamic>();
    map["id_user"] = id_user;
    map["auth"] = auth;

    return map;
  }

  Widget _buildData(BuildContext context) {
    return FutureBuilder<List<HistoryModel>>(
      future: getData(http.Client(), body: changeMap()),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? getContent(snapshot.data, )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget getContent(List<HistoryModel> history) {
    var lebar = MediaQuery.of(context).size.width;
    var panjang = MediaQuery.of(context).size.height;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: history.length,
        itemBuilder: (context, counter) {
          String timeCheckIn, timeCheckOut;
          if(history[counter].checkin != '-'){
            var string = history[counter].checkin;
            string.split(" ");
            timeCheckIn = string[1];
          }
          if(history[counter].checkout != '-'){
            var string = history[counter].checkout;
            string.split(" ");
            timeCheckOut = string[1];
          }
          return Container(
            child: Column(
              children: <Widget>[
                new SizedBox(
                  height: 3.0,
                  child: new Center(
                    child: new Container(
                      margin: new EdgeInsetsDirectional.only(
                          start: 1.0, end: 0.9),
                      height: 10.0,
                      color: Colors.black26,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Text(
                      history[counter].tanggal,
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                      width: lebar,
                      height: panjang / 10,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('Clock In'),
                            Text(timeCheckIn),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.4),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(30.0),
                              topRight: const Radius.circular(30.0),
                              bottomLeft: const Radius.circular(30.0),
                              bottomRight: const Radius.circular(30.0),
                            )),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                      width: lebar,
                      height: panjang / 10,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('Clock Out'),
                            Text(timeCheckOut),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.4),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(30.0),
                              topRight: const Radius.circular(30.0),
                              bottomLeft: const Radius.circular(30.0),
                              bottomRight: const Radius.circular(30.0),
                            )),
                      ),
                    ),
                  ],
                ),
            ]
          )
          );
        });
  }
}

Future<List<HistoryModel>> getData(http.Client client, {Map body}) async {
  String url = " https://itbsjabartsel.com/lokasi/api/api.php?q=history";
  client.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;
    final result = jsonDecode(response.body);
    String status = result['status'];
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw Exception('Failed to load post');
    } else {
      return parseData(response.body);
    }
  });
}

// A function that converts a response body into a List<TicketModel>
List<HistoryModel> parseData(String responseBody) {
  final res = json.decode(responseBody);
  final parsed = res['data'].cast<Map<String, dynamic>>();

  return parsed
      .map<HistoryModel>((json) => HistoryModel.fromJson(json))
      .toList();
}
