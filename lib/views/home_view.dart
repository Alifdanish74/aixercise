import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mynotes/constant/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/main.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mynotes/constant/constants.dart';


class HomeView extends StatefulWidget {
  final bool afterCompletion;

  HomeView({this.afterCompletion = false});

  //final String title;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedIconIndex = 2;

  List<Widget> result = [];
  FlutterTts flutterTts = FlutterTts();

  GlobalKey<ScaffoldState> _key = GlobalKey();
  late PersistentBottomSheetController _controller;
  // var timer;

  var screenSize;

  int _currentPosition = 0;

  String _assistantText = '';
  String _userText = '';

  bool _isListening = false;

  // For text to speech
  double volume = 0.8;
  double pitch = 1;
  double rate = Platform.isAndroid ? 0.8 : 0.6;

  // For speech to text
  //final SpeechToText speech = SpeechToText();

  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";

  //  @override
  // void initState() {
  //   super.initState();

  //   // For uploading tracks to the database
  //   // database.uploadTracks();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: const Color(0xfff5ceb8),
      appBar: AppBar(
        title: const Center(child: Text('Ai-Xercise')),
        backgroundColor: const Color.fromARGB(255, 208, 129, 83),
        actions: <Widget>[
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
              ];
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xfff5ceb8),
            // child: Container(
            //   margin: const EdgeInsets.only(right: 40, top: 20, bottom: 20),
            //   alignment: Alignment.centerLeft,
            //   decoration: const BoxDecoration(
            //       image: DecorationImage(
            //           image: AssetImage('assets/images/path.png'),
            //           fit: BoxFit.contain)),
            // ),
          ),
          Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(20),
                child: const Text(
                  "Hello Danish",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.95,
                  children: <Widget>[
                    categoryWidget('img5', "Trikonasana"),
                    categoryWidget('img5', "Trikonasana"),
                    categoryWidget('img5', "Trikonasana"),
                    categoryWidget('img5', "Trikonasana"),
                    // categoryWidget('img3', "Virabhadrasana II"),
                    // categoryWidget('img4', "Utthita Parvakonasana"),
                  ],
                ),
              ),
              // const SizedBox(
              //   height: 8,
              // ),
              // Container(
              //   padding: const EdgeInsets.symmetric(vertical: 10),
              //   color: Colors.white,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: <Widget>[
              //       Column(
              //         children: const <Widget>[
              //           FaIcon(FontAwesomeIcons.calendar),
              //           Text('Today')
              //         ],
              //       ),
              //       Column(
              //         children: const <Widget>[
              //           FaIcon(
              //             FontAwesomeIcons.dumbbell,
              //             color: Colors.orange,
              //           ),
              //           Text(
              //             'All Exercise',
              //             style: TextStyle(
              //                 color: Colors.orange,
              //                 fontWeight: FontWeight.w700,
              //                 fontSize: 20),
              //           )
              //         ],
              //       ),
              //       Column(
              //         children: const <Widget>[
              //           Icon(Icons.settings),
              //           Text('Settings')
              //         ],
              //       ),
              //     ],
              //   ),
              // )
            ],
          )
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        index: selectedIconIndex,
        buttonBackgroundColor: primary,
        height: 45.0,
        color: white,
        onTap: (index) {
          setState(() {
            selectedIconIndex = index;
          });
        },
        animationDuration: const Duration(
          milliseconds: 200,
        ),
        items: <Widget>[
          Icon(
            Icons.calendar_today_outlined,
            size: 30,
            color: selectedIconIndex == 0 ? white : black,
          ),
          Icon(
            Icons.home_outlined,
            size: 30,
            color: selectedIconIndex == 1 ? white : black,
          ),
          Icon(
            Icons.person_outline,
            size: 30,
            color: selectedIconIndex == 2 ? white : black,
          ),
        ],
      ),
    );
  }

  Container categoryWidget(String img, String title) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          print ("Hello World");
        },
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/$img.png'),
                        fit: BoxFit.contain)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Logout')),
        ],
      );
    },
  ).then((value) => value ?? false);
}
