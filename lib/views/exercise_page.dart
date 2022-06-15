import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mynotes/constant/constants.dart';

bool isPredicted = true;

int predictionStatus = 0;

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExercisePage(),
    );
  }
}

class ExercisePage extends StatefulWidget {
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  //Variables
  int selectedIconIndex = 2;

  late List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  int i = 0;

  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for caputred image

  late VideoPlayerController vcontroller;
  late CameraController _cameraController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    loadCamera();
    vcontroller = VideoPlayerController.asset('assets/videos/yogapose1.mp4');
    _initializeVideoPlayerFuture = vcontroller.initialize();
    vcontroller.play();
    vcontroller.setLooping(true);
    vcontroller.setVolume(1.0);

    isPredicted = false;
    loadModel();
    predictionStatus = 0;
    super.initState();
  }

//LOAD CAMERA INTO APPS
  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![1], ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("No any camera found");
    }
  }

//LOAD TFLITE MODEL
  loadModel() async {
    String? res;

    res = await Tflite.loadModel(
      model: "assets/model/trikonasana.tflite",
      labels: "assets/model/trikonasana.txt",
      isAsset: true,
      numThreads: 2,
      useGpuDelegate: true,
    );

    print(res);
  }

  //SET RECOGNITION
  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  List<int> indexPose = [1, 1, 0];

  @override
  void dispose() {
    controller?.dispose();
    vcontroller.dispose();
    Tflite?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      backgroundColor: const Color(0xfff5ceb8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: vcontroller.value.aspectRatio,
                  child: VideoPlayer(vcontroller),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
            // height: MediaQuery.of(context).size.height * 0.25,
            // width: MediaQuery.of(context).size.width,
            // color: const Color.fromARGB(255, 208, 129, 83),
            // child: Container(
            //   margin: const EdgeInsets.only(right: 40, top: 20, bottom: 20),
            //   alignment: Alignment.centerLeft,
            //   decoration: const BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage('assets/images/path.png'),
            //         fit: BoxFit.contain),
            //   ),
            // ),
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            height: 478,
                            width: 400,
                            child: controller == null
                                ? const Center(child: Text("Loading Camera..."))
                                : !controller!.value.isInitialized
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : CameraPreview(controller!),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
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
}
