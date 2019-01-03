import 'package:lehonn_happy_v2/model/Device.dart';
class DeviceDao {

  static final List<Device> devices = [
    const Device(
      id: "1",
      title: "Device 1",
      mobile: "9876543210",
      isActive: false
    ),
    const Device(
      id: "2",
      title: "Device 2",
      mobile: "9876543210",
      isActive: false
    ),
    const Device(
      id: "3",
      title: "Device 3",
      mobile: "9876543210",
      isActive: false
    ),
    const Device(
      id: "4",
      title: "Device 4",
      mobile: "9876543210",
      isActive: false
    ),
  ];

  static Device getDeviceById(id) {
    return devices
        .where((p) => p.id == id)
        .first;
  }
}