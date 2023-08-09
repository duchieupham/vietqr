import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/features/mobile_recharge/blocs/mobile_recharge_bloc.dart';
import 'package:vierqr/features/mobile_recharge/states/mobile_recharge_state.dart';
import 'package:vierqr/features/mobile_recharge/widget/list_network_providers.dart';
import 'package:vierqr/features/mobile_recharge/widget/pop_up_confirm_pass.dart';
import 'package:vierqr/features/mobile_recharge/widget/recharege_success.dart';

import 'package:vierqr/layouts/m_app_bar.dart';
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

  updateMobileCarrierType(BuildContext context) {
    Map<String, dynamic> param = {};

    param['userId'] = UserInformationHelper.instance.getUserId();
    param['carrierTypeId'] =
        Provider.of<TopUpProvider>(context, listen: false).networkProviders.id;
    BlocProvider.of<MobileRechargeBloc>(context)
        .add(MobileRechargeUpdateType(data: param));
  }

  updateInformationUser(BuildContext context) {
    AccountInformationDTO accountInformationDTO =
        UserInformationHelper.instance.getAccountInformation();
    AccountInformationDTO accountInformationDTONew = AccountInformationDTO(
        userId: accountInformationDTO.userId,
        firstName: accountInformationDTO.firstName,
        middleName: accountInformationDTO.middleName,
        lastName: accountInformationDTO.lastName,
        birthDate: accountInformationDTO.birthDate,
        gender: accountInformationDTO.gender,
        address: accountInformationDTO.address,
        email: accountInformationDTO.email,
        imgId: accountInformationDTO.imgId,
        nationalDate: accountInformationDTO.nationalDate,
        nationalId: accountInformationDTO.nationalId,
        oldNationalId: accountInformationDTO.oldNationalId,
        carrierTypeId: Provider.of<TopUpProvider>(context, listen: false)
            .networkProviders
            .id);
    UserInformationHelper.instance
        .setAccountInformation(accountInformationDTONew);
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
            listener: (context, state) {
              if (state is RechargeUpdateTypeUpdateSuccessState) {
                updateInformationUser(context);
              }
              if (state is MobileRechargeMobileMoneyLoadingState) {
                DialogWidget.instance
                    .openLoadingDialog(msg: 'Đang thực hiện thanh toán');
              }
              if (state is MobileRechargeMobileMoneySuccessState) {
                updateMobileCarrierType(context);
                eventBus.fire(ReloadWallet());
                Navigator.pop(context);
                Navigator.pop(context);
                Map<String, dynamic> arguments = {};
                arguments['money'] =
                    Provider.of<TopUpProvider>(context, listen: false).money;
                arguments['phoneNo'] =
                    UserInformationHelper.instance.getPhoneNo();
                Navigator.of(context)
                    .pushNamed(Routes.RECHARGE_SUCCESS, arguments: arguments);
              }
              if (state is MobileRechargeMobileMoneyFailedState) {
                Navigator.pop(context);
                DialogWidget.instance.openMsgDialog(
                    title: 'Nạp tiền thất bại',
                    msg:
                        ErrorUtils.instance.getErrorMessage(state.dto.message));
              }
              if (state is MobileRechargeGetListTypeSuccessState) {
                Provider.of<TopUpProvider>(context, listen: false)
                    .init(state.list);
              }
            },
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
                          'Số điện thoại',
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
                                  '${CurrencyUtils.instance.getCurrencyFormatted(UserInformationHelper.instance.getWalletInfo().amount ?? '0')} VQR',
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
                                                .replaceAll(',', ''))
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

                                    DialogWidget.instance.openWidgetDialog(
                                        heightPopup: 320,
                                        widthPopup: 320,
                                        margin: const EdgeInsets.only(
                                            left: 32, right: 32, bottom: 48),
                                        radius: 20,
                                        child: PopupConfirmPassword(
                                          onConfirmSuccess: (otp) {
                                            Navigator.of(context).pop();
                                            Map<String, dynamic> data = {};
                                            data['phoneNo'] =
                                                UserInformationHelper.instance
                                                    .getPhoneNo();
                                            data['userId'] =
                                                UserInformationHelper.instance
                                                    .getUserId();
                                            data['rechargeType'] =
                                                provider.rechargeType;
                                            data['otp'] = otp;
                                            data['carrierTypeId'] =
                                                provider.networkProviders.id;
                                            BlocProvider.of<MobileRechargeBloc>(
                                                    context)
                                                .add(MobileRechargeMobileMoney(
                                                    data: data));
                                          },
                                        ));
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
                String imgId = provider.networkProviders.imgId;
                if (imgId.isNotEmpty) {
                  return GestureDetector(
                    onTap: () {
                      DialogWidget.instance.showModalBottomContent(
                        context: context,
                        widget: ListNetWorkProvider(
                          list: provider.listNetworkProviders,
                          onTap: (networkProviders) {
                            provider.updateNetworkProviders(networkProviders);
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
                          image: provider.networkProviders.imgId.isNotEmpty
                              ? ImageUtils.instance.getImageNetWork(
                                  provider.networkProviders.imgId)
                              : ImageUtils.instance.getImageNetWork(imgId),
                        ),
                      ),
                    ),
                  );
                } else {
                  return _buildBlankLogo(
                      context, provider.listNetworkProviders, provider);
                }
              }),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          StringUtils.instance.formatPhoneNumberVN(phoneNumber),
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        )
                        // SizedBox(
                        //   width: 94,
                        //   height: 22,
                        //   child: TextField(
                        //     controller:
                        //         TextEditingController(text: phoneNumber),
                        //     readOnly: true,
                        //     focusNode: myFocusNode,
                        //     style: const TextStyle(
                        //         fontWeight: FontWeight.w600, fontSize: 16),
                        //     decoration: const InputDecoration(
                        //         contentPadding: EdgeInsets.zero),
                        //   ),
                        // ),

                        // GestureDetector(
                        //   onTap: () {
                        //     myFocusNode.requestFocus();
                        //   },
                        //   child: Image.asset(
                        //     'assets/images/ic-edit-personal-setting.png',
                        //     height: 25,
                        //   ),
                        // ),
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
        return _buildSuggestMoney(provider);
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
                  provider.updateRechargeType(1);
                },
                text: '10,000',
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
                  provider.updateRechargeType(2);
                },
                text: '20,000',
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
                  provider.updateRechargeType(3);
                },
                text: '50,000',
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
                  provider.updateRechargeType(4);
                },
                text: '100,000',
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
                  provider.updateRechargeType(5);
                },
                text: '200,000',
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
                  provider.updateRechargeType(6);
                },
                text: '500,000',
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
