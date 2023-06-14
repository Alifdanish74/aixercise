import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aixercise/page/home_page.dart';
import 'package:aixercise/provider/todos.dart';

import 'constant/routes.dart';
import 'home_view.dart';
import 'predictor_page.dart';

List<CameraDescription> cameras = [];

Future main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.code);
  }

  runApp(MyApp());
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class MyApp extends StatelessWidget {
  static final String title = 'Todo App With Firebase';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => TodosProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          theme: ThemeData(
            primaryColor: Color.fromARGB(255, 220, 139, 91),
            scaffoldBackgroundColor: Color.fromARGB(255, 238, 246, 246),
          ),
          home: HomePage(),
        ),
      );
}
