import 'package:flutter/material.dart';
import 'package:golf_booking_chatbot/pages/chat_page.dart';
import 'package:golf_booking_chatbot/pages/config_page.dart';
import 'package:golf_booking_chatbot/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Naviagate(),
    );
  }
}

class Naviagate extends StatefulWidget {
  @override
  _NaviagateState createState() => _NaviagateState();
}

class _NaviagateState extends State<Naviagate> {

  int _selecteIndex = 0;

  // void _onTap(int index) {
  //   setState(() {
  //     _selecteIndex = index;
  //   });
  // }

  void _onTap(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _selecteIndex = index;
    });
  }

  final pageController = PageController();
  final bodyList = <Widget>[
    HomePage(),
    ChatPage(),
    ConfigPage(),
  ];

  // final List<Widget> _widgetOptions = <Widget>[
  //   HomePage(),
  //   ChatPage(),
  //   ConfigPage(),
  // ];

  static const items = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat),
      title: Text('Chat'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings ),
      title: Text('Settings'),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: bodyList,
        physics: NeverScrollableScrollPhysics (), // No sliding
      ),
      // IndexedStack(
      //   index: _selecteIndex,
      //   children: _widgetOptions,
      // ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xfff8faf8),
        items: items,
        currentIndex: _selecteIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        onTap: _onTap,
      ),
    );
  }
}

