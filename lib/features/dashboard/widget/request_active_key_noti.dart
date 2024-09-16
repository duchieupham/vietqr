import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/helper/dialog_helper.dart';
import 'package:vierqr/commons/utils/format_date.dart';
import 'package:vierqr/commons/widgets/clip_shadow_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/providers/maintain_charge_provider.dart';

class RequestActiveKeyNoti extends StatefulWidget {
  const RequestActiveKeyNoti({super.key});

  @override
  State<RequestActiveKeyNoti> createState() => _RequestActiveKeyNotiState();
}

class _RequestActiveKeyNotiState extends State<RequestActiveKeyNoti>
    with DialogHelper {
  bool isOpen = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BankBloc, BankState>(
      bloc: getIt.get<BankBloc>(),
      listener: (context, state) {},
      builder: (context, state) {
        BankAccountDTO bankAccount = BankAccountDTO();
        if (state.bankSelect != null) {
          bankAccount = state.bankSelect!;
        }
        if (state.listBanks.isEmpty) {
          return const SizedBox.shrink();
        } else {
          if (bankAccount.isAuthenticated &&
              bankAccount.isOwner &&
              bankAccount.validFeeTo != 0 &&
              inclusiveDays(bankAccount.validFeeTo) <= 15) {
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: bankAccount.id.isEmpty ? -200 : 0,
              bottom: 100,
              child: Stack(
                children: [
                  const Positioned(
                    top: 0,
                    left: 40,
                    child: Icon(
                      Icons.error_rounded,
                      size: 18,
                      color: AppColor.RED_TEXT,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 0,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isOpen = !isOpen;
                        });
                      },
                      child: const XImage(
                        imagePath: 'assets/images/ic-noti-extend-key.png',
                        height: 52,
                        width: 72,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 45,
                    bottom: 0,
                    child: isOpen
                        ? ClipShadowWidget(
                            clipper: UpperNipMessageClipper(MessageType.receive,
                                bubbleRadius: 8),
                            shadows: [
                              BoxShadow(
                                  color: AppColor.BLACK.withOpacity(0.1),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 2))
                            ],
                            child: Container(
                              width: 200,
                              padding: const EdgeInsets.fromLTRB(0, 0, 16, 8),
                              color: Colors.white,
                              height: 90,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      bankAccount.isValidService
                                          ? 'Tài khoản sắp hết hạn'
                                          : 'Tài khoản đã hết hạn',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      // textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    bankAccount.isValidService
                                        ? RichText(
                                            text: TextSpan(
                                                text: 'Còn',
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: AppColor.BLACK),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        ' ${inclusiveDays(bankAccount.validFeeTo)} ngày',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            AppColor.RED_TEXT),
                                                  ),
                                                  const TextSpan(
                                                    text: ' hết hạn dịch vụ',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: AppColor.BLACK),
                                                  ),
                                                ]),
                                          )
                                        : const SizedBox.shrink(),
                                    InkWell(
                                      onTap: () {
                                        extendKey(bankAccount);
                                      },
                                      child: Container(
                                        width: 110,
                                        margin: const EdgeInsets.only(top: 5),
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            gradient: VietQRTheme
                                                .gradientColor.lilyLinear),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.history,
                                              color: AppColor.BLACK,
                                              size: 15,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (bankAccount.isValidService &&
                                                      inclusiveDays(bankAccount
                                                              .validFeeTo) >=
                                                          -7)
                                                  ? 'Gia hạn ngay'
                                                  : 'Đăng ký ngay',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.normal),
                                              // textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(
                    width: 250,
                    height: 150,
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  void extendKey(BankAccountDTO bankSelect) {
    Provider.of<MaintainChargeProvider>(context, listen: false)
        .selectedBank(bankSelect.bankAccount, bankSelect.bankShortName);
    showDialogActiveKey(
      context,
      bankId: bankSelect.id,
      bankCode: bankSelect.bankCode,
      bankName: bankSelect.bankName,
      bankAccount: bankSelect.bankAccount,
      userBankName: bankSelect.userBankName,
    );
  }
}
