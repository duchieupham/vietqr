import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class SuggestionWidget extends StatefulWidget {
  final AccountBankDetailDTO dto;
  final BankCardBloc bloc;
  const SuggestionWidget({super.key, required this.dto, required this.bloc});

  @override
  State<SuggestionWidget> createState() => _SuggestionWidgetState();
}

class _SuggestionWidgetState extends State<SuggestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      // height: 440,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        gradient: const LinearGradient(
          colors: [
            Color(0xFFD8ECF8),
            Color(0xFFFFEAD9),
            Color(0xFFF5C9D1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                XImage(
                  imagePath: 'assets/images/ic-suggest.png',
                  width: 30,
                ),
                SizedBox(width: 8),
                Text(
                  'Gợi ý',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.GREY_TEXT,
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.white,
              thickness: 1,
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                _onLinked();
                print('lien ket tai khoan');
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [
                              Color(0xFFBAFFBF),
                              Color(0xFFCFF4D2),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight),
                        borderRadius: BorderRadius.circular(8)),
                    child: Image.asset(
                      'assets/images/ic-linked-black.png',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Liên kết tài khoản',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    ' ngay để nhận thông báo\nBiến động số dư và sử dụng các tính năng tích hợp.',
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 1,
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [
                            Color(0xFFA6C5FF),
                            Color(0xFFC5CDFF),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                      borderRadius: BorderRadius.circular(8)),
                  child: Image.asset(
                    'assets/images/ic-earth-black.png',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 12, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Giới thiệu tính năng ',
                            ),
                            TextSpan(
                              text: 'Chia sẻ Biến động số dư',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' qua các nền tảng mạng xã hội:',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Image.asset(
                              ImageConstant.logoDiscordHome,
                              height: 30,
                            ),
                            const SizedBox(width: 4),
                            Image.asset(
                              ImageConstant.logoSlackHome,
                              height: 30,
                            ),
                            const SizedBox(width: 4),
                            Image.asset(
                              ImageConstant.logoGGSheetHome,
                              height: 30,
                            ),
                            const SizedBox(width: 4),
                            Image.asset(
                              ImageConstant.logoGGChatHome,
                              height: 30,
                            ),
                            const SizedBox(width: 4),
                            Image.asset(
                              ImageConstant.logoLarkDash,
                              height: 30,
                            ),
                            const SizedBox(width: 4),
                            Image.asset(
                              ImageConstant.logoTelegramDash,
                              height: 30,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'và nhiều\nhơn thế!!!',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.white,
              thickness: 1,
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [
                            Color(0xFF91E2FF),
                            Color(0xFF91FFFF),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                      borderRadius: BorderRadius.circular(8)),
                  child: Image.asset(
                    'assets/images/ic-store-black.png',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: const TextSpan(
                        style: TextStyle(fontSize: 12, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Bạn là hộ kinh doanh?\n',
                          ),
                          TextSpan(
                            text: 'Quản lý dòng tiền cửa hàng',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ' để dễ dàng với ',
                          ),
                          TextSpan(
                            text: 'VietQR.VN',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                XImage(
                                  imagePath:
                                      'assets/images/ic-statistic-black.png',
                                  height: 30,
                                ),
                                Text(
                                  'Tổng hợp doanh thu mỗi ngày.',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                XImage(
                                  imagePath: 'assets/images/ic-money-black.png',
                                  height: 30,
                                ),
                                Text(
                                  'Tách bạch tiền bán hàng và tiền cá nhân.',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 40),
              child: Text(
                'Bộ công cụ quản lý dòng tiền',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    XImage(
                      imagePath: 'assets/images/ic-share-bdsd-black.png',
                      height: 50,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Chia sẻ\nbiến động\nsố dư',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  children: [
                    XImage(
                      imagePath: 'assets/images/ic-voice-black.png',
                      height: 50,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Thông báo\ngiọng nói',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  children: [
                    XImage(
                      imagePath: 'assets/images/ic-monitor-store-black.png',
                      height: 50,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Theo dõi\ndoanh thu\ncửa hàng',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onLinked() async {
    BankTypeDTO bankTypeDTO = BankTypeDTO(
      id: widget.dto.bankTypeId,
      bankCode: widget.dto.bankCode,
      bankName: widget.dto.bankName,
      imageId: widget.dto.imgId,
      bankShortName: widget.dto.bankCode,
      status: widget.dto.bankTypeStatus,
      caiValue: widget.dto.caiValue,
      bankId: widget.dto.id,
      bankAccount: widget.dto.bankAccount,
      userBankName: widget.dto.userBankName,
    );
    await NavigatorUtils.navigatePage(
            context, AddBankScreen(bankTypeDTO: bankTypeDTO),
            routeName: AddBankScreen.routeName)
        .then((value) {
      if (value is bool) {
        widget.bloc.add(const BankCardGetDetailEvent());
      }
    });
  }
}
