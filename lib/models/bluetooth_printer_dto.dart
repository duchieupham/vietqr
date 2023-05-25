import 'package:uuid/uuid.dart';

class BluetoothPrinterDTO {
  final String id;
  final String name;
  final String address;
  final String userId;

  const BluetoothPrinterDTO({
    required this.id,
    required this.name,
    required this.address,
    required this.userId,
  });

  factory BluetoothPrinterDTO.fromJson(Map<String, dynamic> json) {
    return BluetoothPrinterDTO(
      id: json['id'] ?? const Uuid().v1(),
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['userId'] = userId;
    return data;
  }
}
