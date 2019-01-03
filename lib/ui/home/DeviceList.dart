import 'package:flutter/material.dart';
import 'package:lehonn_happy_v2/Theme.dart' as Theme;
import 'package:localstorage/localstorage.dart';
import 'package:sms/sms.dart';
import 'package:lehonn_happy_v2/Routes.dart';

class DeviceList extends StatelessWidget {

  List<DeviceItem> items;

  DeviceList() {
    items = new List();
  }

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }

  final LocalStorage storage = new LocalStorage('devices');

  Widget get _loadingView {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (storage.getItem('devices') == null) {
      print(storage.getItem('devices'));
    }

    return FutureBuilder(
      future: storage.ready,
      builder: (BuildContext context, snapshot) {
        if (snapshot.data == true) {
          final testData = storage.getItem('devices') != null
              ? storage.getItem('devices')
              : [];
          return new Flexible(
            child: new Container(
              color: Theme.Colors.planetPageBackground,
              child: new ListView.builder(
                itemExtent: 160.0,
                itemCount: testData.length,
                itemBuilder: (_, index) => new DeviceRow1(testData[index]),
              ),
            ),
          );
        } else {
          return _loadingView;
        }
      },
    );
  }
}

class DeviceRow1 extends StatefulWidget {
  final device;

  DeviceRow1(this.device);
  @override
  State<StatefulWidget> createState() => new _DeviceRow1State(device);
}
class DeviceItem {
  int id;
  String title;
  String mobile;
  bool isActive;

  DeviceItem({this.id, this.title, this.mobile, this.isActive});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['id'] = id;
    m['title'] = title;
    m['mobile'] = mobile;
    m['isActive'] = isActive;

    return m;
  }
}

class _DeviceRow1State extends State<DeviceRow1> {
  final device;
  final LocalStorage storage = new LocalStorage('devices');
  _DeviceRow1State(this.device);
  final DeviceList list = new DeviceList();
  final SmsSender sender = new SmsSender();

  sendSMS(context, mobile, msg, device) {
    SmsMessage message = new SmsMessage(mobile, msg);
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        final scaffold = Scaffold.of(context);
        scaffold.showSnackBar(
          SnackBar(
            content: const Text('SMS Sent to Device.'),
            action: SnackBarAction(
                label: 'OKAY', onPressed: scaffold.hideCurrentSnackBar),
          ),
        );
      } else if (state == SmsMessageState.Delivered) {

        setState(() {
          var oldList = storage.getItem('devices');
          if (oldList != null) {
            this.device['isActive'] =  msg == 'ON' ? true : false;
            for (var i = 0; i < oldList.length; i++) {
              if(oldList[i]['id'].toString() != device['id'].toString()){
                print('!-!-!- not get -!-!-!-!');
                final item = new DeviceItem(
                    id: oldList[i]['id'],
                    title: oldList[i]['title'],
                    mobile: oldList[i]['mobile'],
                    isActive: oldList[i]['isActive']);
                list.items.add(item);
              } else {
                print('!-!-!- aget -!-!-!-!');
                final item = new DeviceItem(
                    id: oldList[i]['id'],
                    title: oldList[i]['title'],
                    mobile: oldList[i]['mobile'],
                    isActive: msg == 'ON' ? true : false);
                list.items.add(item);
              }
            }
          }

      _saveToStorage();

          print(this.device);
        });

        final scaffold = Scaffold.of(context);
        scaffold.showSnackBar(
          SnackBar(
            content: const Text('SMS Received by Device.'),
            action: SnackBarAction(
                label: 'OKAY', onPressed: scaffold.hideCurrentSnackBar),
          ),
        );
      }
    });
    sender.sendSms(message);
  }

  _saveToStorage() {
    storage.setItem('devices', list.toJSONEncodable());
    print(list);
  }
  @override
  Widget build(BuildContext context) {
    final deviceCard = new Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
      decoration: new BoxDecoration(
        color: Theme.Colors.planetCard,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
              color: Colors.black,
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
            new Text(this.device['title'], style: Theme.TextStyles.planetTitle),
            new Text(this.device['mobile'],
                style: Theme.TextStyles.planetLocation),
            new Container(
                color: const Color(0xFF00C6FF),
                width: 24.0,
                height: 1.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0)),
            new Row(
              children: <Widget>[
                Expanded(
                    child: new Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: new RaisedButton(
                      child: Column(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[Text("ON")],
                      ),
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      padding: const EdgeInsets.all(5.0),
                      textColor: this.device['isActive'] ? Colors.white : Colors.black,
                      color: this.device['isActive'] ? Colors.green : Colors.green[100],
                      onPressed: () {
                        print(this.device['title']);
                        sendSMS(context, this.device['mobile'], 'ON', this.device);
                      }),
                )),
                Expanded(
                    child: new Container(
                  margin: const EdgeInsets.only(right: 20.0),
                  child: new RaisedButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    padding: const EdgeInsets.all(5.0),
                    textColor: this.device['isActive'] ? Colors.black :Colors.white,
                    color: this.device['isActive'] ? Colors.red[100] : Colors.red,
                    onPressed: () {
                      print(this.device['title']);
                      sendSMS(context, this.device['mobile'], 'OFF', this.device);
                    },
                    child: new Text("OFF"),
                  ),
                ))
              ],
            )
          ],
        ),
      ),
    );

    return GestureDetector(
      // When the child is tapped, show a snackbar
      onDoubleTap: () {
        var id = this.device['id'];
        Routes.navigateTo(context, '/edit/' + id.toString());
      },
      // Our Custom Button!
      child: new Container(
        height: 500.0,
        margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: new Stack(
          children: <Widget>[deviceCard],
        ),
      ),
    );
  }
}
