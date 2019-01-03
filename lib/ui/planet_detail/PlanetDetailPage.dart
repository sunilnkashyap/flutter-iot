import 'package:flutter/material.dart';
import 'package:lehonn_happy_v2/model/Device.dart';
import 'package:lehonn_happy_v2/model/Devices.dart';
import 'package:lehonn_happy_v2/ui/planet_detail/DetailAppBar.dart';
import 'package:lehonn_happy_v2/ui/planet_detail/PlanetDetailBody.dart';

class PlanetDetailPage extends StatelessWidget {

  final Device planet;

  PlanetDetailPage(String id) :
    planet = DeviceDao.getDeviceById(id);



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new PlanetDetailBody(planet),
          new DetailAppBar(),
        ],
      ),
    );
  }
}
