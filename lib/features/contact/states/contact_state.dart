import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/contact_detail_dto.dart';
import 'package:vierqr/models/contact_dto.dart';

class ContactState extends Equatable {
  final List<ContactDTO> listContactDTO;
  final List<ContactDTO> listContactDTOSuggest;
  final ContactDetailDTO contactDetailDTO;
  final BlocStatus status;
  final ContactType type;
  final String? msg;
  final String qrCode;
  final TypeContact typeQR;
  final String? nickName;
  final String? bankAccount;
  final BankTypeDTO? bankTypeDTO;

  const ContactState({
    required this.listContactDTO,
    required this.listContactDTOSuggest,
    required this.contactDetailDTO,
    this.status = BlocStatus.NONE,
    this.type = ContactType.NONE,
    this.msg,
    required this.qrCode,
    this.typeQR = TypeContact.NONE,
    this.nickName,
    this.bankAccount,
    this.bankTypeDTO,
  });

  ContactState copyWith(
      {BlocStatus? status,
      ContactType? type,
      String? msg,
      List<ContactDTO>? listContactDTO,
      List<ContactDTO>? listContactDTOSuggest,
      ContactDetailDTO? contactDetailDTO,
      String? qrCode,
      TypeContact? typeQR,
      String? nickName,
      String? bankAccount,
      BankTypeDTO? bankTypeDTO}) {
    return ContactState(
      status: status ?? this.status,
      type: type ?? this.type,
      msg: msg ?? this.msg,
      listContactDTO: listContactDTO ?? this.listContactDTO,
      listContactDTOSuggest:
          listContactDTOSuggest ?? this.listContactDTOSuggest,
      contactDetailDTO: contactDetailDTO ?? this.contactDetailDTO,
      qrCode: qrCode ?? this.qrCode,
      typeQR: typeQR ?? this.typeQR,
      nickName: nickName ?? this.nickName,
      bankAccount: bankAccount ?? this.bankAccount,
      bankTypeDTO: bankTypeDTO ?? this.bankTypeDTO,
    );
  }

  @override
  List<Object?> get props => [
        status,
        type,
        msg,
        listContactDTO,
        listContactDTOSuggest,
        contactDetailDTO,
        qrCode,
        typeQR,
        nickName,
        bankAccount,
        bankTypeDTO,
      ];
}
