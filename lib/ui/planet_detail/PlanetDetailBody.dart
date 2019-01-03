import 'package:flutter/material.dart';
import 'package:lehonn_happy_v2/Theme.dart' as Theme;
import 'package:lehonn_happy_v2/model/Device.dart';

class PlanetDetailBody extends StatelessWidget {
  final Device planet;

  PlanetDetailBody(this.planet);


  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          color: Theme.Colors.planetPageBackground,
          child: new Center(
            child: new Hero(
              tag: 'planet-icon-${planet.id}',
              
            ),
          ),
        ),
      ]
    );
  }
}