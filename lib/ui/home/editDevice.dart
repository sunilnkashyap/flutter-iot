
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:lehonn_happy_v2/Routes.dart';

class EditDevice extends StatefulWidget {
  final id;
  EditDevice(this.id);
  @override
  State<StatefulWidget> createState() => new _EditDeviceState(this.id);
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

class _EditDeviceState extends State<EditDevice> {
  final id;
  _EditDeviceState(this.id);
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final LocalStorage storage = new LocalStorage('devices');
  final DeviceList list = new DeviceList();
  _LoginData _data = new _LoginData();

  bool isInit = false;
  final _titleEditingCtrl = TextEditingController();
  final _mobileEditingCtrl = TextEditingController();

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

  void delete(){

    var oldList = storage.getItem('devices');
    if (oldList != null) {
        for (var i = 0; i < oldList.length; i++) {
          if(oldList[i]['id'].toString() != id[0].toString()){
          final item = new DeviceItem(
              id: oldList[i]['id'],
              title: oldList[i]['title'],
              mobile: oldList[i]['mobile'],
              isActive: oldList[i]['isActive']);
          list.items.add(item);
        }
        }
      }

      _saveToStorage();

  }

  _addItem(String title, String mobile, bool isActive) {
    setState(() {
      var oldList = storage.getItem('devices');

      if (oldList != null) {
        for (var i = 0; i < oldList.length; i++) {
          if(oldList[i]['id'].toString() != id[0].toString()){
            final item = new DeviceItem(
                id: oldList[i]['id'],
                title: oldList[i]['title'],
                mobile: oldList[i]['mobile'],
                isActive: oldList[i]['isActive']);
            list.items.add(item);
          } else {
            final item = new DeviceItem(
                id: oldList[i]['id'],
                title: _data.email,
                mobile: _data.password,
                isActive: oldList[i]['isActive']);
            list.items.add(item);
          }
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

  void _titleEditingCtrlListener(){
    this._data.email = _titleEditingCtrl.text;
  }

  void _mobileEditingCtrlListener(){
    this._data.password = _mobileEditingCtrl.text;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

_titleEditingCtrl.addListener(_titleEditingCtrlListener);
_mobileEditingCtrl.addListener(_mobileEditingCtrlListener);
    /* get edited data */

if(isInit == false){
var oldDevices = storage.getItem('devices');
    var editDevice;
    //print(oldDevices);
    
    if (oldDevices != null) {
        for (var i = 0; i < oldDevices.length; i++) {
          if(oldDevices[i]['id'].toString() == id[0].toString()){
            editDevice = oldDevices[i];
          }
        }
      }

      _titleEditingCtrl.text = editDevice['title'];
      _mobileEditingCtrl.text = editDevice['mobile'];

      isInit = true;
}
    


    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Update Devices'),
      ),
      body: new Container(
          
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            key: this._formKey,
            child: new ListView(
              children: <Widget>[
                new TextFormField(
                    controller: _titleEditingCtrl,
                    keyboardType: TextInputType.text, // Use email input type for emails.
                    decoration: new InputDecoration(hintText: 'Main Motor', labelText: 'Device Name'),
                    onSaved: (String value) {
                      this._data.email = value;
                    }),
                new TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _mobileEditingCtrl,
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
                      'Update',
                      style: new TextStyle(color: Colors.white),
                    ),
                    onPressed: this.submit,
                    color: Colors.blue,
                  ),
                  margin: new EdgeInsets.only(top: 20.0),
                ),
                new Container(
                  width: screenSize.width,
                  child: new RaisedButton(
                    child: new Text(
                      'Delete',
                      style: new TextStyle(color: Colors.white),
                    ),
                    onPressed: this.delete,
                    color: Colors.red,
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