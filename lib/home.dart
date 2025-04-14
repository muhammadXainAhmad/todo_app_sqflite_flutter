import 'package:flutter/material.dart';
import 'package:todo_app_sqflite/Constants/constants.dart';
import 'package:todo_app_sqflite/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final todoController = TextEditingController();
  String taskTitle = "All Tasks";
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
    allItems = allItems.reversed.toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(
          context,
        ).requestFocus(FocusNode()); // This will unfocus the current focus
      },
      child: Scaffold(
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
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 10,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  taskTitle,
                  style: const TextStyle(
                    color: txtClr,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Expanded(
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
                      onTap: () async {
                        int currentValue =
                            allItems[index][DBHelper.COLUMN_TODO_ISDONE];
                        int toggledValue = currentValue == 0 ? 1 : 0;
                        await dbRef!.updateItem(
                          mId: allItems[index][DBHelper.COLUMN_TODO_ID],
                          mText: allItems[index][DBHelper.COLUMN_TODO_TEXT],
                          mIsDone: toggledValue,
                        );
                        getItems();
                      },
                      shape: myBtn,
                      tileColor: wgClr,
                      leading: Icon(Icons.check_box, color: drawerClr),

                      title: Text(
                        allItems[index][DBHelper.COLUMN_TODO_TEXT],
                        style: TextStyle(
                          color: txtClr,
                          fontSize: 16,
                          decoration:
                              allItems[index][DBHelper.COLUMN_TODO_ISDONE] == 1
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
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
                              onPressed: () async {
                                bool check = await dbRef!.deleteItem(
                                  mId: allItems[index][DBHelper.COLUMN_TODO_ID],
                                );
                                if (check) {
                                  getItems();
                                }
                              },
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
            ),
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
                          controller: todoController,

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
                          var todoText = todoController.text;
                          if (todoText.isNotEmpty) {
                            bool check = await dbRef!.addItem(
                              mId:
                                  DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                              mText: todoController.text,
                              mIsDone: false,
                            );
                            if (check) {
                              getItems();
                              todoController.clear();
                            }
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
      ),
    );
  }
}
