import 'dart:async';
import 'package:flutter/material.dart';

import 'package:sangkuriang/utils/utils.dart';

import 'package:http/http.dart' as http;
import 'package:sangkuriang/model/ticket/ticket.dart';
import 'dart:convert';

import 'package:sangkuriang/widgets/ticket/detail_history_ticket.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sangkuriang/model/users/users.dart';

class HistoryPage extends StatefulWidget {
  @override
  _historyPageState createState() => _historyPageState();
}

class _historyPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  List<TicketModel> ticketList = List<TicketModel>();
  int count = 0;
  SharedPreferences sharedPreferences;
  UsersModel users;

  @override
  void initState() {
    getPrefs();
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
      new HistoryPage();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.black,
          title: new Text(
            "History Ticket",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Quicksand',
            )
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
            child: _buildData(context), onRefresh: refreshList));
  }

  Widget _buildData(BuildContext context) {
    return FutureBuilder<List<TicketModel>>(
      future: getData(http.Client(), '?search={"cluster_name":"${users.cluster_name}"}'),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? getContent(snapshot.data)
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget getContent(List<TicketModel> ticket) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: ticket.length,
        itemBuilder: (context, counter) {
          String statusAction = "";
          if (ticket[counter].time_accept.toString() == "null" &&
              ticket[counter].time_backup.toString() == "null" &&
              ticket[counter].time_finish.toString() == "null") {
            statusAction = "REQUEST";
          } else if (ticket[counter].time_accept.toString() != "null" &&
              ticket[counter].time_backup.toString() == "null" &&
              ticket[counter].time_finish.toString() == "null") {
            statusAction = "ACCEPT";
          } else if (ticket[counter].time_accept.toString() != "null" &&
              ticket[counter].time_backup.toString() != "null" &&
              ticket[counter].time_finish.toString() == "null") {
            statusAction = "BACKUP";
          } else if (ticket[counter].time_accept.toString() != "null" &&
              ticket[counter].time_backup.toString() != "null" &&
              ticket[counter].time_finish.toString() != "null") {
            statusAction = "FINISH";
          }
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailTicketPage(ticket: ticket[counter])));
            },
            child: Card(
              elevation: 2.0,
              child: Row(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 5.0,
                          ),
                          Text("No Ticket : " + ticket[counter].no_ticket,
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Quicksand',
                              )),
                          Text(
                            "Site Id : " + ticket[counter].site_id,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Quicksand',
                            ),
                          ),
                          Text(
                            "STATUS : " + statusAction,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Quicksand',
                            ),
                          ),
                          ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width * 0.2,
                            child: new RaisedButton(
                              child: Text('View Detail',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0)),
                              color: Color(0xFF00BFA5),
                              splashColor: Color(0xFF004D40),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailTicketPage(
                                            ticket: ticket[counter])));
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

Future<List<TicketModel>> getData(http.Client client, search) async {
  String url = Utils.apiUrl + "api/master/ticket_view" + search;
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
  return parsed.map<TicketModel>((json) => TicketModel.fromJson(json)).toList();
}
