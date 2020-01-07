import 'package:flutter/material.dart';
import 'package:sangkuriang/model/users/users.dart';

class DetailBody extends StatelessWidget {
  DetailBody(this.users);
  final UsersModel users;

  Widget _buildStatusInfo(TextTheme textTheme) {
    String status = (users.status == 1) ? "Active" : "Non Active";
    return new Row(
      children: <Widget>[
        new Icon(
          Icons.email,
          color: Colors.black,
          size: 16.0,
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: new Text(
            status,
            style: textTheme.subhead.copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildClusterInfo(TextTheme textTheme) {
    return new Row(
      children: <Widget>[
        new Icon(
          Icons.phone,
          color: Colors.black,
          size: 16.0,
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: new Text(
            users.cluster_name,
            style: textTheme.subhead.copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _createCircleBadge(IconData iconData, Color color) {
    return new Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: new CircleAvatar(
        backgroundColor: color,
        child: new Icon(
          iconData,
          color: Colors.white,
          size: 16.0,
        ),
        radius: 16.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          users.fullname,
          style: textTheme.headline.copyWith(color: Colors.black),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0),
          //child: _buildStatusInfo(textTheme),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0),
          //child: _buildClusterInfo(textTheme),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new Text(
            'Lorem Ipsum is simply dummy text of the printing and typesetting '
                'industry. Lorem Ipsum has been the industry\'s standard dummy '
                'text ever since the 1500s.',
            style:
            textTheme.body1.copyWith(color: Colors.black, fontSize: 16.0),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new Row(
            children: <Widget>[
              _createCircleBadge(Icons.beach_access, Colors.pink),
              _createCircleBadge(Icons.cloud, Colors.pinkAccent),
              _createCircleBadge(Icons.shop, Colors.pinkAccent),
            ],
          ),
        ),
      ],
    );
  }
}