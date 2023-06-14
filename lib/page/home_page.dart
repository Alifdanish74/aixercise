import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aixercise/api/firebase_api.dart';
import 'package:aixercise/model/todo.dart';
import 'package:aixercise/provider/todos.dart';
import 'package:aixercise/widget/dailyparking_dialog_widget.dart';
import 'package:aixercise/widget/completed_list_widget.dart';
import 'package:aixercise/widget/todo_list_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../home_view.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      TodoListWidget(),
      HomeView(),
      CompletedListWidget(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Ai-Xercise'),
        backgroundColor: const Color.fromARGB(255, 208, 129, 83),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        selectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: (index) => setState(() {
          selectedIndex = index;
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_outlined),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.personWalkingArrowLoopLeft),
            label: 'Exercise',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done, size: 28),
            label: 'Completed',
          ),
        ],
      ),
      body: HomeView(),
      // StreamBuilder<List<Todo>>(
      //   stream: FirebaseApi.readTodos(),
      //   builder: (context, snapshot) {
      //     switch (snapshot.connectionState) {
      //       case ConnectionState.waiting:
      //         return Center(child: CircularProgressIndicator());
      //       default:
      //         if (snapshot.hasError) {
      //           return buildText('Something Went Wrong Try later');
      //         } else {
      //           final todos = snapshot.data;

      //           final provider = Provider.of<TodosProvider>(context);
      //           provider.setTodos(todos);

      //           return tabs[selectedIndex];
      //         }
      //     }
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.black,
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddTodoDialogWidget(),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}

Widget buildText(String text) => Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
