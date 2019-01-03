import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lehonn_happy_v2/ui/planet_detail/PlanetDetailPage.dart';
import 'package:lehonn_happy_v2/ui/home/addDevice.dart';
import 'package:lehonn_happy_v2/ui/home/HomePage.dart';
import 'package:lehonn_happy_v2/ui/home/editDevice.dart';

class Routes {
  static final Router _router = new Router();


  static var planetDetailHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new EditDevice(params["deid"]);
    });

  static var addDeviceHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new AddDevicePage();
    });

  static var homePageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new HomePage();
    });

  static void initRoutes() {
    _router.define("/edit/:deid", handler: planetDetailHandler);
    _router.define("/new", handler: addDeviceHandler);
    _router.define("/home", handler: homePageHandler);
  }
  

  static void navigateTo(context, String route, {TransitionType transition}) {
    _router.navigateTo(context, route, transition: transition);
  }

}


