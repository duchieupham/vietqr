import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class BottomSheetAddBankAccount extends StatefulWidget {
  final Function(BankAccountDTO) onSelect;

  const BottomSheetAddBankAccount({super.key, required this.onSelect});

  @override
  State<BottomSheetAddBankAccount> createState() =>
      _BottomSheetAddBankAccountState();
}

class _BottomSheetAddBankAccountState extends State<BottomSheetAddBankAccount> {
  final BankBloc _bankBloc = getIt.get<BankBloc>();
  String userId = SharePrefUtils.getProfile().userId;

  @override
  void initState() {
    super.initState();
    // _bankBloc.add(BankCardEventGetList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        renderHeader(),
        const SizedBox(
          height: 20,
        ),
        Expanded(child: renderContent()),
      ],
    );
  }

  Widget renderHeader() {
    return Row(
      children: [
        const Spacer(),
        const SizedBox(
          width: 48,
        ),
        const Text(
          'Chọn tài khoản',
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
    );
  }

  Widget renderContent() {
    return BlocBuilder<BankBloc, BankState>(
      bloc: _bankBloc,
      builder: (context, state) {
        List<BankAccountDTO> listBank = state.listBanks
            .where((dto) => dto.userId == userId && dto.isAuthenticated)
            .toList();
        return ListView.separated(
            itemBuilder: (context, index) {
              final BankAccountDTO bank = listBank[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 500), () {
                    widget.onSelect(bank);
                  });
                },
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppColor.BLACK_BUTTON.withOpacity(0.5),
                        width: 0.5),
                    color: AppColor.WHITE,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: AppColor.WHITE,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                              width: 0.5, color: AppColor.GREY_BORDER),
                          image: DecorationImage(
                            image: ImageUtils.instance.getImageNetWork(
                              bank.imgId,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
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
                      const Spacer(),
                    ],
                  ),
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
    );
  }
}
