import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/verify_email/repositories/verify_email_repositories.dart';
import 'package:vierqr/features/verify_email/verify_email_screen.dart';
import 'package:vierqr/features/verify_email/widgets/popup_key_free.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/key_free_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class NotiVerifyEmailWidget extends StatefulWidget {
  final BankAccountDTO dto;
  final bool isVerify;
  const NotiVerifyEmailWidget(
      {super.key, required this.isVerify, required this.dto});

  @override
  State<NotiVerifyEmailWidget> createState() => _NotiVerifyEmailWidgetState();
}

class _NotiVerifyEmailWidgetState extends State<NotiVerifyEmailWidget> {
  final BankBloc _bloc = getIt.get<BankBloc>();

  @override
  void initState() {
    super.initState();
  }

  Future<KeyFreeDTO?> getKey(Map<String, dynamic> param) async {
    const EmailRepository emailRepository = EmailRepository();
    try {
      final result = await emailRepository.getKeyFree(param);
      return result;
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return widget.isVerify
        ? InkWell(
            onTap: () async {
              Map<String, dynamic> param = {
                'duration': 1,
                'numOfKeys': 1,
                'bankId': widget.dto.id,
                'userId': SharePrefUtils.getProfile().userId,
              };
              await getKey(param).then(
                (value) {
                  if (value != null) {
                    DialogWidget.instance.showModelBottomSheet(
                        borderRadius: BorderRadius.circular(16),
                        widget: PopUpKeyFree(
                          dto: widget.dto,
                          keyDTO: value,
                        ));
                  }
                },
              );
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(colors: [
                    Color(0xFFE1EFFF),
                    Color(0xFFE5F9FF),
                  ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  children: [
                    const XImage(
                      imagePath: 'assets/images/ic-infinity.png',
                      width: 40,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nhận ưu đãi sử dụng dịch vụ VietQR cho',
                            style: TextStyle(fontSize: 12),
                          ),
                          Row(
                            children: [
                              Text(
                                '${widget.dto.bankCode} - ${widget.dto.bankAccount}',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFF00C6FF),
                                    Color(0xFF0072FF),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds),
                                child: Text(
                                  ' miễn phí 01 tháng.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    // decoration:
                                    //     TextDecoration.underline,
                                    // decorationColor:
                                    //     Colors.transparent,
                                    // decorationThickness: 2,
                                    foreground: Paint()
                                      ..shader = const LinearGradient(
                                        colors: [
                                          Color(0xFF00C6FF),
                                          Color(0xFF0072FF),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ).createShader(
                                          const Rect.fromLTWH(0, 0, 200, 30)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const XImage(
                      imagePath: 'assets/images/ic-arrow-boder-blue.png',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          )
        : InkWell(
            onTap: () {
              NavigatorUtils.navigatePage(context, const VerifyEmailScreen(),
                  routeName: VerifyEmailScreen.routeName);
            },
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(colors: [
                    Color(0xFFE1EFFF),
                    Color(0xFFE5F9FF),
                  ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  children: [
                    const XImage(
                      imagePath: 'assets/images/logo-email.png',
                      width: 40,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Xác thực thông tin Email của bạn',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.arrow_circle_right_outlined,
                              color: AppColor.BLUE_TEXT.withOpacity(0.8),
                            )
                          ],
                        ),
                        const Text(
                          'Nhận ngay ưu đãi sử dụng dịch vụ',
                          style: TextStyle(fontSize: 11),
                        ),
                        Row(
                          children: [
                            const Text(
                              'không giới hạn của VietQR',
                              style: TextStyle(fontSize: 11),
                            ),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFF00C6FF),
                                  Color(0xFF0072FF),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                              child: Text(
                                ' miễn phí 01 tháng.',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader = const LinearGradient(
                                      colors: [
                                        Color(0xFF00C6FF),
                                        Color(0xFF0072FF),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ).createShader(
                                        const Rect.fromLTWH(0, 0, 200, 30)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
