import 'package:flutter/material.dart';
import 'package:room_easy/models/user.dart';
import 'messages_screen.dart';
import 'package:room_easy/screens/home/profile_screen.dart';
import 'package:room_easy/screens/home/swipe_screen.dart';
import 'package:room_easy/services/auth.dart';
import 'package:room_easy/services/database.dart';
import 'messages_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex =
      0; //int that keeps track of which bottom navigation item is selected
  final AuthService _authService = AuthService();
  List<Widget> _widgetOptions = <Widget>[
    SwipeScreen(),
    MessageScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  initState() {
    //DatabaseService().addUserInfo(RmEasyUser(uid_: _authService.auth.currentUser.uid, name_: _authService.auth.currentUser.email, gender_: "male", grade_: 2, dob_: "12-27-2001"));
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Move chatprofiles provider here
    return Scaffold(
        body: Center(
          child: _widgetOptions[_selectedIndex],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: Color(0xff83b799),
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
              primaryColor: Color(0xffe24e3e),
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: new TextStyle(color: Colors.yellow))),
          // sets the inactive color of the `BottomNavigationBar`
          child: new BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.message), label: 'Chats'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_box_rounded), label: 'Profile'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xffe24e3e),
            onTap: _onItemTapped,
          ),
        ));
  }
}
