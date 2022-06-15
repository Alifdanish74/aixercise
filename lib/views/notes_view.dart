import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constant/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mynotes/views/exercise_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mynotes/constant/constants.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  int selectedIconIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    categoryWidget('img1', "Tadasana"),
                    categoryWidget('img2', "Virabhadrasana I"),
                    categoryWidget('img3', "Virabhadrasana II"),
                    categoryWidget('img4', "Utthita Parvakonasana"),
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
      case 'Tadasana':
        {
          // statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => ExercisePage()));
        }
        break;

      case 'Virabhadrasana I':
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => ExercisePage()));
        }
        break;

      case 'Virabhadrasana II':
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => ExercisePage()));
        }
        break;
      case 'Utthita Parvakonasana':
        {
          //statements;
          Navigator.push(context,
              CupertinoPageRoute(builder: (redContext) => ExercisePage()));
        }
        break;

      default:
        {
          throw Exception('Path $title not supported');
        }
    }
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
