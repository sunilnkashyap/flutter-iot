import 'package:flutter/material.dart';
import 'package:lehonn_happy_v2/ui/home/GradientAppBar.dart';
import 'package:lehonn_happy_v2/ui/home/DeviceList.dart';
import 'package:lehonn_happy_v2/Routes.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new HomePageBody(),
    );
  }
}

class HomePageBody extends StatefulWidget {
  @override
  _HomePageBodyState createState() => new _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {


  @override
  Widget build(BuildContext context) => new Scaffold(
    body: new Column(
      children: <Widget>[
         new GradientAppBar("Lehonn Happy"),
        new DeviceList(),
      ],
    ),
    floatingActionButton: new FloatingActionButton(
      elevation: 0.0,
      child: new Icon(Icons.add),
      // backgroundColor: new Color(0xFFE57373),
      onPressed: () => _addDevicePage(context)
    )
  );

 _addDevicePage(context) {
    Routes.navigateTo(
      context,
      '/new'
    );
  }
}






