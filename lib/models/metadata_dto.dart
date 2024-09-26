class MetaDataDTO {
  int? page;
  int? size;
  int? totalPage;
  int? total;

  MetaDataDTO({this.page, this.size, this.totalPage, this.total});

  factory MetaDataDTO.fromJson(dynamic json) {
    return MetaDataDTO(
      page: json['page'],
      size: json['size'],
      totalPage: json['totalPage'],
      total: json['totalElement'],
    );
  }
}
