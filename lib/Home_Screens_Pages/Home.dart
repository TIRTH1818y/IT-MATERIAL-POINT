import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:itmaterialspoint/Drawer_Pages/Drawer.dart';
import 'package:itmaterialspoint/Home_Screens_Pages/search.dart';
import 'package:itmaterialspoint/Home_Screens_Pages/technology_page.dart';
import 'package:itmaterialspoint/Profile/profile.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Profile/edit_profile.dart';
import 'home_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _homeState();
}

class _homeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  setGoogleUser();
    requestStoragePermission();
  }

  bool colorBW = false;

  Future<bool> requestStoragePermission() async {
    // Check current permission status
    await Permission.storage.request();
    // If permission not granted, request it
    if (await Permission.storage.isGranted) {
      print("Storage Permission Granted.");
    } else if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    } else if (await Permission.storage.isPermanentlyDenied) {
      return Permission.storage.isGranted;
    }

    // Return true if permission granted, false otherwise
    return Permission.storage.isGranted;
  }

  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      home_page(
        colorBW: colorBW,
      ),
      SearchPage(colorBW: colorBW),
      techno_page(
        colorBW: colorBW,
      ),
      profile(
        colorBW: colorBW,
        callappbar: false,
      ),
    ];
    return Scaffold(
      backgroundColor: !colorBW ? Colors.grey[800] : Colors.white,
      key: _scafoldkey,
      drawer: MyDrawer(
        colorBW: colorBW,
      ),
      bottomNavigationBar: GNav(
        curve: Curves.easeInOut,
        style: GnavStyle.google,
        gap: 5,
        tabMargin: const EdgeInsets.only(top: 7, bottom: 7),
        activeColor: colorBW ? Colors.white : Colors.cyanAccent,
        color: colorBW ? Colors.black : Colors.white70,
        iconSize: 20,
        backgroundColor: colorBW ? Colors.black26 : Colors.black,
        padding: const EdgeInsets.all(18),
        duration: const Duration(milliseconds: 200),
        tabBackgroundColor: colorBW ? Colors.black54 : Colors.black,
        rippleColor: colorBW ? Colors.white : Colors.cyan,
        onTabChange: (index) {
          if (mounted == true) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        tabs: const [
          GButton(
            icon: Icons.home,
            iconSize: 20,
            text: 'Home',
          ),
          GButton(
            icon: Icons.search,
            text: 'Search',
          ),
          GButton(
            icon: Icons.language,
            text: 'Technologies',
          ),
          GButton(
            icon: Icons.account_circle_outlined,
            text: 'Profile',
          ),
        ],
        selectedIndex: _selectedIndex,
      ),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: !colorBW ? Colors.black : Colors.grey,
        leading: IconButton(
          icon: Icon(Icons.menu_sharp,
              color: colorBW ? Colors.black : Colors.white),
          onPressed: () {
            _scafoldkey.currentState!.openDrawer();
          },
          style: const ButtonStyle(
              animationDuration: Duration(milliseconds: 2000)),
        ),
        // backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "IT ",
              style: TextStyle(
                  fontFamily: "karsyu",
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: !colorBW ? Colors.white70 : Colors.black45),
            ),
            const Text(
              "Material ",
              style: TextStyle(
                  fontFamily: "karsyu",
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.blueGrey),
            ),
            const Text(
              "Point",
              style: TextStyle(
                  fontFamily: "karsyu",
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.tealAccent),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  colorBW = !colorBW;
                });
              },
              icon: Icon(
                !colorBW ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              ),
              color: !colorBW ? Colors.white : Colors.black),
          _selectedIndex == 3
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.edit_rounded,
                      color: !colorBW ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile(
                                    colorBW: colorBW,
                                  )));
                    },
                  ),
                )
              : const SizedBox(),
        ],
      ),
      //for displaying Items
      body: Container(
        child: widgetOptions[_selectedIndex],
      ),
    );
  }
}
