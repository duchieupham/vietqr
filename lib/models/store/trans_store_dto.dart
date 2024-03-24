import 'package:vierqr/models/trans_dto.dart';

class TransStoreDTO {
  final int page;
  final int size;
  final int totalPage;
  final int totalElement;
  List<TransDTO> items;

  TransStoreDTO({
    this.page = 0,
    this.size = 0,
    this.totalPage = 0,
    this.totalElement = 0,
    this.items = const [],
  });

  factory TransStoreDTO.fromJson(Map<String, dynamic> json) => TransStoreDTO(
        page: json["page"],
        size: json["size"],
        totalPage: json["totalPage"],
        totalElement: json["totalElement"],
        items: json["items"] == null
            ? []
            : List<TransDTO>.from(
                json["items"]!.map((x) => TransDTO.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "size": size,
        "totalPage": totalPage,
        "totalElement": totalElement,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}
