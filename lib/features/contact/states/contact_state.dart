import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/contact_detail_dto.dart';
import 'package:vierqr/models/contact_dto.dart';

class ContactState extends Equatable {
  final List<List<ContactDTO>> listCompareContact;
  final List<ContactDTO> listContactDTO;
  final List<ContactDTO> listContactDTOSuggest;
  final List<ContactDetailDTO> listContactDetail;
  final ContactDetailDTO contactDetailDTO;
  final BlocStatus status;
  final ContactType type;
  final String? msg;
  final String qrCode;
  final TypeContact typeQR;
  final String? nickName;
  final String? bankAccount;
  final BankTypeDTO? bankTypeDTO;
  final ContactDTO? userSearch;
  final String? imgId;
  final dynamic dto;
  final bool isLoading;
  final bool isChange;
  final bool isLoadMore;
  final VCardModel? cardModel;
  final int pageIndex;

  const ContactState({
    required this.listContactDTO,
    required this.listCompareContact,
    required this.listContactDTOSuggest,
    required this.contactDetailDTO,
    required this.listContactDetail,
    this.status = BlocStatus.NONE,
    this.type = ContactType.NONE,
    this.msg,
    required this.qrCode,
    this.typeQR = TypeContact.NONE,
    this.nickName,
    this.bankAccount,
    this.bankTypeDTO,
    this.userSearch,
    this.imgId,
    this.dto,
    this.cardModel,
    this.isLoading = false,
    this.isChange = false,
    this.isLoadMore = false,
    this.pageIndex = 0,
  });

  ContactState copyWith({
    BlocStatus? status,
    ContactType? type,
    String? msg,
    List<ContactDTO>? listContactDTO,
    List<List<ContactDTO>>? listCompareContact,
    List<ContactDTO>? listContactDTOSuggest,
    List<ContactDetailDTO>? listContactDetail,
    ContactDetailDTO? contactDetailDTO,
    String? qrCode,
    TypeContact? typeQR,
    String? nickName,
    String? bankAccount,
    ContactDTO? userSearch,
    BankTypeDTO? bankTypeDTO,
    String? imgId,
    dynamic dto,
    bool? isLoading,
    bool? isChange,
    bool? isLoadMore,
    VCardModel? cardModel,
    int? pageIndex,
  }) {
    return ContactState(
      status: status ?? this.status,
      type: type ?? this.type,
      msg: msg ?? this.msg,
      listContactDTO: listContactDTO ?? this.listContactDTO,
      listCompareContact: listCompareContact ?? this.listCompareContact,
      listContactDTOSuggest:
          listContactDTOSuggest ?? this.listContactDTOSuggest,
      contactDetailDTO: contactDetailDTO ?? this.contactDetailDTO,
      listContactDetail: listContactDetail ?? this.listContactDetail,
      qrCode: qrCode ?? this.qrCode,
      typeQR: typeQR ?? this.typeQR,
      nickName: nickName ?? this.nickName,
      bankAccount: bankAccount ?? this.bankAccount,
      bankTypeDTO: bankTypeDTO ?? this.bankTypeDTO,
      userSearch: userSearch ?? this.userSearch,
      imgId: imgId ?? this.imgId,
      dto: dto ?? this.dto,
      isLoading: isLoading ?? this.isLoading,
      isChange: isChange ?? this.isChange,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      cardModel: cardModel ?? this.cardModel,
      pageIndex: pageIndex ?? this.pageIndex,
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
        userSearch,
        isLoading,
        isChange,
        listContactDetail,
        isLoadMore,
        cardModel,
        pageIndex,
      ];
}
