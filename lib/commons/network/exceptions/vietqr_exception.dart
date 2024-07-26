import 'package:dio/dio.dart';

class VietQrException implements Exception {
  final String message;
  final String prefix;

  VietQrException({required this.message, required this.prefix});

  @override
  String toString() {
    return message;
  }

  String formattedString() {
    return '[$prefix] $message';
  }
}

class FetchDataException extends VietQrException {
  FetchDataException({required super.message})
      : super(
          prefix: '',
        );
}

class BadRequestException extends VietQrException {
  BadRequestException({required super.message})
      : super(
          prefix: 'Invalid Request',
        );
}

class UnauthorisedException extends DioException {
  UnauthorisedException({
    required super.requestOptions,
    super.response,
  }) : super(
          type: DioExceptionType.unknown,
        );
}
