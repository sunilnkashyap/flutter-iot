import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:lehonn_happy_v2/Routes.dart';

class AddDevicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new Scaffold(body: NewDevice());
}

class NewDevice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _NewDeviceState();
}

class _LoginData {
  String email = '';
  String password = '';
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

class DeviceList {
  List<DeviceItem> items;

  DeviceList() {
    items = new List();
  }

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}

class _NewDeviceState extends State<NewDevice> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final LocalStorage storage = new LocalStorage('devices');
  final DeviceList list = new DeviceList();
  _LoginData _data = new _LoginData();

  String _validatePassword(String value) {
    if (value.length < 9) {
      return 'Please enter valid mobile number.';
    }
    return null;
  }

  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.
      _addItem(_data.email, _data.password, true);
    }
  }

  _addItem(String title, String mobile, bool isActive) {
    setState(() {
      var oldList = storage.getItem('devices');
      var id = oldList == null ? 1 : oldList.length + 1;

      final item = new DeviceItem(
          id: id, title: title, mobile: mobile, isActive: isActive);
      list.items.add(item);

      if (oldList != null) {
        for (var i = 0; i < oldList.length; i++) {
          print(oldList[i]);
          final item = new DeviceItem(
              id: oldList[i]['id'],
              title: oldList[i]['title'],
              mobile: oldList[i]['mobile'],
              isActive: oldList[i]['isActive']);
          list.items.add(item);
        }
      }

      _saveToStorage();
    });
  }

  _saveToStorage() {
    storage.setItem('devices', list.toJSONEncodable());
    Routes.navigateTo(
      context,
      '/home'
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Devices'),
      ),
      body: new Container(
          
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            key: this._formKey,
            child: new ListView(
              children: <Widget>[
                new TextFormField(
                    keyboardType:
                        TextInputType.text, // Use email input type for emails.
                    decoration: new InputDecoration(
                        hintText: 'Main Motor', labelText: 'Device Name'),
                    onSaved: (String value) {
                      this._data.email = value;
                    }),
                new TextFormField(
                    // obscureText: true, // Use secure text for passwords.
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                        hintText: '9876543210',
                        labelText: 'Device Mobile Number'),
                    validator: this._validatePassword,
                    onSaved: (String value) {
                      this._data.password = value;
                    }),
                new Container(
                  width: screenSize.width,
                  child: new RaisedButton(
                    child: new Text(
                      'Save',
                      style: new TextStyle(color: Colors.white),
                    ),
                    onPressed: this.submit,
                    color: Colors.blue,
                  ),
                  margin: new EdgeInsets.only(top: 20.0),
                )
              ],
            ),
          )
        ),
    );
  }
}