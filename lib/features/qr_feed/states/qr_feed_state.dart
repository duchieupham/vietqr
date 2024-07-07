import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/bank_name_information_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/metadata_dto.dart';
import 'package:vierqr/models/qr_feed_detail_dto.dart';
import 'package:vierqr/models/qr_feed_dto.dart';
import 'package:vierqr/models/qr_feed_folder_dto.dart';
import 'package:vierqr/models/qr_feed_popup_detail_dto.dart';
import 'package:vierqr/models/qr_feed_private_dto.dart';

class QrFeedState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final QrFeed request;
  final MetaDataDTO? metadata;
  final List<QrFeedDTO>? listQrFeed;
  final List<QrFeedPrivateDTO>? listQrFeedPrivate;
  final List<QrFeedFolderDTO>? listQrFeedFolder;
  final bool isFolderLoading;
  final List<BankTypeDTO>? listBanks;
  final BankNameInformationDTO? bankDto;
  final QrFeedPopupDetailDTO? qrFeedPopupDetail;
  final QrFeedDTO? qrFeed;
  final QrFeedDetailDTO? detailQr;
  final QrFeedDetailDTO? loadCmt;

  final MetaDataDTO? detailMetadata;
  // final bool is

  const QrFeedState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = QrFeed.NONE,
    this.metadata,
    this.listQrFeed,
    this.listQrFeedPrivate,
    this.listQrFeedFolder,
    this.listBanks,
    this.bankDto,
    this.qrFeed,
    this.qrFeedPopupDetail,
    this.detailQr,
    this.loadCmt,
    this.detailMetadata,
    this.isFolderLoading = false,
  });

  QrFeedState copyWith({
    BlocStatus? status,
    String? msg,
    QrFeed? request,
    MetaDataDTO? metadata,
    List<QrFeedDTO>? listQrFeed,
    List<QrFeedPrivateDTO>? listQrFeedPrivate,
    List<QrFeedFolderDTO>? listQrFeedFolder,
    bool? isFolderLoading,
    List<BankTypeDTO>? listBanks,
    BankNameInformationDTO? bankDto,
    QrFeedPopupDetailDTO? qrFeedPopupDetail,
    QrFeedDTO? qrFeed,
    QrFeedDetailDTO? detailQr,
    QrFeedDetailDTO? loadCmt,
    MetaDataDTO? detailMetadata,
  }) {
    return QrFeedState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      request: request ?? this.request,
      metadata: metadata ?? this.metadata,
      listQrFeed: listQrFeed ?? this.listQrFeed,
      listQrFeedPrivate: listQrFeedPrivate ?? this.listQrFeedPrivate,
      listQrFeedFolder: listQrFeedFolder ?? this.listQrFeedFolder,
      isFolderLoading: isFolderLoading ?? this.isFolderLoading,
      listBanks: listBanks ?? this.listBanks,
      qrFeedPopupDetail: qrFeedPopupDetail ?? this.qrFeedPopupDetail,
      bankDto: bankDto ?? this.bankDto,
      qrFeed: qrFeed ?? this.qrFeed,
      detailQr: detailQr ?? this.detailQr,
      detailMetadata: detailMetadata ?? this.detailMetadata,
      loadCmt: loadCmt ?? this.loadCmt,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        request,
        metadata,
        listQrFeed,
        listQrFeedPrivate,
        listQrFeedFolder,
        listBanks,
        bankDto,
        qrFeedPopupDetail,
        qrFeed,
        detailQr,
        loadCmt,
        detailMetadata,
      ];
}
