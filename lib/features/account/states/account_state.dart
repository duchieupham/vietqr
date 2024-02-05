import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/introduce_dto.dart';
import 'package:vierqr/models/theme_dto.dart';

class AccountState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final AccountType request;
  final IntroduceDTO? introduceDTO;
  final File? imageFile;
  final bool keepValue;

  const AccountState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = AccountType.NONE,
    this.introduceDTO,
    this.imageFile,
    this.keepValue = false,
  });

  AccountState copyWith({
    BlocStatus? status,
    String? msg,
    IntroduceDTO? introduceDTO,
    AccountType? request,
    File? imageFile,
    List<ThemeDTO>? themes,
    bool? keepValue,
  }) {
    return AccountState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      introduceDTO: introduceDTO ?? this.introduceDTO,
      request: request ?? this.request,
      imageFile: imageFile ?? this.imageFile,
      keepValue: keepValue ?? this.keepValue,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        introduceDTO,
        request,
        keepValue,
      ];
}
