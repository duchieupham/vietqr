import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/count_down_minus_second.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/features/top_up/blocs/top_up_bloc.dart';
import 'package:vierqr/features/top_up/states/top_up_state.dart';
import 'package:vierqr/models/respone_top_up_dto.dart';
import 'package:vierqr/services/providers/top_up_provider.dart';

class QRTopUpScreen extends StatefulWidget {
  final ResponseTopUpDTO dto;
  const QRTopUpScreen({super.key, required this.dto});

  @override
  State<QRTopUpScreen> createState() => _QRTopUpScreenState();
}

class _QRTopUpScreenState extends State<QRTopUpScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final GlobalKey globalKey = GlobalKey();
  int timer = 1200;
  String getCodeOrder() {
    List<String> list = widget.dto.content.split(' ');

    return list[1];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> share({required String name}) async {
    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance.shareImage(
        textSharing: 'VietId of $name',
        key: globalKey,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                timer) // gameData.levelClock is a user entered number elsewhere in the applciation
        );

    _controller.forward();
    _controller.addListener(() {
      if (_controller.isCompleted) {
        DialogWidget.instance.openMsgDialog(
            title: 'Mã giao dịch hết hạn',
            msg: 'Vui lòng tạo lại giao dịch mới',
            function: () {
              Navigator.pop(context);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => TopUpProvider(),
        child: BlocProvider<TopUpBloc>(
          create: (context) => TopUpBloc(),
          child: BlocConsumer<TopUpBloc, TopUpState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Column(
                  children: [
                    SubHeader(
                      title: 'Nạp tiền',
                      function: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Future.delayed(const Duration(milliseconds: 200), () {
                          Navigator.of(context).pop();
                        });
                      },
                      callBackHome: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child:
                          Text('Thanh toán qua ứng dụng Ngân hàng/ Ví điện tử'),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 0, bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: AppColor.WHITE,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RepaintBoundaryWidget(
                                      globalKey: globalKey,
                                      builder: (key) {
                                        return QrImage(
                                          data: widget.dto.qrCode,
                                          version: QrVersions.auto,
                                          embeddedImage: const AssetImage(
                                              'assets/images/ic-viet-qr-small.png'),
                                          embeddedImageStyle:
                                              QrEmbeddedImageStyle(
                                            size: const Size(30, 30),
                                          ),
                                        );
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/ic-viet-qr.png',
                                        height: 28,
                                      ),
                                      const Spacer(),
                                      Image.asset(
                                        'assets/images/ic-napas247.png',
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildInfoBill(),
                          _buildCountDown(),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Lưu ý: Vui lòng không chỉnh sửa nội dung chuyển khoản, điều này có thể ảnh hưởng tới hệ thống nạp tiền.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 40,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 8, 32, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: ButtonIconWidget(
                              height: 40,
                              pathIcon: 'assets/images/ic-img-blue.png',
                              textColor: AppColor.WHITE,
                              iconPathColor: AppColor.WHITE,
                              iconSize: 22,
                              title: 'Lưu ảnh',
                              textSize: 10,
                              bgColor: AppColor.BLUE_TEXT,
                              borderRadius: 5,
                              function: () async {
                                await Future.delayed(
                                    const Duration(milliseconds: 300),
                                    () async {
                                  await ShareUtils.instance
                                      .saveImageToGallery(globalKey)
                                      .then((value) {
                                    Fluttertoast.showToast(
                                      msg: 'Đã lưu ảnh',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor:
                                          Theme.of(context).cardColor,
                                      textColor: Theme.of(context).hintColor,
                                      fontSize: 15,
                                    );
                                    // Navigator.pop(context);
                                  });
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: ButtonIconWidget(
                              title: 'Chia sẻ',
                              height: 40,
                              pathIcon: 'assets/images/ic-share-blue.png',
                              textColor: AppColor.WHITE,
                              bgColor: AppColor.BLUE_TEXT,
                              iconPathColor: AppColor.WHITE,
                              iconSize: 22,
                              borderRadius: 5,
                              textSize: 10,
                              function: () async {
                                share(name: "QR thanh toán");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget _buildInfoBill() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: AppColor.WHITE),
      child: Column(
        children: [
          Text(
            '+ ${StringUtils.formatNumber(int.parse(widget.dto.amount))} VND',
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.ORANGE_DARK),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Thanh toán đơn hàng ',
                style: TextStyle(color: AppColor.GREY_TEXT),
              ),
              Text(
                getCodeOrder(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Nhà cung cấp',
                style: TextStyle(fontSize: 12),
              ),
              const Spacer(),
              Image.asset(
                'assets/images/ic-viet-qr.png',
                height: 18,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Ngân hàng thụ hưởng',
                style: TextStyle(fontSize: 12),
              ),
              const Spacer(),
              Image.asset(
                'assets/images/logo-mb.png',
                height: 20,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCountDown() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: AppColor.WHITE),
      child: Row(
        children: [
          const Text('Giao dịch hết hạn sau'),
          const Spacer(),
          Countdown(
            animation: StepTween(
              begin: timer, // THIS IS A USER ENTERED NUMBER
              end: 0,
            ).animate(_controller),
          ),
        ],
      ),
    );
  }
}
