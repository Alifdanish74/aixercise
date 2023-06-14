import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:aixercise/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aixercise/utilities/output_speech.dart';
import 'package:aixercise/home_view.dart';
import 'package:tflite/tflite.dart';
import 'package:video_player/video_player.dart';

import 'page/home_page.dart';

bool isPredicted = false;
int predictionStatus = 0;

/// Widget for creating the Prediction screen,
/// where the recognition of the poses occur
/// and the user is given proper feedback according to it
class PredictorPage extends StatefulWidget {
  final String videoName;
  const PredictorPage(this.videoName);
  @override
  _PredictorPageState createState() => _PredictorPageState();
}

class _PredictorPageState extends State<PredictorPage> {
  VideoPlayerController videoPlayerController;
  CameraController _cameraController;
  FlutterTts flutterTts = FlutterTts();

  GlobalKey<ScaffoldState> _key = GlobalKey();
  PersistentBottomSheetController _controller;
  // var timer;

  Size screenSize;

  int _currentPosition = 0;

  String _assistantText = '';
  String _userText = '';

  bool _isListening = false;
  bool isDetecting = false;

  static int delay = 10;

  // For surya namaskar
  // List<int> durationList = [
  //   13,
  //   25 + delay,
  //   41 + delay * 2,
  //   56 + delay * 3,
  //   71 + delay * 4,
  //   82 + delay * 5,
  //   92 + delay * 6,
  //   117 + delay * 7,
  //   131 + delay * 8,
  //   142 + delay * 9,
  //   154 + delay * 10,
  //   165 + delay * 11,
  //   175 + delay * 12,
  // ];

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
  //List<LocaleName> _localeNames = [];

  List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;
  int i = 0;

  int totalRecognitions = 0;

  int totalRecognitionsTri = 0;
  int totalRecognitionsTad = 0;

  double avgPoseTrikonasana = 0.0;
  double avgPoseTadasana = 0.0;

  Future<void> _initVideoPlayer() async {
    videoPlayerController = VideoPlayerController.asset(
        'assets/videos/trikonasana.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      })
      ..setVolume(1)
      ..play()
      ..addListener(() {
        final bool isPlaying = videoPlayerController.value.isPlaying;

        if (isPlaying) {
          _currentPosition = videoPlayerController.value.position.inSeconds;
          print("CURRENT POS: $_currentPosition");

          if (_currentPosition == durationList[i]) {
            videoPlayerController.pause();
            setState(() {
              predictionStatus = 1;
            });

            flutterTts.speak('Recognizing the pose');
            _cameraController.startImageStream((CameraImage img) {
              if (!isDetecting && predictionStatus == 1) {
                isDetecting = true;

                Tflite.runModelOnFrame(
                  imageMean: 128,
                  imageStd: 128,
                  bytesList: img.planes.map((plane) {
                    return plane.bytes;
                  }).toList(),
                  imageHeight: img.height,
                  imageWidth: img.width,
                  numResults: 2,
                  asynch: true,
                  rotation: 90,
                  threshold: 0.2,
                ).then((recognitions) async {
                  recognitions?.map((res) {});

                  print(recognitions);

                  _setRecognitions(recognitions, img.height, img.width);

                  if (_recognitions != null && totalRecognitions <= 50) {
                    totalRecognitions++;
                    print(
                        'TOTAL RECOGNITIONS: $totalRecognitions, TADASANA: $avgPoseTadasana, TRIKONASANA: $avgPoseTrikonasana');

                    int length = _recognitions.length;

                    for (int j = 0; j < length; j++) {
                      if (_recognitions[j]["index"] == 0) {
                        totalRecognitionsTad++;
                        avgPoseTadasana += _recognitions[j]["confidence"];
                      } else if (_recognitions[j]["index"] == 1) {
                        totalRecognitionsTri++;
                        avgPoseTrikonasana += _recognitions[j]["confidence"];
                      }
                    }
                  }

                  if (totalRecognitions == 50) {
                    totalRecognitions = 0;
                    int recognizedPose;

                    double percentageTad =
                        (avgPoseTadasana / totalRecognitionsTad) * 100;
                    double percentageTri =
                        (avgPoseTrikonasana / totalRecognitionsTri) * 100;

                    print("PERCENTGE TAD: ${percentageTad.isNaN}");
                    print("PERCENTGE TRI: ${percentageTri.isNaN}");

                    percentageTad = percentageTad.isNaN ? 0.00 : percentageTad;

                    percentageTri = percentageTri.isNaN ? 0.00 : percentageTri;

                    print(
                        'TADASANA: $percentageTad, TRIKONASANA: $percentageTri');

                    if (percentageTad < percentageTri) {
                      recognizedPose = 1;
                    } else {
                      recognizedPose = 0;
                    }

                    if (recognizedPose == indexPose[i]) {
                      if (i > 1) {
                        predictionStatus = 2;
                        flutterTts.speak('Triangle pose successfully complete');

                        await Future.delayed(const Duration(seconds: 2));

                        _controller = _key.currentState.showBottomSheet(
                          (_) => bottomSheet(),
                        );

                        await Future.delayed(Duration(seconds: 2), () async {
                          _controller.setState(() {
                            _assistantText = poseCompletion;
                          });

                          await _speak(poseCompletion);
                          await Future.delayed(Duration(seconds: 4));
                          flutterTts.setCompletionHandler(() async {
                            await flutterTts.stop();
                          });
                        });

                        await Future.delayed(Duration(seconds: 5), () async {
                          // await stopListening();
                          setState(() {});
                          // _controller.setState!(() {
                          //   _assistantText = oneCompletionString;
                          // });
                          await Future.delayed(Duration(milliseconds: 600));
                          //await _speak(oneCompletion);
                          flutterTts.setCompletionHandler(() async {
                            await flutterTts.stop();
                            _controller.setState(() {
                              _assistantText = exploreTracksCompletion;
                            });
                            await Future.delayed(Duration(milliseconds: 600));
                            await _speak(exploreTracksCompletion);
                            flutterTts.setCompletionHandler(() async {
                              await flutterTts.stop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HomeView(afterCompletion: true),
                                ),
                              );
                            });
                          });
                        });
                      } else {
                        predictionStatus = 2;
                        flutterTts
                            .speak('Moving on to the next step')
                            .whenComplete(
                              () => Future.delayed(const Duration(seconds: 3),
                                  () {
                                setState(() {
                                  predictionStatus = 0;
                                  i++;
                                });

                                videoPlayerController.play();
                              }),
                            );
                      }
                    } else {
                      predictionStatus = 3;
                      flutterTts
                          .speak(
                              'Couldn\'t recognize. Can you please repeat the pose?')
                          .whenComplete(
                            () =>
                                Future.delayed(const Duration(seconds: 3), () {
                              setState(() {
                                predictionStatus = 0;
                              });
                              videoPlayerController
                                  .seekTo(Duration(seconds: durationList[i]));
                              videoPlayerController.play();
                            }),
                          );
                    }

                    avgPoseTadasana = 0;
                    avgPoseTrikonasana = 0;
                  }

                  isDetecting = false;
                });
              }
            });
          }
        }
      });
  }

  Future _speak(String speechText) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    await flutterTts.speak(speechText);
  }

  loadModel() async {
    String res;

    res = await Tflite.loadModel(
      model: "assets/model/trikonasana.tflite",
      labels: "assets/model/trikonasana.txt",
      isAsset: true,
      numThreads: 2,
      useGpuDelegate: true,
    );

    print(res);
  }

  _setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  List<int> durationList = [35, 82, 104];
  List<int> indexPose = [1, 1, 0];

  Widget bottomSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black87,
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(10),
        //   topRight: Radius.circular(10),
        // ),
      ),
      height: screenSize.height * 0.35,
      child: Padding(
        padding: EdgeInsets.only(
          // bottom: screenSize.height / 20,
          left: screenSize.width / 30,
          right: screenSize.width / 30,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenSize.height / 40),
              child: Text(
                'Ai-Xercise',
                style: GoogleFonts.montserrat(
                    color: Colors.white38,
                    fontSize: 22,
                    letterSpacing: 5,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: screenSize.width / 5,
                      ),
                      child: Text(
                        _assistantText,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  Align(
                    child: ElevatedButton(
                      child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: const Text('Continue to next pose')),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(left: screenSize.width / 5),
                      child: Text(
                        _userText,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              maintainAnimation: true,
              maintainSize: true,
              maintainState: true,
              visible: _isListening,
              child: Padding(
                padding: EdgeInsets.only(top: screenSize.height / 40),
                child: const LinearProgressIndicator(
                  backgroundColor: Colors.black12,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(145, 144, 324, 432),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    isPredicted = false;
    loadModel();

    super.initState();

    _initVideoPlayer();

    _cameraController = CameraController(cameras[1], ResolutionPreset.high);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    predictionStatus = 0;
  }

  @override
  void dispose() {
    _cameraController.stopImageStream();
    _cameraController.dispose();
    videoPlayerController.dispose();
    Tflite?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      screenSize = MediaQuery.of(context).size;
    });
    // isPredicted = true;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: Text("TRIKONASANA POSE"),
        centerTitle: true,
      ),
      key: _key,
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // const Padding(
              //   padding: EdgeInsets.only(
              //     top: 10,
              //     bottom: 10,
              //   ),
              //   // child: Center(
              //   //   child: Text(
              //   //     "TRIANGLE POSE",
              //   //     style: TextStyle(
              //   //       color: Colors.white,
              //   //       fontSize: 30,
              //   //     ),
              //   //   ),
              //   // ),
              // ),
              videoPlayerController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(videoPlayerController),
                    )
                  : Container(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _cameraController.value.isInitialized
                      ? Flexible(
                          flex: 2,
                          child: Center(
                            child: SizedBox(
                              height: screenSize.height * 0.5,
                              width: screenSize.width / 1.17,
                              child: AspectRatio(
                                aspectRatio:
                                    _cameraController.value.aspectRatio,
                                child: CameraPreview(
                                  _cameraController,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(child: _predictionStatus()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _predictionStatus() {
    if (isPredicted) {
      // firstTime = false;
      videoPlayerController.setVolume(0);
      flutterTts.setSpeechRate(1.0);
      flutterTts.speak("Triangle pose successfully complete!");
      videoPlayerController.pause();
    }

    switch (predictionStatus) {
      case 1:
        return Column(
          children: const <Widget>[
            Text(
              'Processing',
              style: TextStyle(color: Colors.amber, fontSize: 16),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.amber,
                ),
              ),
            )
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Successful',
              style: TextStyle(color: Colors.greenAccent, fontSize: 16),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 25,
              width: 25,
              child: Icon(
                Icons.check_circle,
                color: Colors.greenAccent,
                size: 30,
              ),
            )
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Failed',
              style: TextStyle(color: Colors.redAccent, fontSize: 16),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 25,
              width: 25,
              child: Icon(
                Icons.close,
                color: Colors.redAccent,
                size: 30,
              ),
            )
          ],
        );
      default:
        return const Center(
          child: Text(
            'Follow the video',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        );
    }
  }
}
