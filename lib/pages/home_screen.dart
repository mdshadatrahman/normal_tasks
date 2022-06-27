import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:normal_tasks/models/task.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  late double height, width;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _taskContentController = TextEditingController();
  String? _newTaskContent;
  Box? _box;

  @override
  dispose() {
    super.dispose();
    _taskContentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.height = MediaQuery.of(context).size.height;
    widget.width = MediaQuery.of(context).size.width;
    print("Input Val: $_newTaskContent");
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: tasksView(width: widget.width, height: widget.height),
      ),
      floatingActionButton: fab(),
    );
  }

  FloatingActionButton fab() {
    return FloatingActionButton(
      onPressed: addTask,
      child: Icon(
        Icons.add,
      ),
    );
  }

  Widget tasksView({required double height, required double width}) {
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _box = snapshot.data;
          return _tasksList(height: height, width: width);
        } else {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: height * 0.1),
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _tasksList({required double height, required double width}) {
    // Task _newTask = Task(
    //   content: 'Go to gym',
    //   done: false,
    //   timestamp: DateTime.now().toString(),
    // );
    // _box?.add(_newTask.toMap());
    List tasks = _box!.values.toList();

    return Container(
      height: height * 0.9,
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          var task = Task.fromMap(tasks[index]);

          return ListTile(
            title: Text(
              task.content,
              style: TextStyle(
                decoration: task.done ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              task.timestamp,
            ),
            trailing: Checkbox(
              onChanged: (newVal) {
                task.done = !task.done;
                _box!.putAt(index, task.toMap());
                setState(() {});
              },
              value: task.done,
            ),
            onLongPress: () {
              setState(() {});
              showAlertDialog(context, task, index);
            },
          );
        },
      ),
    );
  }

  showAlertDialog(BuildContext context, Task task, int index) {

    Widget noButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        _box!.deleteAt(index);
        Navigator.of(context).pop();
        setState(() {});
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Do you really want to delete?",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
      content: Text(
        task.content,
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
        ),
      ),
      actions: [
        yesButton,
        noButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void addTask() {
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          title: const Text('Add new task'),
          content: TextField(
            onSubmitted: (val) {
              if (_newTaskContent != null) {
                Task _newTask = Task(
                  content: _newTaskContent!,
                  done: false,
                  timestamp: DateTime.now().toString(),
                );
                _box?.add(_newTask.toMap());
                setState(() {
                  _newTaskContent = null;
                  Navigator.pop(context);
                });
              }
            },
            onChanged: (val) {
              setState(() {
                _newTaskContent = val;
              });
            },
          ),
        );
      },
    );
  }
}
