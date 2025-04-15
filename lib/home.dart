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
  List<Map<String, dynamic>> filteredItems = [];
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
    runFilter("");
    if (taskTitle == "Completed Tasks") {
      filteredItems =
          allItems
              .where((item) => item[DBHelper.COLUMN_TODO_ISDONE] == 1)
              .toList();
    } else if (taskTitle == "Incomplete Tasks") {
      filteredItems =
          allItems
              .where((item) => item[DBHelper.COLUMN_TODO_ISDONE] == 0)
              .toList();
    } else {
      filteredItems = allItems;
    }
    setState(() {});
  }

  void runFilter(String searchWord) {
    if (searchWord.isEmpty) {
      filteredItems = allItems;
    } else {
      filteredItems =
          allItems
              .where(
                (item) => item[DBHelper.COLUMN_TODO_TEXT]
                    .toLowerCase()
                    .contains(searchWord.toLowerCase()),
              )
              .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: bgClr,
        appBar: AppBar(
          backgroundColor: bgClr,
          actions: [
            Image.asset("assets/faces1.png", height: 40, width: 40),
            const SizedBox(width: 15),
          ],
          iconTheme: const IconThemeData(color: txtClr, size: 30),
        ),
        drawer: Drawer(
          backgroundColor: bgClr,
          width: 300,
          child: Column(
            children: [
              Container(
                color: drawerClr,
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Image.asset("assets/faces1.png", height: 100, width: 100),
                    const SizedBox(height: 15),
                    const Text(
                      'Muhammad Xain Ahmad',
                      style: TextStyle(color: txtClr, fontSize: 18),
                    ),
                    const Text(
                      'xain@email.com',
                      style: TextStyle(color: txtClr, fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      taskTitle = "All Tasks";
                    });
                    getItems();
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.library_books_rounded, color: txtClr),
                      SizedBox(width: 10),
                      Text(
                        "All Tasks",
                        style: TextStyle(color: txtClr, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(color: Colors.black, indent: 40, endIndent: 40),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      taskTitle = "Completed Tasks";
                    });
                    getItems();
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_box, color: txtClr),
                      SizedBox(width: 10),
                      Text(
                        "Completed Tasks",
                        style: TextStyle(color: txtClr, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(color: Colors.black, indent: 40, endIndent: 40),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      taskTitle = "Incomplete Tasks";
                    });
                    getItems();
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_box_outline_blank, color: txtClr),
                      SizedBox(width: 10),
                      Text(
                        "Incomplete Tasks",
                        style: TextStyle(color: txtClr, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
              child: TextField(
                onChanged: runFilter,
                decoration: InputDecoration(
                  enabledBorder: myBorder,
                  focusedBorder: myBorder2,
                  filled: true,
                  fillColor: wgClr,
                  hintText: "Search",
                  hintStyle: const TextStyle(color: txtClr),
                  prefixIcon: const Icon(Icons.search, color: txtClr, size: 20),
                ),
                style: const TextStyle(color: txtClr, fontSize: 16),
              ),
            ),
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
                itemCount: filteredItems.length,
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
                            filteredItems[index][DBHelper.COLUMN_TODO_ISDONE];
                        int toggledValue = currentValue == 0 ? 1 : 0;
                        await dbRef!.updateItem(
                          mId: filteredItems[index][DBHelper.COLUMN_TODO_ID],
                          mText:
                              filteredItems[index][DBHelper.COLUMN_TODO_TEXT],
                          mIsDone: toggledValue,
                        );
                        getItems();
                      },
                      shape: myBtn,
                      tileColor: wgClr,
                      leading: Icon(
                        filteredItems[index][DBHelper.COLUMN_TODO_ISDONE] == 1
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: drawerClr,
                      ),

                      title: Text(
                        filteredItems[index][DBHelper.COLUMN_TODO_TEXT],
                        style: TextStyle(
                          color: txtClr,
                          fontSize: 16,
                          decoration:
                              filteredItems[index][DBHelper
                                          .COLUMN_TODO_ISDONE] ==
                                      1
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
                                  mId:
                                      filteredItems[index][DBHelper
                                          .COLUMN_TODO_ID],
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
