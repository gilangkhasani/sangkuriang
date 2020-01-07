import 'package:flutter/material.dart';
import 'package:sangkuriang/model/ticket/ticket.dart';

import 'package:flutter/rendering.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailTicketPage extends StatefulWidget {
  final TicketModel ticket;
  DetailTicketPage({Key key, this.ticket}) : super(key: key);

  @override
  _StateDetailTicketPage createState() => _StateDetailTicketPage();
}

class _StateDetailTicketPage extends State<DetailTicketPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final Color color1 = Color(0xFF004D40);
  final Color color2 = Color(0xFF00BFA5);
  final Color color3 = Color(0xFF1DE9B6);

  @override
  void initState() {}

  @override
  void dispose() {
    super.dispose();
  }

  final String url =
      'https://cdn3.iconfinder.com/data/icons/avatars-flat/33/man_3-512.png';
  final Color green = Color(0xFF1E8161);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: Colors.black,
        title: new Text("Detail Ticket", textAlign: TextAlign.center,),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildHeader(),
                new Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'History Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Quicksand',
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                new Column(
                  children: <Widget>[
                    Text(
                      'TIME REQUEST : ${widget.ticket.time_request}',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                    Text(
                      'TIME ACCEPT : ${widget.ticket.time_accept}',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                    Text(
                      'TIME BACKUP : ${widget.ticket.time_backup}',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                    Text(
                      'TIME FINISH : ${widget.ticket.time_finish}',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'RUNNING HOUR',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return DetailScreen("http://103.15.226.142/ticket_sangkuriang/assets/images/ticket/" +
                              widget.ticket.photo_meter_hour_before);
                        }));
                      },
                      child: new Container(
                          height: 150,
                          width: 150,
                          child: Stack(
                            children: <Widget>[
                              Center(child: CircularProgressIndicator()),
                              Center(
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: "http://103.15.226.142/ticket_sangkuriang/assets/images/ticket/" +
                                      widget.ticket.photo_meter_hour_before,
                                ),
                              ),
                            ],
                          ),
                      ),
                    ),
                    new GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return DetailScreen("http://103.15.226.142/ticket_sangkuriang/assets/images/ticket/" +
                              widget.ticket.photo_meter_hour_after);
                        }));
                      },
                      child: new Container(
                          height: 150,
                          width: 150,
                          child: Stack(
                            children: <Widget>[
                              Center(child: CircularProgressIndicator()),
                              Center(
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: "http://103.15.226.142/ticket_sangkuriang/assets/images/ticket/" +
                                      widget.ticket.photo_meter_hour_after,
                                ),
                              ),
                            ],
                          ),
                      ),
                    ),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('BEFORE : ' + widget.ticket.meter_hour_before.toString(), style: TextStyle(fontFamily: 'Quicksand',)),
                    Text('AFTER : ' + widget.ticket.meter_hour_after.toString(), style: TextStyle(fontFamily: 'Quicksand',))
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'KWH PLN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return DetailScreen("http://103.15.226.142/ticket_sangkuriang/assets/images/ticket/" +
                              widget.ticket.photo_meter_pln_before);
                        }));
                      },
                      child: new Container(
                          height: 150,
                          width: 150,
                          child: Stack(
                            children: <Widget>[
                              Center(child: CircularProgressIndicator()),
                              Center(
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: "http://103.15.226.142/ticket_sangkuriang/assets/images/ticket/" +
                                      widget.ticket.photo_meter_pln_before,
                                ),
                              ),
                            ],
                          ),
                      ),
                    ),
                    new GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return DetailScreen("http://103.15.226.142/ticket_sangkuriang/assets/images/ticket/" +
                              widget.ticket.photo_meter_pln_after);
                        }));
                      },
                      child: new Container(
                          height: 150,
                          width: 150,
                          child: Stack(
                            children: <Widget>[
                              Center(child: CircularProgressIndicator()),
                              Center(
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: "http://103.15.226.142/ticket_sangkuriang/assets/images/ticket/" +
                                      widget.ticket.photo_meter_pln_after,
                                ),
                              ),
                            ],
                          ),

                      ),
                    ),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('BEFORE : ' + widget.ticket.meter_pln_before.toString(), style: TextStyle(fontFamily: 'Quicksand',)),
                    Text('AFTER : ' + widget.ticket.meter_pln_after.toString(), style: TextStyle(fontFamily: 'Quicksand',))
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
              ]
          )
        ],
      ),
    );
  }

  Container _buildHeader() {
    return Container(
      height: 160,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: -100,
            top: -120,
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [color1, color2]),
                  boxShadow: [
                    BoxShadow(
                        color: color2,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 10.0)
                  ]),
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [color3, color2]),
                boxShadow: [
                  BoxShadow(
                      color: color3, offset: Offset(1.0, 1.0), blurRadius: 4.0)
                ]),
          ),
          Positioned(
            top: 80,
            left: 40,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [color3, color2]),
                  boxShadow: [
                    BoxShadow(
                        color: color3,
                        offset: Offset(1.0, 1.0),
                        blurRadius: 4.0)
                  ]),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 50, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Detail Ticket",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Quicksand',
                      fontSize: 19.0,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


class DetailScreen extends StatelessWidget {
  String urlImage;
  DetailScreen(String urlImage) : this.urlImage = urlImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
        icon: Icon(Icons.clear),
        color: Colors.black54,
        onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              urlImage,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}