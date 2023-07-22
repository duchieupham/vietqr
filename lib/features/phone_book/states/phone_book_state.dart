import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/phone_book_dto.dart';

enum PhoneBookType {
  NONE,
  GET_LIST,
}

class PhoneBookState extends Equatable {
  final List<PhoneBookDTO> listPhoneBookDTO;
  final BlocStatus status;
  final PhoneBookType type;
  final String? msg;

  const PhoneBookState({
    required this.listPhoneBookDTO,
    this.status = BlocStatus.NONE,
    this.type = PhoneBookType.NONE,
    this.msg,
  });

  PhoneBookState copyWith({
    BlocStatus? status,
    PhoneBookType? type,
    String? msg,
    List<PhoneBookDTO>? listPhoneBookDTO,
  }) {
    return PhoneBookState(
      status: status ?? this.status,
      type: type ?? this.type,
      msg: msg ?? this.msg,
      listPhoneBookDTO: listPhoneBookDTO ?? this.listPhoneBookDTO,
    );
  }

  @override
  List<Object?> get props => [
        status,
        type,
        msg,
        listPhoneBookDTO,
      ];
}
