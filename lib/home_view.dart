import 'dart:io';
import 'dart:math';

//import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_tts/flutter_tts.dart';
//import 'package:aixercise/constant/routes.dart';
//import 'package:aixercise/enums/menu_action.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:aixercise/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'predictor_page.dart';
//import 'package:aixercise/constant/constants.dart';
//import 'package:aixercise/predictor_page.dart';

class HomeView extends StatefulWidget {
  final bool afterCompletion;

  HomeView({this.afterCompletion = false});

  //final String title;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedIconIndex = 2;
  int selectedIndex = 1;

  List<Widget> result = [];
 //FlutterTts flutterTts = FlutterTts();

  GlobalKey<ScaffoldState> _key = GlobalKey();
  PersistentBottomSheetController _controller;
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
      // appBar: AppBar(
      //   title: const Center(child: Text('Ai-Xercise')),
      //   backgroundColor: const Color.fromARGB(255, 208, 129, 83),
      // ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xfff5ceb8),
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
            ],
          )
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
          openProductPage(title);
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

  void openProductPage(String title) {
    switch (title) {
      case 'Trikonasana':
        {
          // statements;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => (PredictorPage("trikonasana.mp4"))),);
        }
        break;

      case 'Trikonasana':
        {
          //statements;
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (redContext) => PredictorPage("trikonasana.mp4")));
        }
        break;

      case 'Trikonasana':
        {
          //statements;
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (redContext) => PredictorPage("trikonasana.mp4")));
        }
        break;
      case 'Trikonasana':
        {
          //statements;
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (redContext) => PredictorPage("trikonasana.mp4")));
        }
        break;

      default:
        {
          throw Exception('Path $title not supported');
        }
    }
  }
}

