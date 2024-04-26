import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dashed_line.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr_new.dart';
import 'package:vierqr/features/detail_store/blocs/detail_store_bloc.dart';
import 'package:vierqr/features/detail_store/events/detail_store_event.dart';
import 'package:vierqr/features/detail_store/states/detail_store_state.dart';
import 'package:vierqr/features/popup_bank/popup_bank_share.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/store/detail_store_dto.dart';

class VietQRStoreView extends StatefulWidget {
  final String terminalId;

  const VietQRStoreView({super.key, required this.terminalId});

  @override
  State<VietQRStoreView> createState() => _VietQRStoreViewState();
}

class _VietQRStoreViewState extends State<VietQRStoreView>
    with AutomaticKeepAliveClientMixin {
  late DetailStoreBloc bloc;

  final globalKey = GlobalKey();

  double get paddingHorizontal => 45;

  bool get small => MediaQuery.of(context).size.height < 800;

  @override
  void initState() {
    super.initState();
    bloc = DetailStoreBloc(context, terminalId: widget.terminalId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    bloc.add(GetDetailQREvent());
  }

  void onSaveImage(DetailStoreDTO dto) async {
    QRGeneratedDTO qrDTO = QRGeneratedDTO(
      bankCode: '',
      bankName: dto.bankShortName,
      bankAccount: dto.bankAccount,
      userBankName: dto.userBankName,
      qrCode: dto.qrCode,
      imgId: dto.imgId,
    );

    NavigatorUtils.navigatePage(
        context, PopupBankShare(dto: qrDTO, type: TypeImage.SAVE),
        routeName: PopupBankShare.routeName);
  }

  void share(DetailStoreDTO dto) async {
    QRGeneratedDTO qrDTO = QRGeneratedDTO(
      bankCode: '',
      bankName: dto.bankShortName,
      bankAccount: dto.bankAccount,
      userBankName: dto.userBankName,
      qrCode: dto.qrCode,
      imgId: dto.imgId,
    );

    NavigatorUtils.navigatePage(
        context, PopupBankShare(dto: qrDTO, type: TypeImage.SHARE),
        routeName: PopupBankShare.routeName);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<DetailStoreBloc>(
      create: (context) => bloc,
      child: BlocConsumer<DetailStoreBloc, DetailStoreState>(
        listener: (context, state) {
          if (state.status == BlocStatus.LOADING_PAGE) {
            DialogWidget.instance.openLoadingDialog();
          }

          if (state.status == BlocStatus.UNLOADING) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state.detailStore == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: RepaintBoundaryWidget(
                    globalKey: globalKey,
                    builder: (key) {
                      return Column(
                        children: [
                          Container(
                            width: 300,
                            margin: const EdgeInsets.only(top: 24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: AppColor.GREY_BG,
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: 80,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: ImageUtils.instance
                                            .getImageNetWork(
                                                state.detailStore!.imgId),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 10),
                                    child: VerticalDashedLine(),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            state.detailStore!.bankAccount,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: AppColor.BLACK,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            state.detailStore!.userBankName
                                                .toUpperCase(),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: AppColor.BLACK_TEXT,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          VietQrNew(qrCode: state.detailStore!.qrCode),
                          const SizedBox(height: 16),
                          Text('Mã VietQR nhận biến động số dư theo cửa hàng.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColor.WHITE)),
                          Text(
                              'Nhận tiền từ mọi ngân hàng và ví điện tử có hỗ trợ VietQR.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColor.WHITE)),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildBottomBar(
                        url: 'assets/images/ic-save-img-blue.png',
                        title: 'Lưu ảnh vào thư viện',
                        onTap: () => onSaveImage(state.detailStore),
                      ),
                      const Divider(thickness: 1, color: AppColor.GREY_BORDER),
                      _buildBottomBar(
                        url: 'assets/images/ic-share-img-blue.png',
                        title: 'Chia sẻ mã QR',
                        onTap: () => share(state.detailStore),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar({
    GestureTapCallback? onTap,
    required String url,
    required String title,
    Color? color,
    Color? colorIcon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColor.TRANSPARENT,
        child: Row(
          children: [
            Image.asset(
              url,
              width: small ? 24 : 36,
              height: 36,
              color: colorIcon,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: color ?? AppColor.BLUE_TEXT,
                fontSize: small ? 10 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
