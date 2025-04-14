import 'package:flutter/material.dart';
import 'package:todo_app_sqflite/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allItems = [];
  DBHelper? dbRef;
  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getItems();
  }

  void getItems() async {
    allItems = await dbRef!.getAllItems();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TO DO")),
      body: Center(
        child: Column(
          children: [
            allItems.isNotEmpty
                ? Expanded(
                  child: ListView.builder(
                    itemCount: allItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text(allItems[index][DBHelper.COLUMN_TODO_ID]),
                        title: Text(allItems[index][DBHelper.COLUMN_TODO_TEXT]),
                        subtitle: Text(
                          allItems[index][DBHelper.COLUMN_TODO_ISDONE]
                              .toString(),
                        ),
                      );
                    },
                  ),
                )
                : Center(child: Text("Nothing to show here")),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool check = await dbRef!.addItem(
            mId: DateTime.now().millisecondsSinceEpoch.toString(),
            mText: "Wash Car",
            mIsDone: false,
          );
          if (check) {
            getItems();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
