import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lehonn_happy_v2/Routes.dart';
import 'package:lehonn_happy_v2/Theme.dart' as Theme;
import 'package:lehonn_happy_v2/model/Device.dart';

class DeviceRow extends StatelessWidget {

  final Device planet;

  DeviceRow(this.planet);

  @override
  Widget build(BuildContext context) {

    final planetCard = new Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
      decoration: new BoxDecoration(
        color: Theme.Colors.planetCard,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(color: Colors.black,
            blurRadius: 8.0,
            offset: new Offset(0.0, 5.0))
        ],
      ),
      child: new Container(
        margin: const EdgeInsets.only(top: 16.0, left: 16.0),
        constraints: new BoxConstraints.expand(),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(planet.title, style: Theme.TextStyles.planetTitle),
            new Text(planet.mobile, style: Theme.TextStyles.planetLocation),
            new Container(
              color: const Color(0xFF00C6FF),
              width: 24.0,
              height: 1.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0)
            ),
            new Row(
              children: <Widget>[
                 new RaisedButton(
                    padding: const EdgeInsets.all(10.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: (){print('test');},
                    child: new Text("Add"),
                  ),
                  new RaisedButton(
                    padding: const EdgeInsets.all(10.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: (){print('test');},
                    child: new Text("Add"),
                  )
                
              ],
              
            )
          ],
        ),
      ),
    );

    return new Container(
      height: 120.0,
      margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: new FlatButton(
        onPressed: () => _navigateTo(context, planet.id),

        child: new Stack(
          children: <Widget>[
            planetCard
          ],
        ),
      ),
    );
  }

  _navigateTo(context, String id) {
    Routes.navigateTo(
      context,
      '/detail/${planet.id}',
      transition: TransitionType.fadeIn
    );
  }
}

