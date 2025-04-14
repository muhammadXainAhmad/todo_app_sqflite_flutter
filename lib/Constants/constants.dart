import 'package:flutter/material.dart';

const Color bgClr = Colors.black;
final Color wgClr = Colors.grey.shade800;
const Color txtClr = Colors.white;
final Color drawerClr = Colors.blueAccent.shade400;

// TextFields
final myBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(20));
final myBorder2 = OutlineInputBorder(
  borderRadius: BorderRadius.circular(20),
  borderSide: BorderSide(color: drawerClr, width: 2),
);

//Container
var myBox = BoxDecoration(
    color: drawerClr,
    borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20), topRight: Radius.circular(20)));

final myBoxDel =
    BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10));

//Buttons
final myBtn = RoundedRectangleBorder(
    side: const BorderSide(color: Colors.black),
    borderRadius: BorderRadius.circular(20));
