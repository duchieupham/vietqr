import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/models/bank_account_terminal.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class BottomSheetAddBankBDSD extends StatelessWidget {
  final String terminalId;

  final Function(BankAccountTerminal) onSelect;
  const BottomSheetAddBankBDSD(
      {Key? key, required this.onSelect, this.terminalId = ''})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<BankBloc>(
      create: (context) => BankBloc(context)
        ..add(GetListBankAccountTerminal(
            userId: UserHelper.instance.getUserId(), terminalId: terminalId)),
      child: BlocConsumer<BankBloc, BankState>(
          listener: (context, state) async {},
          builder: (context, state) {
            String userId = UserHelper.instance.getUserId();
            List<BankAccountTerminal> listBank = state.listBankAccountTerminal
                .where((dto) => dto.userId == userId)
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    const SizedBox(
                      width: 48,
                    ),
                    Text(
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
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Danh sách tài khoản',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Hiển thị các tài khoản đã liên kết để chia sẻ biến động số dư.',
                  style: TextStyle(color: AppColor.GREY_TEXT, fontSize: 12),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 60,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: AppColor.BLACK_BUTTON
                                          .withOpacity(0.5),
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
                                          width: 0.5,
                                          color: AppColor.GREY_TEXT),
                                      image: DecorationImage(
                                        image:
                                            ImageUtils.instance.getImageNetWork(
                                          listBank[index].imgId,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 10)),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${listBank[index].bankCode} - ${listBank[index].bankAccount}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: AppColor.BLACK,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        listBank[index]
                                            .userBankName
                                            .toUpperCase(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: AppColor.BLACK,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  ButtonWidget(
                                    borderRadius: 5,
                                    text: 'Thêm',
                                    width: 70,
                                    height: 32,
                                    textColor: AppColor.WHITE,
                                    bgColor: AppColor.BLUE_TEXT,
                                    function: () {
                                      Navigator.pop(context);
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        onSelect(listBank[index]);
                                      });
                                    },
                                    fontSize: 12,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 12,
                          );
                        },
                        itemCount: listBank.length)),
              ],
            );
          }),
    );
  }
}
