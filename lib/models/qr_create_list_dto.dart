import 'package:vierqr/models/qr_create_dto.dart';

class QRCreateListDTO {
  final List<QRCreateDTO> dtos;
  const QRCreateListDTO({required this.dtos});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['dtos'] = dtos.map((v) => v.toJson()).toList();
    return data;
  }
}
