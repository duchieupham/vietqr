import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/maintain_charge/blocs/maintain_charge_bloc.dart';
import 'package:vierqr/features/maintain_charge/events/maintain_charge_events.dart';
import 'package:vierqr/services/providers/maintain_charge_provider.dart';

import '../../../commons/constants/configurations/app_images.dart';
import '../../../commons/enums/enum_type.dart';
import '../../../commons/utils/format_price.dart';
import '../../../commons/utils/navigator_utils.dart';
import '../../../models/qr_generated_dto.dart';
import '../../popup_bank/popup_bank_share.dart';
import 'active_success_screen.dart';

class QrAnnualFeeScreen extends StatefulWidget {
  final int? amount;
  final int? duration;
  final int? validFrom;
  final int? validTo;
  final String? billNumber;
  final String? qr;

  const QrAnnualFeeScreen(
      {super.key,
      required this.qr,
      required this.billNumber,
      required this.duration,
      required this.amount,
      required this.validFrom,
      required this.validTo});

  @override
  State<QrAnnualFeeScreen> createState() => _QrAnnualFeeScreenState();
}

class _QrAnnualFeeScreenState extends State<QrAnnualFeeScreen> {
  late ValueNotifier<int> _valueNotifier;
  late Timer _timer;
  late MaintainChargeBloc _bloc;

  @override
  void initState() {
    super.initState();

    _valueNotifier = ValueNotifier<int>(1800);
    _valueNotifier.value = 1800;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_valueNotifier.value > 0) {
        _valueNotifier.value--;
      } else {
        timer.cancel();
        Navigator.popAndPushNamed(context, Routes.ACTIVE_SUCCESS_SCREEN,
            arguments: {'type': 1});
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => ActiveSuccessScreen(type: 1),
        //     ));
      }
    });
    // _bloc = BlocProvider.of<MaintainChargeBloc>(context);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void onShare(BuildContext context) {
    QRGeneratedDTO dto = QRGeneratedDTO(
      bankCode: ' bankAccountDTO.bankCode',
      bankName: ' bankAccountDTO.bankName',
      bankAccount: '',
      userBankName: '',
      qrCode: widget.qr!,
      imgId: '',
      amount: widget.amount.toString(),
    );
    NavigatorUtils.navigatePage(
        context, PopupBankShare(dto: dto, type: TypeImage.SHARE),
        routeName: PopupBankShare.routeName);
  }

  void onSaveImage(BuildContext context) {
    QRGeneratedDTO dto = QRGeneratedDTO(
      bankCode: ' bankAccountDTO.bankCode',
      bankName: ' bankAccountDTO.bankName',
      bankAccount: '',
      userBankName: '',
      qrCode: widget.qr!,
      imgId: '',
      amount: widget.amount.toString(),
    );
    NavigatorUtils.navigatePage(
        context, PopupBankShare(dto: dto, type: TypeImage.SAVE),
        routeName: PopupBankShare.routeName);
  }

  String timestampToDate(int timestamp) {
    // Create a DateTime object from the timestamp
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    // Format the date in the desired format
    String formattedDate = DateFormat('MM/dd/yyyy').format(date);

    return formattedDate;
  }

  String formatSecondsToTime(int seconds) {
    Duration duration = Duration(seconds: seconds);
    String formattedTime =
        '${(duration.inMinutes).toString().padLeft(2, '0')}:${(duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}';
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _headerWidget(),
          _bodyWidget(),
        ],
      ),
    );
  }

  Widget _headerWidget() {
    return SliverAppBar(
      leadingWidth: 100,
      expandedHeight: 120,
      primary: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          // height: 110,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MySeparator(
                    color: AppColor.GREY_DADADA,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(40, 6, 40, 6),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Mã VietQR hết hạn sau:",
                          style: TextStyle(fontSize: 15),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          decoration: BoxDecoration(
                            color: AppColor.BLUE_TEXT.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ValueListenableBuilder(
                            valueListenable: _valueNotifier,
                            builder: (context, value, child) {
                              return Center(
                                child: Text(
                                  formatSecondsToTime(value as int),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.BLUE_TEXT),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  MySeparator(
                    color: AppColor.GREY_DADADA,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            children: [
              Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
                size: 25,
              ),
              const SizedBox(width: 2),
              Text(
                "Trở về",
                style: TextStyle(color: Colors.black, fontSize: 14),
              )
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Image.asset(
            AppImages.icLogoVietQr,
            width: 95,
            fit: BoxFit.fitWidth,
          ),
        )
      ],
    );
  }

  Widget _bodyWidget() {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Thanh toán qua ứng dụng",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "ngân hàng / Ví điện tử",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "có hỗ trợ VietQR",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/bg-qr-vqr.png'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                    decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 240,
                          height: 240,
                          // color: AppColor.GREY_DADADA,
                          child: QrImage(
                            data: widget.qr ?? '',
                            size: 220,
                            version: QrVersions.auto,
                            embeddedImage: const AssetImage(
                                'assets/images/ic-viet-qr-small.png'),
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: const Size(30, 30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Image.asset(
                                  "assets/images/ic-viet-qr.png",
                                  height: 20,
                                ),
                              ),
                              Image.asset(
                                "assets/images/ic-napas247.png",
                                height: 30,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      onSaveImage(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppColor.BLUE_TEXT)),
                      child: Container(
                        height: 30,
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/ic-save-img-blue.png',
                              width: 25,
                              // height: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Lưu ảnh QR",
                              style: TextStyle(
                                  color: AppColor.BLUE_TEXT, fontSize: 13),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onShare(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppColor.BLUE_TEXT)),
                      child: Container(
                        height: 30,
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Image.asset(
                              'assets/images/ic-share-blue.png',
                              width: 25,
                              // height: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Chia sẻ QR",
                              style: TextStyle(
                                  color: AppColor.BLUE_TEXT, fontSize: 13),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Text(
                "Thông tin hoá đơn",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Số tiền TT:",
                      style: TextStyle(fontSize: 15),
                    ),
                    Row(
                      children: [
                        Text(
                          formatNumber(widget.amount),
                          style: TextStyle(
                              fontSize: 15,
                              color: AppColor.ORANGE_DARK,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' VND',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              MySeparator(
                color: AppColor.GREY_DADADA,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dịch vụ:",
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      "Nhận biến động số dư",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              MySeparator(
                color: AppColor.GREY_DADADA,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "TK kích hoạt:",
                      style: TextStyle(fontSize: 15),
                    ),
                    Consumer<MaintainChargeProvider>(
                      builder: (context, value, child) {
                        return Text(
                          "${value.bankName} - ${value.bankAccount}",
                          style: TextStyle(fontSize: 15),
                        );
                      },
                    ),
                  ],
                ),
              ),
              MySeparator(
                color: AppColor.GREY_DADADA,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hoá đơn:",
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      "${widget.billNumber}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              MySeparator(
                color: AppColor.GREY_DADADA,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Thời hạn:",
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      "${widget.duration} tháng",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              MySeparator(
                color: AppColor.GREY_DADADA,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Từ ngày",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          timestampToDate(widget.validFrom!),
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: AppColor.BLACK,
                      size: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Đến ngày",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          timestampToDate(widget.validTo!),
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColor.BLUE_TEXT.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColor.BLUE_TEXT,
                          size: 15,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Lưu ý về thanh toán dịch vụ",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColor.BLUE_TEXT),
                        )
                      ],
                    ),
                    const SizedBox(width: 15),
                    Container(
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Icon(
                              Icons.circle,
                              color: AppColor.BLACK,
                              size: 8,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Vui lòng không chỉnh sửa ",
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  Text(
                                    '"Số tiền" ',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "và",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    ' "Nội dung"',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                'chuyển khoản, điều này ảnh hưởng tới việc thanh \ntoán dịch vụ nhận biến động số dư.',
                                style: TextStyle(fontSize: 11),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ]),
    );
  }
}
