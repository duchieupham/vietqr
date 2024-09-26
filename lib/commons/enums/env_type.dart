// ignore_for_file: constant_identifier_names

enum EnvType {
  STG,
  PROD,
}

extension EnvTypeExtension on EnvType {
  String get toValue {
    switch(this){
      case EnvType.PROD:
        return 'prod';
      case EnvType.STG:
        return 'stg';
      default:
        return '';
    }
  }
}
