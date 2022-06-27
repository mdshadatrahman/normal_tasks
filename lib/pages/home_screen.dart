import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  late double height, width;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    widget.height = MediaQuery.of(context).size.height;
    widget.width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text('My Tasks'),
            centerTitle: true,
            expandedHeight: 0,
            floating: true,
            pinned: false,
            elevation: 10,
          ),
          SliverList(
            delegate: _tasksList(height: widget.height, width: widget.width),
            ),
        ],
      ),
      floatingActionButton: fab(),
    );
  }

  FloatingActionButton fab() {
    return FloatingActionButton(
      onPressed: (){},
      child: Icon(Icons.add,),
    );
  }
  SliverChildListDelegate _tasksList({required double height, required double width}){
    return SliverChildListDelegate(
      [
        Container(
          height: height *0.9,
          child: ListView(
            children: [
              ListTile(
                title: Text(
                  'Do nothing',
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                subtitle: Text(DateTime.now().toString()),
                trailing: Checkbox(
                  onChanged: (newVal){
                    setState((){

                    });
                  },
                  value: false,
                ),
              )
            ],
          ),
        ),
      ]
    );
  }
}
