import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/bank_name_information_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/metadata_dto.dart';
import 'package:vierqr/models/qr_feed_detail_dto.dart';
import 'package:vierqr/models/qr_feed_dto.dart';

class QrFeedState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final QrFeed request;
  final MetaDataDTO? metadata;
  final List<QrFeedDTO>? listQrFeed;
  final List<BankTypeDTO>? listBanks;
  final BankNameInformationDTO? bankDto;
  final QrFeedDTO? qrFeed;
  final QrFeedDetailDTO? detailQr;
  final MetaDataDTO? detailMetadata;
  // final bool is

  const QrFeedState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = QrFeed.NONE,
    this.metadata,
    this.listQrFeed,
    this.listBanks,
    this.bankDto,
    this.qrFeed,
    this.detailQr,
    this.detailMetadata,
  });

  QrFeedState copyWith({
    BlocStatus? status,
    String? msg,
    QrFeed? request,
    MetaDataDTO? metadata,
    List<QrFeedDTO>? listQrFeed,
    List<BankTypeDTO>? listBanks,
    BankNameInformationDTO? bankDto,
    QrFeedDTO? qrFeed,
    QrFeedDetailDTO? detailQr,
    MetaDataDTO? detailMetadata,
  }) {
    return QrFeedState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      request: request ?? this.request,
      metadata: metadata ?? this.metadata,
      listQrFeed: listQrFeed ?? this.listQrFeed,
      listBanks: listBanks ?? this.listBanks,
      bankDto: bankDto ?? this.bankDto,
      qrFeed: qrFeed ?? this.qrFeed,
      detailQr: detailQr ?? this.detailQr,
      detailMetadata: detailMetadata ?? this.detailMetadata,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        request,
        metadata,
        listQrFeed,
        listBanks,
        bankDto,
        qrFeed,
        detailQr,
        detailMetadata,
      ];
}
