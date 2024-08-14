import 'package:card_swiper/card_swiper.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/helper/app_data_helper.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/features/bank_detail/states/bank_card_state.dart';
import 'package:vierqr/features/my_vietqr/bloc/vietqr_store_bloc.dart';
import 'package:vierqr/features/my_vietqr/event/vietqr_store_event.dart';
import 'package:vierqr/features/my_vietqr/state/vietqr_store_state.dart';
import 'package:vierqr/features/my_vietqr/views/my_qr_widget.dart';
import 'package:vierqr/features/my_vietqr/views/vietqr_store_widget.dart';
import 'package:vierqr/features/my_vietqr/widgets/select_bank_widget.dart';
import 'package:vierqr/features/my_vietqr/widgets/select_store_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/qr_bank_detail.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/vietqr_store_dto.dart';

class MyVietQRScreen extends StatefulWidget {
  final List<BankAccountDTO> listBank;
  final BankAccountDTO bankDto;
  const MyVietQRScreen(
      {super.key, required this.listBank, required this.bankDto});

  @override
  State<MyVietQRScreen> createState() => _MyVietQRScreenState();
}

class _MyVietQRScreenState extends State<MyVietQRScreen> {
  late BankCardBloc bankCardBloc;
  final SwiperController _swiperController = SwiperController();
  int _index = 0;
  BankAccountDTO selectBank = BankAccountDTO();
  VietQRStoreDTO storeSelect = VietQRStoreDTO(terminals: []);
  final GlobalKey globalKeyQr = GlobalKey();
  final GlobalKey globalKeyStore = GlobalKey();

  @override
  void initState() {
    super.initState();
    selectBank = widget.bankDto;
    bankCardBloc =
        getIt.get<BankCardBloc>(param1: widget.bankDto.id, param2: true);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        bankCardBloc
            .add(const BankCardGetDetailEvent(isLoading: true, isInit: true));
        getIt
            .get<VietQRStoreBloc>()
            .add(GetListStore(bankId: widget.bankDto.id));
      },
    );
  }

  late QRGeneratedDTO qrGeneratedDTO = QRGeneratedDTO(
      bankCode: '',
      bankName: '',
      bankAccount: '',
      userBankName: '',
      amount: '',
      content: '',
      qrCode: '',
      imgId: '');
  late AccountBankDetailDTO dto = AccountBankDetailDTO();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: VietQRTheme.gradientColor.lilyLinear,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _appbar(),
            Expanded(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 25,
                    child: Swiper(
                      controller: _swiperController,
                      itemCount: 2,
                      viewportFraction: 0.55,
                      scale: 0.8,
                      loop: false,
                      onTap: (index) {
                        _swiperController.move(index);
                      },
                      onIndexChanged: (value) {
                        setState(() {
                          _index = value;
                        });
                        _swiperController.move(value);
                      },
                      itemBuilder: (context, index) {
                        if (index == 1) {
                          return ShaderMask(
                            shaderCallback: (bounds) => _index == 1
                                ? VietQRTheme.gradientColor.brightBlueLinear
                                    .createShader(bounds)
                                : const LinearGradient(colors: [
                                    AppColor.GREY_TEXT,
                                    AppColor.GREY_TEXT,
                                  ]).createShader(bounds),
                            child: const Text(
                              textAlign: TextAlign.center,
                              'Mã VietQR Cửa hàng',
                              style: TextStyle(
                                  fontSize: 20, color: AppColor.WHITE),
                            ),
                          );
                        }
                        return ShaderMask(
                          shaderCallback: (bounds) => _index == 0
                              ? VietQRTheme.gradientColor.brightBlueLinear
                                  .createShader(bounds)
                              : const LinearGradient(colors: [
                                  AppColor.GREY_TEXT,
                                  AppColor.GREY_TEXT,
                                ]).createShader(bounds),
                          child: const Text(
                            textAlign: TextAlign.center,
                            'Mã VietQR của tôi',
                            style:
                                TextStyle(fontSize: 20, color: AppColor.WHITE),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Swiper(
                        itemCount: 2,
                        controller: _swiperController,
                        viewportFraction: 0.8,
                        scale: 0.8,
                        loop: false,
                        onTap: (index) {
                          _swiperController.move(index);
                        },
                        onIndexChanged: (value) {
                          _swiperController.move(value);
                        },
                        itemBuilder: (context, index) {
                          if (index == 1) {
                            return VietQRStoreWidget(
                              dto: selectBank,
                              globalKey: globalKeyStore,
                            );
                          }
                          return MyQrWidget(
                            bloc: bankCardBloc,
                            globalKey: globalKeyQr,
                            dto: selectBank,
                          );
                        },
                      ),
                    ),
                  ),
                  if (_index == 1) ...[
                    BlocBuilder<VietQRStoreBloc, VietQRStoreState>(
                      bloc: getIt.get<VietQRStoreBloc>(),
                      builder: (context, state) {
                        if (state.terminal != null &&
                            state.terminal!.terminalId.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: InkWell(
                                onTap: onSelectStore,
                                child: Row(
                                  children: [
                                    Text(
                                      state.terminal!.terminalName,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const SizedBox(width: 8),
                                    const XImage(
                                      imagePath:
                                          'assets/images/ic-select-merchant.png',
                                      width: 25,
                                      height: 25,
                                      color: AppColor.BLACK,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  ],
                  InkWell(
                    onTap: () {
                      onSelectBank();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: AppColor.WHITE.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppColor.WHITE)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColor.WHITE,
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: ImageUtils.instance
                                    .getImageNetWork(selectBank.imgId),
                              ),
                            ),
                            // child: XImage(imagePath: e.imgId),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  selectBank.bankAccount,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  selectBank.userBankName,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                gradient: VietQRTheme.gradientColor.lilyLinear,
                                borderRadius: BorderRadius.circular(100)),
                            child: const Center(
                              child: XImage(
                                imagePath:
                                    'assets/images/ic-select-merchant.png',
                                width: 30,
                                height: 30,
                                color: AppColor.BLACK,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _appbar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
      height: 110,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Row(
              children: [
                Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.black,
                  size: 25,
                ),
                SizedBox(width: 2),
                Text(
                  "Trở về",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                )
              ],
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  onSaveImage(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: const LinearGradient(
                          colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)),
                  child:
                      const XImage(imagePath: 'assets/images/ic-dowload.png'),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  share();
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: const LinearGradient(
                          colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)),
                  child: const XImage(
                      imagePath: 'assets/images/ic-share-black.png'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void onSelectStore() async {
    await DialogWidget.instance
        .showModelBottomSheet(
      borderRadius: BorderRadius.circular(0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.57,
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
      bgrColor: AppColor.WHITE,
      margin: EdgeInsets.zero,
      widget: SelectStoreWidget(
        bankId: selectBank.id,
      ),
    )
        .then(
      (value) {
        if (value != null) {}
      },
    );
  }

  void onSelectBank() async {
    await DialogWidget.instance
        .showModelBottomSheet(
      borderRadius: BorderRadius.circular(0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.57,
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
      bgrColor: AppColor.WHITE,
      margin: EdgeInsets.zero,
      widget: SelectBankWidget(
        selectedBank: selectBank,
        listBank: widget.listBank,
      ),
    )
        .then(
      (value) {
        if (value != null) {
          setState(() {
            selectBank = value;
          });
          bankCardBloc =
              getIt.get<BankCardBloc>(param1: selectBank.id, param2: true);
          bankCardBloc
              .add(const BankCardGetDetailEvent(isLoading: true, isInit: true));
          getIt.get<VietQRStoreBloc>().add(GetListStore(bankId: selectBank.id));
        }
      },
    );
  }

  void onSaveImage(BuildContext context) async {
    DialogWidget.instance.openLoadingDialog();
    await Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        await ShareUtils.instance
            .saveImageToGallery(_index == 0 ? globalKeyQr : globalKeyStore)
            .then(
          (value) {
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: 'Đã lưu ảnh',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
            );
          },
        );
      },
    );
  }

  void share() async {
    await ShareUtils.instance
        .shareImage(
            key: _index == 0 ? globalKeyQr : globalKeyStore, textSharing: '')
        .then((value) {
      // Navigator.pop(context);
      Fluttertoast.showToast(
        msg: 'Đã hoàn thành',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Theme.of(context).hintColor,
        fontSize: 15,
      );
      // Navigator.pop(context);
    });
  }
}
