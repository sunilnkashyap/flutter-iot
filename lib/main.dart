import 'package:flutter/material.dart';
import 'package:lehonn_happy_v2/Routes.dart';
import 'package:lehonn_happy_v2/ui/home/HomePage.dart';

void main() {
  Routes.initRoutes();
  runApp(new MaterialApp(
    title: "Lehonn Happy",
    home: new HomePage(),
  ));
}





