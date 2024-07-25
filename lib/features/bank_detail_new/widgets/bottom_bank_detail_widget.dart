import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/shimmer_block.dart';
import 'package:vierqr/features/bank_detail_new/blocs/transaction_bloc.dart';
import 'package:vierqr/features/bank_detail_new/states/transaction_state.dart';
import 'package:vierqr/features/create_qr/create_qr_screen.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';

class BottomBarWidget extends StatefulWidget {
  final double width;
  final int selectTab;
  final BankAccountDTO dto;

  final VoidCallback onSave;
  final VoidCallback onShare;
  const BottomBarWidget({
    super.key,
    required this.width,
    required this.dto,
    required this.selectTab,
    required this.onSave,
    required this.onShare,
  });

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  @override
  void initState() {
    super.initState();
    // bankCardBloc = getIt.get<BankCardBloc>(param1: widget.bankId, param2: true);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectTab == 2) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        width: widget.width,
        color: AppColor.WHITE.withOpacity(0.6),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 40),
              child: widget.selectTab == 0
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              NavigatorUtils.navigatePage(context,
                                  CreateQrScreen(bankAccountDTO: widget.dto),
                                  routeName: CreateQrScreen.routeName);
                            },
                            child: Container(
                              height: 40,
                              width: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF00C6FF),
                                    Color(0xFF0072FF),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  XImage(
                                    imagePath:
                                        'assets/images/qr-contact-other-white.png',
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    'Tạo QR giao dịch',
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: widget.onSave,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFE1EFFF),
                                      Color(0xFFE5F9FF)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight)),
                            child: const XImage(
                                imagePath: 'assets/images/ic-dowload.png'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: widget.onShare,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFE1EFFF),
                                      Color(0xFFE5F9FF)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight)),
                            child: const XImage(
                                imagePath: 'assets/images/ic-share-black.png'),
                          ),
                        ),
                      ],
                    )
                  : BlocConsumer<NewTransactionBloc, TransactionState>(
                      bloc: getIt.get<NewTransactionBloc>(),
                      listener: (context, state) {},
                      builder: (context, state) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Thời gian:',
                                  style: TextStyle(
                                      fontSize: 10, color: AppColor.GREY_TEXT),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  state.filter!.title,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColor.BLACK,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            if (state.status == BlocStatus.SUCCESS ||
                                state.extraData != null)
                              RichText(
                                  text: TextSpan(
                                text: state.extraData!.totalCredit == 0
                                    ? '0 '
                                    : '+ ${StringUtils.formatNumber(state.extraData!.totalCredit)} ',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColor.GREEN,
                                    fontWeight: FontWeight.bold),
                                children: const [
                                  TextSpan(
                                    text: 'VND',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: AppColor.GREY_TEXT,
                                        fontWeight: FontWeight.normal),
                                    children: [],
                                  )
                                ],
                              ))
                            else if (state.status == BlocStatus.LOADING)
                              const ShimmerBlock(
                                height: 12,
                                width: 70,
                                borderRadius: 10,
                              ),
                            if (state.status == BlocStatus.SUCCESS ||
                                state.extraData != null)
                              RichText(
                                  text: TextSpan(
                                text: state.extraData!.totalDebit == 0
                                    ? '0 '
                                    : '- ${StringUtils.formatNumber(state.extraData!.totalDebit)} ',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColor.RED_TEXT,
                                    fontWeight: FontWeight.bold),
                                children: const [
                                  TextSpan(
                                    text: 'VND',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: AppColor.GREY_TEXT,
                                        fontWeight: FontWeight.normal),
                                    children: [],
                                  )
                                ],
                              ))
                            else if (state.status == BlocStatus.LOADING)
                              const ShimmerBlock(
                                height: 12,
                                width: 70,
                                borderRadius: 10,
                              ),
                          ],
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
