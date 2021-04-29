import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_it/get_it.dart';
import 'package:mealsify/locator.dart';
import 'package:mealsify/models/UserModel.dart';
import 'package:mealsify/screens/add_screen.dart';
import 'package:mealsify/screens/profile_screen.dart';
import 'package:mealsify/screens/search_screen.dart';
import 'package:mealsify/controllers/UserController.dart';
import 'home_screen.dart';

class PageLoader extends StatefulWidget {
  @override
  _PageLoaderState createState() => _PageLoaderState();
}

class _PageLoaderState extends State<PageLoader> {
  static const navBarIconSize = 32.0;
  static final navbarColor = Color(0xFF3a2318);

  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(
      onItemTapped: _onItemTapped,
    ),
    SearchScreen(),
    AddScreen(
      onItemTapped: _onItemTapped,
    ),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? currentUser = locator.get<UserController>().currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 0 ? EvaIcons.home : EvaIcons.homeOutline,
                  size: navBarIconSize,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 1 ? EvaIcons.grid : EvaIcons.gridOutline,
                  size: navBarIconSize,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 2
                      ? EvaIcons.plusCircle
                      : EvaIcons.plusCircleOutline,
                  size: navBarIconSize,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: _selectedIndex == 3
                          ? navbarColor
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: currentUser != null
                        ? Image.network(
                            currentUser.photoURL,
                            fit: BoxFit.fitHeight,
                            height: navBarIconSize - 2,
                          )
                        : Icon(
                            _selectedIndex == 3
                                ? EvaIcons.person
                                : EvaIcons.personOutline,
                            size: navBarIconSize,
                          ),
                  ),
                ),
                label: '',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: navbarColor,
            unselectedItemColor: navbarColor,
            backgroundColor: Colors.white,
            elevation: 0.0,
            onTap: _onItemTapped,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
