import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/commons/widgets/shimmer_block.dart';
import 'package:vierqr/features/create_store/create_store_screen.dart';
import 'package:vierqr/features/detail_store/detail_store_screen.dart';
import 'package:vierqr/features/my_vietqr/bloc/vietqr_store_bloc.dart';
import 'package:vierqr/features/my_vietqr/event/vietqr_store_event.dart';
import 'package:vierqr/features/my_vietqr/state/vietqr_store_state.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/vietqr_store_dto.dart';

class VietQRStoreWidget extends StatefulWidget {
  final GlobalKey globalKey;
  final BankAccountDTO dto;

  const VietQRStoreWidget(
      {super.key, required this.globalKey, required this.dto});

  @override
  State<VietQRStoreWidget> createState() => _VietQRStoreWidgetState();
}

class _VietQRStoreWidgetState extends State<VietQRStoreWidget> {
  final VietQRStoreBloc _bloc = getIt.get<VietQRStoreBloc>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        // _bloc.add(GetListStore(bankId: widget.dto.id));
      },
    );
  }

  List<VietQRStoreDTO> list = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VietQRStoreBloc, VietQRStoreState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.status == BlocStatus.SUCCESS &&
            state.request == VietQrStore.GET_LIST) {
          list = state.listStore;
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              if (list.isNotEmpty) ...[
                if (state.terminal != null) ...[
                  const SizedBox(height: 30),
                  RepaintBoundaryWidget(
                    globalKey: widget.globalKey,
                    builder: (key) {
                      return Container(
                        padding: const EdgeInsets.fromLTRB(50, 30, 50, 30),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColor.WHITE.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: AppColor.WHITE)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (state.status != BlocStatus.LOADING_PAGE)
                              SizedBox(
                                width: 250,
                                height: 250,
                                child: QrImageView(
                                  padding: EdgeInsets.zero,
                                  data: state.terminal!.qrCode,
                                  size: 200,
                                  version: QrVersions.auto,
                                  backgroundColor: AppColor.TRANSPARENT,
                                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                                  embeddedImage: const AssetImage(
                                      'assets/images/ic-viet-qr-small.png'),
                                  dataModuleStyle: const QrDataModuleStyle(
                                      dataModuleShape: QrDataModuleShape.square,
                                      color: AppColor.BLACK),
                                  eyeStyle: const QrEyeStyle(
                                      eyeShape: QrEyeShape.square,
                                      color: AppColor.BLACK),
                                  embeddedImageStyle:
                                      const QrEmbeddedImageStyle(
                                    size: Size(30, 30),
                                  ),
                                ),
                              )
                            else
                              const ShimmerBlock(
                                height: 250,
                                width: 250,
                                borderRadius: 10,
                              ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                      'assets/images/logo-napas-trans-bgr.png',
                                      height: 42),
                                  widget.dto.imgId.isNotEmpty
                                      ? Container(
                                          width: 80,
                                          height: 40,
                                          margin: const EdgeInsets.only(top: 2),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: ImageUtils.instance
                                                    .getImageNetWork(
                                                        widget.dto.imgId),
                                                fit: BoxFit.cover),
                                          ),
                                        )
                                      : SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: Image.asset(
                                              'assets/images/logo_vietgr_payment.png',
                                              height: 40),
                                        ),
                                  // const SizedBox(width: 30),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const MySeparator(color: AppColor.GREY_DADADA),
                            const SizedBox(height: 20),
                            Text(
                              textAlign: TextAlign.center,
                              state.terminal!.terminalName,
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              state.terminal!.terminalCode,
                              style: const TextStyle(
                                  fontSize: 12, color: AppColor.GREY_TEXT),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _button(
                      dto: state.terminal,
                      merchantId: state.storeSelect != null
                          ? state.storeSelect?.merchantId
                          : ''),
                ]
              ] else
                _buildEmpty(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Column(
      children: [
        const SizedBox(height: 60),
        const XImage(
          imagePath: 'assets/images/store-image-3d.png',
          width: 100,
          height: 100,
        ),
        const SizedBox(height: 8),
        const Text(
          textAlign: TextAlign.center,
          'Tài khoản này chưa được liên kết\nvới bất kì cửa hàng nào',
          style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const XImage(
              imagePath: 'assets/images/ic-suggest.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 5),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFF458BF8),
                  Color(0xFFFF8021),
                  Color(0xFFFF3751),
                  Color(0xFFC958DB),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                'Gợi ý cho bạn',
                style: TextStyle(
                    fontSize: 15,
                    color: AppColor.WHITE,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        const SizedBox(height: 15),
        InkWell(
          onTap: () async {
            await NavigatorUtils.navigatePage(
                context, const CreateStoreScreen(),
                routeName: CreateStoreScreen.routeName);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFD8ECF8),
                    Color(0xFFFFEAD9),
                    Color(0xFFF5C9D1),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                XImage(
                  imagePath: 'assets/images/ic-add-store.png',
                  width: 30,
                  height: 30,
                ),
                SizedBox(width: 4),
                Text(
                  'Tạo cửa hàng mới',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFD8ECF8),
                    Color(0xFFFFEAD9),
                    Color(0xFFF5C9D1),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                XImage(
                  imagePath: 'assets/images/ic-linked-black.png',
                  width: 30,
                  height: 30,
                ),
                SizedBox(width: 4),
                Text(
                  'Liên kết TK ngân hàng vào cửa hàng',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _button({TerminalDTO? dto, String? merchantId}) {
    return SizedBox(
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              // height: 40,
              decoration: BoxDecoration(
                  color: AppColor.WHITE.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: AppColor.WHITE)),
              child: GestureDetector(
                onTap: () async {
                  if (dto != null) {
                    await NavigatorUtils.navigatePage(
                        context,
                        DetailStoreScreen(
                          merchantId: merchantId,
                          terminalId: dto.terminalId,
                          terminalCode: dto.terminalCode,
                          terminalName: dto.terminalName,
                        ),
                        routeName: DetailStoreScreen.routeName);
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    XImage(
                      imagePath: 'assets/images/ic-edit.png',
                      height: 30,
                    ),
                    Text(
                      'Truy cập vào cửa hàng',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () async {
              await FlutterClipboard.copy('').then(
                (value) => Fluttertoast.showToast(
                  msg: 'Đã sao chép',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).hintColor,
                  fontSize: 15,
                  webBgColor: 'rgba(255, 255, 255, 0.5)',
                  webPosition: 'center',
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.WHITE),
                borderRadius: BorderRadius.circular(100),
                color: AppColor.WHITE.withOpacity(0.6),
              ),
              child: const Image(
                image: AssetImage('assets/images/ic-copy-black.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
