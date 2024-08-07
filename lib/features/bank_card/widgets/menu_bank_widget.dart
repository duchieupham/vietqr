import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/features/bank_detail_new/bank_card_detail_new_screen.dart';
import 'package:vierqr/features/create_qr/create_qr_screen.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/share_bdsd/share_bdsd_screen.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/navigator/app_navigator.dart';
import 'package:vierqr/services/providers/maintain_charge_provider.dart';

import '../../../commons/helper/dialog_helper.dart';

class MenuBankWidget extends StatefulWidget {
  final VoidCallback onStore;
  const MenuBankWidget({
    super.key,
    required this.onStore,
  });

  @override
  State<MenuBankWidget> createState() => _MenuBankWidgetState();
}

class _MenuBankWidgetState extends State<MenuBankWidget> with DialogHelper {
  final BankBloc bankBloc = getIt.get<BankBloc>();

  List<MenuItem> menus = [
    MenuItem(
        icon: 'assets/images/ic-vietqr-trans.png',
        title: 'Tạo QR\ngiao dịch',
        type: 0),
    MenuItem(
        icon: 'assets/images/ic-scan-qr-home.png',
        title: 'Mã VietQR\ncủa tôi',
        type: 1),
    MenuItem(
        icon: 'assets/images/ic-share-bdsd-blue.png',
        title: 'Chia sẻ BĐSD',
        type: 2),
    MenuItem(
        icon: 'assets/images/ic-store-blue.png',
        title: 'Quản lý\ncửa hàng',
        type: 3),
    MenuItem(
        icon: 'assets/images/ic-i-blue.png', title: 'Chi tiết TK', type: 4),
    MenuItem(
        icon: 'assets/images/ic-menu-blue.png', title: 'Lịch sử GD', type: 5),
    MenuItem(
        icon: 'assets/images/ic-trans-statistic-blue.png',
        title: 'Thống kê GD',
        type: 6),
    MenuItem(
        icon: 'assets/images/ic-extend-fee.png',
        title: 'Gia hạn dịch vụ',
        type: 7),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BankBloc, BankState>(
      bloc: bankBloc,
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 150,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            primary: false,
            itemCount: menus.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.2, // Adjust this ratio as needed
            ),
            itemBuilder: (context, index) {
              MenuItem item = menus[index];
              return InkWell(
                onTap: state.status == BlocStatus.SUCCESS ||
                        state.status == BlocStatus.UNLOADING
                    ? () {
                        switch (item.type) {
                          case 0:
                            NavigatorUtils.navigatePage(
                                context,
                                CreateQrScreen(
                                    bankAccountDTO: state.bankSelect!),
                                routeName: CreateQrScreen.routeName);

                            break;
                          case 1:
                            if (state.listBanks.isNotEmpty) {
                              NavigationService.push(Routes.MY_VIETQR_SCREEN,
                                  arguments: {
                                    'list': state.listBanks,
                                    'dto': state.bankSelect,
                                  });
                            } else {
                              NavigatorUtils.navigatePage(
                                  context, const AddBankScreen(),
                                  routeName: AddBankScreen.routeName);
                            }

                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => BankCardDetailNewScreen(
                            //         page: 0,
                            //         dto: state.bankSelect!,
                            //         bankId: state.bankSelect!.id),
                            //     settings: const RouteSettings(
                            //       name: Routes.BANK_CARD_DETAIL_NEW,
                            //     ),
                            //   ),
                            // );
                            break;
                          case 2:
                            NavigatorUtils.navigatePage(
                              context,
                              const ShareBDSDScreen(),
                              routeName: 'share_bdsd_screen',
                            );
                            break;
                          case 3:
                            widget.onStore.call();
                            break;
                          case 4:
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BankCardDetailNewScreen(
                                    page: 0,
                                    dto: state.bankSelect!,
                                    bankId: state.bankSelect!.id),
                                settings: const RouteSettings(
                                  name: Routes.BANK_CARD_DETAIL_NEW,
                                ),
                              ),
                            );
                            break;
                          case 5:
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BankCardDetailNewScreen(
                                    page: 1,
                                    dto: state.bankSelect!,
                                    bankId: state.bankSelect!.id),
                                settings: const RouteSettings(
                                  name: Routes.BANK_CARD_DETAIL_NEW,
                                ),
                              ),
                            );
                            break;
                          case 6:
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BankCardDetailNewScreen(
                                    page: 3,
                                    dto: state.bankSelect!,
                                    bankId: state.bankSelect!.id),
                                settings: const RouteSettings(
                                  name: Routes.BANK_CARD_DETAIL_NEW,
                                ),
                              ),
                            );
                            break;
                          case 7:
                            Provider.of<MaintainChargeProvider>(context,
                                    listen: false)
                                .selectedBank(state.bankSelect!.bankAccount,
                                    state.bankSelect!.bankShortName);
                            showDialogActiveKey(
                              context,
                              bankId: state.bankSelect!.id,
                              bankCode: state.bankSelect!.bankCode,
                              bankName: state.bankSelect!.bankName,
                              bankAccount: state.bankSelect!.bankAccount,
                              userBankName: state.bankSelect!.userBankName,
                            );
                            break;
                          default:
                        }
                      }
                    : null,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        item.icon,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class MenuItem {
  final String icon;
  final String title;
  final int type;

  MenuItem({required this.icon, required this.title, required this.type});
}
