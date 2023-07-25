import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/phone_book_detail_dto.dart';
import 'package:vierqr/models/phone_book_dto.dart';

enum PhoneBookType { NONE, GET_LIST, GET_DETAIL, REMOVE, UPDATE }

class PhoneBookState extends Equatable {
  final List<PhoneBookDTO> listPhoneBookDTO;
  final List<PhoneBookDTO> listPhoneBookDTOSuggest;
  final PhoneBookDetailDTO phoneBookDetailDTO;
  final BlocStatus status;
  final PhoneBookType type;
  final String? msg;

  const PhoneBookState({
    required this.listPhoneBookDTO,
    required this.listPhoneBookDTOSuggest,
    required this.phoneBookDetailDTO,
    this.status = BlocStatus.NONE,
    this.type = PhoneBookType.NONE,
    this.msg,
  });

  PhoneBookState copyWith({
    BlocStatus? status,
    PhoneBookType? type,
    String? msg,
    List<PhoneBookDTO>? listPhoneBookDTO,
    List<PhoneBookDTO>? listPhoneBookDTOSuggest,
    PhoneBookDetailDTO? phoneBookDetailDTO,
  }) {
    return PhoneBookState(
      status: status ?? this.status,
      type: type ?? this.type,
      msg: msg ?? this.msg,
      listPhoneBookDTO: listPhoneBookDTO ?? this.listPhoneBookDTO,
      listPhoneBookDTOSuggest:
          listPhoneBookDTOSuggest ?? this.listPhoneBookDTOSuggest,
      phoneBookDetailDTO: phoneBookDetailDTO ?? this.phoneBookDetailDTO,
    );
  }

  @override
  List<Object?> get props => [
        status,
        type,
        msg,
        listPhoneBookDTO,
        listPhoneBookDTOSuggest,
        phoneBookDetailDTO,
      ];
}
