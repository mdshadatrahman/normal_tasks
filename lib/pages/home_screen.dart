import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:normal_tasks/models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _newTaskContent;
  Box? _box;

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: tasksView(width: width, height: height),
      ),
      floatingActionButton: fab(),
    );
  }

  FloatingActionButton fab() {
    return FloatingActionButton(
      onPressed: addTask,
      child: const Icon(
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
              child: const CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _tasksList({required double height, required double width}) {
    List tasks = _box!.values.toList();

    return SizedBox(
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
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = TextButton(
      child: const Text(
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
      title: const Text(
        "Do you really want to delete?",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
      content: Text(
        task.content,
        style: const TextStyle(
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
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add new task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onSubmitted: (val) {
                  // if (_newTaskContent != null) {
                  //   Task newTask = Task(
                  //     content: _newTaskContent!,
                  //     done: false,
                  //     timestamp: DateFormat.yMMMMEEEEd()
                  //         .format(DateTime.now())
                  //         .toString(),
                  //   );
                  //   _box?.add(newTask.toMap());
                  //   setState(() {
                  //     _newTaskContent = null;
                  //     Navigator.pop(context);
                  //   });
                  // }
                },
                onChanged: (val) {
                  setState(() {
                    _newTaskContent = val;
                  });
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _newTaskContent = null;
                        Navigator.pop(context);
                      });
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_newTaskContent != null) {
                        Task newTask = Task(
                          content: _newTaskContent!,
                          done: false,
                          timestamp: DateFormat.yMMMMEEEEd()
                              .format(DateTime.now())
                              .toString(),
                        );
                        _box?.add(newTask.toMap());
                        setState(() {
                          _newTaskContent = null;
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
