import 'package:flutter/material.dart';
import 'package:todo_app_sqflite/Constants/constants.dart';
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
      backgroundColor: bgClr,
      appBar: AppBar(
        backgroundColor: bgClr,
        actions: [
          Image.asset("assets/faces1.png", height: 40, width: 40),
          const SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          allItems.isNotEmpty
              ? Expanded(
                child: ListView.builder(
                  itemCount: allItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 10,
                        bottom: 10,
                      ),
                      child: ListTile(
                        shape: myBtn,
                        tileColor: wgClr,
                        leading: Icon(Icons.check_box, color: drawerClr),

                        title: Text(
                          allItems[index][DBHelper.COLUMN_TODO_TEXT],
                          style: TextStyle(
                            color: txtClr,
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 3,
                            decorationColor: bgClr,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: myBoxDel,
                              child: IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {},
                                icon: const Icon(Icons.edit),
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: myBoxEdit,
                              child: IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {},
                                icon: const Icon(Icons.delete),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
              : Center(child: Text("Nothing to show here")),
          Container(
            decoration: myBox,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                  bottom: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          focusedBorder: myBorder,
                          enabledBorder: myBorder,
                          filled: true,
                          fillColor: wgClr,
                          hintText: "Add a new item to do",
                          hintStyle: const TextStyle(color: txtClr),
                          prefixIcon: const Icon(
                            Icons.edit_note_rounded,
                            color: txtClr,
                            size: 30,
                          ),
                        ),
                        style: const TextStyle(color: txtClr, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: wgClr,
                        minimumSize: const Size(20, 56),
                        shape: myBtn,
                      ),
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
                      child: const Icon(Icons.add, color: txtClr),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
