import 'package:flutter/material.dart';


class ChatMessageWidget extends StatelessWidget {
  final String _name = "U";

  final String text;
  final String name;
  final bool isMyMessage;

  ChatMessageWidget({this.text, this.name, this.isMyMessage});

  List<Widget> _otherMessage(context) {
    return <Widget>[
      Container(
        margin: EdgeInsets.only(right: 16.0),
        child: CircleAvatar(child: Text(name != null ? name[0] : _name)),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(this.name ?? _name, style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Text(text ?? ''),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _myMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(this.name ?? _name, style: Theme.of(context).textTheme.subhead),
            Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Text(text ?? ''),
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          child: Text(name != null ? name[0] : _name,
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.isMyMessage ? _myMessage(context) : _otherMessage(context),
      ),
    );
  }
}