import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/extensions/string_extension.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/button_gradient_border_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/account/account_screen.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/features/bank_detail_new/widgets/service_vietqr_widget.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_arrange_dto.dart';
import 'package:vierqr/navigator/app_navigator.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import 'reorder_list_bank_widget.dart';

class BankAppbarWidget extends StatefulWidget {
  final ValueNotifier<double> notifier;
  const BankAppbarWidget({super.key, required this.notifier});

  @override
  State<BankAppbarWidget> createState() => _BankAppbarWidgetState();
}

class _BankAppbarWidgetState extends State<BankAppbarWidget> {
  final BankBloc bankBloc = getIt.get<BankBloc>();

  void reorderList(List<BankAccountDTO> list) async {
    await DialogWidget.instance
        .showModelBottomSheet(
      height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width,
      borderRadius: BorderRadius.circular(0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      margin: EdgeInsets.zero,
      widget: ReOrderListBankWidget(
        list: list,
      ),
    )
        .then(
      (value) {
        if (value != null) {
          List<BankAccountDTO> list = value;
          bankBloc
              .add(ArrangeBankListEvent(list: mapBankAccountsToArranges(list)));
        }
      },
    );
  }

  List<BankArrangeDTO> mapBankAccountsToArranges(
      List<BankAccountDTO> bankAccounts) {
    return bankAccounts
        .asMap()
        .entries
        .map((entry) => BankArrangeDTO(
              bankId: entry.value.id,
              index: entry.key,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BankBloc, BankState>(
      bloc: bankBloc,
      builder: (context, state) {
        return ValueListenableBuilder<double>(
          valueListenable: widget.notifier,
          builder: (context, opacity, child) {
            return SliverAppBar(
              // expandedHeight: 120,

              forceMaterialTransparency: true,
              // backgroundColor: opacity == 1.0
              //     ? AppColor.TRANSPARENT
              //     : AppColor.WHITE,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  // height: 120,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    // color: opacity == 0.0
                    //     ? AppColor.TRANSPARENT
                    //     : AppColor.WHITE,
                    // gradient: opacity == 0.0
                    //     ? VietQRTheme.gradientColor.lilyLinear
                    //     : const LinearGradient(
                    //         colors: [Colors.white, Colors.white]),
                  ),
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                          bottom: 0,
                          left: opacity == 1.0 ? null : 0,
                          right: 0,
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 300),
                          child: InkWell(
                            onTap: () {
                              getIt.get<BankBloc>().add(
                                  const BankCardEventGetList(
                                      isGetOverview: true,
                                      isLoadInvoice: false));
                            },
                            child: const XImage(
                              imagePath: 'assets/images/ic-viet-qr.png',
                              height: 35,
                              width: 92,
                              fit: BoxFit.fitHeight,
                            ),
                          )),
                      if (opacity == 0.0)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Row(
                            children: [
                              VietQRButton.solid(
                                width: 40,
                                height: 40,
                                borderRadius: 100,
                                onPressed: () async {
                                  await NavigatorUtils.navigatePage(
                                      context, const AddBankScreen(),
                                      routeName: AddBankScreen.routeName);
                                },
                                isDisabled: false,
                                size: VietQRButtonSize.medium,
                                child: const Center(
                                  child: XImage(
                                    imagePath: 'assets/images/ic-bank-add.png',
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              (state.listBanks.isNotEmpty &&
                                      state.bankSelect != null &&
                                      !state.isEmpty)
                                  ? VietQRButton.solid(
                                      width: 40,
                                      height: 40,
                                      borderRadius: 100,
                                      onPressed: () {
                                        if (state.listBanks.isNotEmpty) {
                                          reorderList(state.listBanks);
                                        }
                                      },
                                      isDisabled: false,
                                      size: VietQRButtonSize.medium,
                                      child: const Center(
                                        child: XImage(
                                          imagePath:
                                              'assets/images/ic-options-black.png',
                                          height: 30,
                                          width: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                        ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          child: Row(
                            children: [
                              _buildAvatar(),
                              if (opacity == 1.0 &&
                                  state.bankSelect != null) ...[
                                AnimatedOpacity(
                                  opacity: 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: GradientBorderButton(
                                                widget: XImage(
                                                  imagePath:
                                                      '${getIt.get<AppConfig>().getBaseUrl}images/${state.bankSelect!.imgId}',
                                                  width: 20,
                                                  height: 20,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                borderWidth: 1,
                                                gradient: VietQRTheme
                                                    .gradientColor.lilyLinear),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            state.bankSelect!.bankAccount,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(width: 6),
                                          XImage(
                                            imagePath: state
                                                    .bankSelect!.mmsActive
                                                ? 'assets/images/ic-diamond-pro.png'
                                                : 'assets/images/ic-diamond.png',
                                            width: 25,
                                            height: 25,
                                          ),
                                          GradientText(
                                            !state.bankSelect!.mmsActive
                                                ? 'VietQR Plus'
                                                : 'VietQR Pro',
                                            gradient:
                                                !state.bankSelect!.mmsActive
                                                    ? VietQRTheme.gradientColor
                                                        .brightBlueLinear
                                                    : VietQRTheme.gradientColor
                                                        .vietQrPro,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColor.WHITE),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ]
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAvatar() {
    String imgId = SharePrefUtils.getProfile().imgId;
    return Consumer<AuthenProvider>(
      builder: (context, provider, child) {
        return InkWell(
            onTap: () async {
              await NavigationService.push(Routes.ACCOUNT);
              // await NavigatorUtils.navigatePage(context, const AccountScreen(),
              //     routeName: AccountScreen.routeName);
            },
            child: SizedBox(
              width: 40,
              height: 40,
              child: XImage(
                borderRadius: BorderRadius.circular(100),
                imagePath: provider.avatarUser.path.isEmpty
                    ? imgId.isNotEmpty
                        ? imgId.getPathIMageNetwork
                        : ImageConstant.icAvatar
                    : provider.avatarUser.path,
                errorWidget: XImage(
                  borderRadius: BorderRadius.circular(100),
                  imagePath: ImageConstant.icAvatar,
                  width: 40,
                  height: 40,
                ),
              ),
            ));
      },
    );
  }
}
