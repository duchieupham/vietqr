import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dashed_line.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/models/bank_account_terminal.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import '../../../commons/di/injection/injection.dart';

class BottomSheetAddBankBDSD extends StatefulWidget {
  final String terminalId;

  final Function(BankAccountTerminal) onSelect;

  const BottomSheetAddBankBDSD(
      {super.key, required this.onSelect, this.terminalId = ''});

  @override
  State<BottomSheetAddBankBDSD> createState() => _BottomSheetAddBankBDSDState();
}

class _BottomSheetAddBankBDSDState extends State<BottomSheetAddBankBDSD> {
  final BankBloc _bankBloc = getIt.get<BankBloc>();
  String userId = SharePrefUtils.getProfile().userId;

  @override
  void initState() {
    super.initState();
    _bankBloc.add(GetListBankAccountTerminal(
        userId: SharePrefUtils.getProfile().userId,
        terminalId: widget.terminalId));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Spacer(),
            const SizedBox(
              width: 48,
            ),
            const Text(
              'Thêm tài khoản chia sẻ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.clear,
                size: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Danh sách tài khoản',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          'Hiển thị các tài khoản đã liên kết để chia sẻ biến động số dư.',
          style: TextStyle(
              color: AppColor.GREY_TEXT.withOpacity(0.8), fontSize: 12),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
            child: BlocBuilder<BankBloc, BankState>(
          bloc: _bankBloc,
          builder: (context, state) {
            List<BankAccountTerminal> listBank = state.listBankAccountTerminal
                .where((dto) => dto.userId == userId)
                .toList();
            return ListView.separated(
                itemBuilder: (context, index) {
                  final BankAccountTerminal bank = listBank[index];

                  return Container(
                    height: 54,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColor.BLACK_BUTTON.withOpacity(0.5),
                            width: 0.5),
                        color: AppColor.WHITE),
                    child: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: AppColor.WHITE,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                                width: 0.5, color: AppColor.GREY_TEXT),
                            image: DecorationImage(
                              image: ImageUtils.instance.getImageNetWork(
                                bank.imgId,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 53,
                          child: VerticalDashedLine(),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bank.getBankCodeAndName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: AppColor.BLACK,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                bank.userBankName.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColor.BLACK,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ButtonWidget(
                          borderRadius: 5,
                          text: 'Thêm',
                          width: 70,
                          height: 32,
                          textColor: AppColor.WHITE,
                          bgColor: AppColor.BLUE_TEXT,
                          function: () {
                            Navigator.pop(context);
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              widget.onSelect(bank);
                            });
                          },
                          fontSize: 12,
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 12,
                  );
                },
                itemCount: listBank.length);
          },
        )),
      ],
    );
  }
}
