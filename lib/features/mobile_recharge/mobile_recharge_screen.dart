import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/features/mobile_recharge/blocs/mobile_recharge_bloc.dart';
import 'package:vierqr/features/mobile_recharge/states/mobile_recharge_state.dart';
import 'package:vierqr/features/mobile_recharge/widget/list_network_providers.dart';
import 'package:vierqr/features/top_up/blocs/top_up_bloc.dart';
import 'package:vierqr/features/top_up/events/scan_qr_event.dart';
import 'package:vierqr/features/top_up/states/top_up_state.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/account_information_dto.dart';
import 'package:vierqr/models/network_providers_dto.dart';
import 'package:vierqr/services/providers/top_up_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import 'events/mobile_recharge_event.dart';

class MobileRechargeScreen extends StatelessWidget {
  MobileRechargeScreen({super.key});
  late FocusNode myFocusNode = FocusNode();
  String getIdImage(List<NetworkProviders> list) {
    String imgId = '';
    AccountInformationDTO accountInformationDTO =
        UserInformationHelper.instance.getAccountInformation();
    for (var element in list) {
      if (accountInformationDTO.carrierTypeId == element.id) {
        imgId = element.imgId;
        return imgId;
      }
    }
    return imgId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(title: 'Nạp tiền điện thoại'),
      body: ChangeNotifierProvider(
        create: (context) => TopUpProvider(),
        child: BlocProvider<MobileRechargeBloc>(
          create: (context) =>
              MobileRechargeBloc()..add(MobileRechargeGetListType()),
          child: BlocConsumer<MobileRechargeBloc, MobileRechargeState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        _buildTemplateSection(
                          'Số điệnt thoại',
                          child: _buildPhoneNumber(context,
                              accountInformationDTO: UserInformationHelper
                                  .instance
                                  .getAccountInformation(),
                              phoneNumber:
                                  UserInformationHelper.instance.getPhoneNo()),
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        _buildTemplateSection('Mệnh giá', child: _buildTopUp())
                      ],
                    ),
                  ),
                  Consumer<TopUpProvider>(builder: (context, provider, child) {
                    return Container(
                      padding:
                          const EdgeInsets.fromLTRB(0, 16, 0, kToolbarHeight),
                      color: AppColor.WHITE,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Số dư tài khoản VietQR: ',
                                  style: TextStyle(fontSize: 10),
                                ),
                                Text(
                                  '${CurrencyUtils.instance.getCurrencyFormatted(UserInformationHelper.instance.getWalletInfo().amount ?? '0')} VND',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, Routes.TOP_UP);
                                  },
                                  child: Text(
                                    int.parse(UserInformationHelper.instance
                                                    .getWalletInfo()
                                                    .amount ??
                                                '0') <
                                            int.parse(provider.money
                                                .replaceAll('.', ''))
                                        ? 'Không đủ thanh toán.\n Nạp ngay'
                                        : 'Nạp thêm',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColor.BLUE_TEXT),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: DividerWidget(
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Tổng tiền cần thanh toán:',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        '${provider.money} VND',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    Map<String, dynamic> data = {};
                                    data['phoneNo'] = UserInformationHelper
                                        .instance
                                        .getPhoneNo();
                                    data['amount'] =
                                        provider.money.replaceAll(',', '');
                                    data['transType'] = 'C';
                                    // BlocProvider.of<TopUpBloc>(context)
                                    //     .add(TopUpEventCreateQR(data: data));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColor.BLUE_TEXT),
                                    child: const Text(
                                      'Thanh toán',
                                      style: TextStyle(color: AppColor.WHITE),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumber(BuildContext context,
      {required AccountInformationDTO accountInformationDTO,
      required String phoneNumber}) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 12),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            children: [
              Consumer<TopUpProvider>(builder: (context, provider, child) {
                return BlocConsumer<MobileRechargeBloc, MobileRechargeState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is MobileRechargeGetListTypeSuccessState) {
                        String imgId = getIdImage(state.list);
                        if (imgId.isNotEmpty) {
                          return GestureDetector(
                            onTap: () {
                              DialogWidget.instance.showModalBottomContent(
                                context: context,
                                widget: ListNetWorkProvider(
                                  list: state.list,
                                  onTap: (networkProviders) {
                                    provider.updateNetworkProviders(
                                        networkProviders);
                                  },
                                ),
                                height: height * 0.6,
                              );
                            },
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    width: 0.5,
                                    color: AppColor.GREY_TEXT.withOpacity(0.3)),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      provider.networkProviders.imgId.isNotEmpty
                                          ? ImageUtils.instance.getImageNetWork(
                                              provider.networkProviders.imgId)
                                          : ImageUtils.instance
                                              .getImageNetWork(imgId),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return _buildBlankLogo(context, state.list, provider);
                        }
                      }
                      return const SizedBox.shrink();
                    });
              }),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 94,
                          height: 22,
                          child: TextField(
                            controller:
                                TextEditingController(text: phoneNumber),
                            focusNode: myFocusNode,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            myFocusNode.requestFocus();
                          },
                          child: Image.asset(
                            'assets/images/ic-edit-personal-setting.png',
                            height: 25,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${accountInformationDTO.lastName} ${accountInformationDTO.middleName} ${accountInformationDTO.firstName}'
                          .trim(),
                      style: const TextStyle(
                          fontSize: 10, color: AppColor.GREY_TEXT),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopUp() {
    return Consumer<TopUpProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            MTextFieldCustom(
              isObscureText: false,
              maxLines: 1,
              value: provider.money,
              fillColor: AppColor.WHITE,
              autoFocus: true,
              hintText: 'Nhập số tiền muốn nạp',
              inputType: TextInputType.number,
              keyboardAction: TextInputAction.next,
              onChange: provider.updateMoney,
              suffixIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'VND',
                    style: TextStyle(fontSize: 14, color: AppColor.gray),
                  ),
                ],
              ),
              inputFormatter: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            if (provider.errorMoney.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  provider.errorMoney,
                  style:
                      const TextStyle(fontSize: 13, color: AppColor.RED_TEXT),
                ),
              ),
            const SizedBox(height: 16),
            _buildSuggestMoney(provider),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildSuggestMoney(TopUpProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildItemSuggest(
                onChange: (value) {
                  provider.updateMoney(value);
                },
                text: '10.000',
                money: provider.money,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: _buildItemSuggest(
                onChange: (value) {
                  provider.updateMoney(value);
                },
                text: '20.000',
                money: provider.money,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: _buildItemSuggest(
                onChange: (value) {
                  provider.updateMoney(value);
                },
                text: '50.000',
                money: provider.money,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Expanded(
              child: _buildItemSuggest(
                onChange: (value) {
                  provider.updateMoney(value);
                },
                text: '100.000',
                money: provider.money,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: _buildItemSuggest(
                onChange: (value) {
                  provider.updateMoney(value);
                },
                text: '200.000',
                money: provider.money,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: _buildItemSuggest(
                onChange: (value) {
                  provider.updateMoney(value);
                },
                text: '500.000',
                money: provider.money,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemSuggest({
    ValueChanged<String>? onChange,
    required String text,
    required String money,
  }) {
    return GestureDetector(
      onTap: () {
        onChange!(text);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: text == money
                ? Border.all(color: AppColor.BLUE_TEXT, width: 0.8)
                : Border.all(color: AppColor.WHITE, width: 0.8),
            color: text == money
                ? AppColor.BLUE_TEXT.withOpacity(0.3)
                : AppColor.WHITE,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                    fontWeight:
                        text == money ? FontWeight.w600 : FontWeight.w400,
                    height: 1.4,
                    color: text == money ? AppColor.BLUE_TEXT : AppColor.BLACK),
              ),
            ],
          )),
    );
  }

  Widget _buildTemplateSection(String title, {required Widget child}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(
          height: 8,
        ),
        child,
      ],
    );
  }

  Widget _buildBlankLogo(BuildContext context, List<NetworkProviders> list,
      TopUpProvider provider) {
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        DialogWidget.instance.showModalBottomContent(
          context: context,
          widget: ListNetWorkProvider(
            list: list,
            onTap: (networkProviders) {
              provider.updateNetworkProviders(networkProviders);
            },
          ),
          height: height * 0.6,
        );
      },
      child: Container(
        height: 45,
        width: 45,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              width: 0.5, color: AppColor.GREY_TEXT.withOpacity(0.3)),
          image: provider.networkProviders.imgId.isNotEmpty
              ? DecorationImage(
                  fit: BoxFit.cover,
                  image: ImageUtils.instance
                      .getImageNetWork(provider.networkProviders.imgId),
                )
              : null,
        ),
        child: provider.networkProviders.imgId.isEmpty
            ? const Text(
                'Chọn nhà\nmạng',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
