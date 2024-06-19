import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import '../../../models/bank_account_dto.dart';
import '../../../services/providers/connect_lark_provider.dart';
import '../../bank_card/events/bank_event.dart';

class ChooseBankPage extends StatefulWidget {
  const ChooseBankPage({super.key});

  @override
  State<ChooseBankPage> createState() => _ChooseBankPageState();
}

class _ChooseBankPageState extends State<ChooseBankPage> {
  final BankBloc _bankBloc = getIt.get<BankBloc>();
  String userId = SharePrefUtils.getProfile().userId;

  final ValueNotifier<List<BankAccountDTO>> banks = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _bankBloc.add(BankCardEventGetList());
  }

  @override
  void dispose() {
    banks.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BankBloc, BankState>(
      bloc: _bankBloc,
      listener: (context, state) {
        List<BankAccountDTO> listBank = state.listBanks
            .where((dto) => dto.userId == userId && dto.isAuthenticated)
            .toList();
        banks.value = listBank;
        for (var dto in listBank) {
          Provider.of<ConnectLarkProvider>(context, listen: false)
              .addAll(dto.id);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          renderHeader(),
          const SizedBox(height: 8),
          Expanded(child: _buildListBank()),
        ],
      ),
    );
  }

  Widget renderHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Danh sách tài khoản nhận BDSD qua Lark',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: AppColor.WHITE),
          child: Row(
            children: [
              const Text(
                'Tất cả tài khoản đã liên kết',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Consumer<ConnectLarkProvider>(
                  builder: (context, provider, child) {
                return Text(
                  provider.chooseAllBank ? 'Bật' : 'Tắt',
                  style:
                      const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                );
              }),
              Consumer<ConnectLarkProvider>(
                  builder: (context, provider, child) {
                return Switch(
                  value: provider.chooseAllBank,
                  activeColor: AppColor.BLUE_TEXT,
                  onChanged: (bool value) {
                    if (value) {
                      for (var dto in banks.value) {
                        provider.addAllListBank(dto.id);
                      }
                    }
                    provider.updateChooseAllBank(value);
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListBank() {
    return ValueListenableBuilder<List<BankAccountDTO>>(
        valueListenable: banks,
        builder: (context, listBank, _) {
          return ListView.separated(
              itemBuilder: (context, index) {
                final BankAccountDTO bank = listBank[index];
                return Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColor.WHITE),
                  child: Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: AppColor.WHITE,
                          borderRadius: BorderRadius.circular(40),
                          border:
                              Border.all(width: 0.5, color: AppColor.GREY_TEXT),
                          image: DecorationImage(
                            image: ImageUtils.instance.getImageNetWork(
                              bank.imgId,
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 10)),
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
                      Consumer<ConnectLarkProvider>(
                          builder: (context, provider, child) {
                        return Text(
                          provider.bankIds.contains(bank.id) ? 'Bật' : 'Tắt',
                          style: const TextStyle(
                              fontSize: 12, color: AppColor.GREY_TEXT),
                        );
                      }),
                      Consumer<ConnectLarkProvider>(
                          builder: (context, provider, child) {
                        return Switch(
                          value: provider.bankIds.contains(bank.id),
                          activeColor: AppColor.BLUE_TEXT,
                          onChanged: (bool value) {
                            provider.updateListBank(bank.id);
                          },
                        );
                      }),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8);
              },
              itemCount: listBank.length);
        });
  }
}
