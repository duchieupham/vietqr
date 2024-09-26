part of '../bank_screen.dart';

class BanksUnAuthenticated extends StatefulWidget {
  const BanksUnAuthenticated({super.key});

  @override
  State<BanksUnAuthenticated> createState() => _BanksUnAuthenticatedState();
}

class _BanksUnAuthenticatedState extends State<BanksUnAuthenticated>
    with DialogHelper {
  final ValueNotifier<double> heightWidget = ValueNotifier(1);
  final ValueNotifier<double> heightOfItemWidget = ValueNotifier(1);

  final BankBloc bankBloc = getIt.get<BankBloc>();

  @override
  void initState() {
    super.initState();
    heightWidget.value = 1;
    heightOfItemWidget.value = 1;
  }

  void _afterLayout() {
    heightWidget.value =
        listUnAuthenticated.length * (heightOfItemWidget.value - 20);
  }

  List<BankAccountDTO> get listUnAuthenticated => bankBloc.state.listBanks
      .where((element) => element.isAuthenticated == false)
      .toList();

  @override
  void dispose() {
    heightWidget.dispose();
    heightOfItemWidget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BankBloc, BankState, List<BankAccountDTO>>(
        bloc: bankBloc,
        selector: (state) => state.listBanks,
        builder: (context, state) {
          heightWidget.value = 1;
          heightOfItemWidget.value = 1;
          if (listUnAuthenticated.isNotEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tài khoản lưu trữ',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // const SizedBox(height: 12),

                ValueListenableBuilder<double>(
                    valueListenable: heightWidget,
                    child: Wrap(
                      children: [
                        ...listUnAuthenticated.map((e) {
                          int index = listUnAuthenticated.indexOf(e);
                          return Transform.translate(
                            offset: Offset(0, -index * 20.0),
                            child: MeasureSize(
                              onChange: (size) {
                                if (heightOfItemWidget.value == 1) {
                                  heightOfItemWidget.value = size.height;
                                  if (heightWidget.value == 1) {
                                    _afterLayout();
                                  }
                                }
                              },
                              child: CardWidget(
                                isExtend: false,
                                isAuthen:
                                    listUnAuthenticated[index].isAuthenticated,
                                listBanks: listUnAuthenticated,
                                index: index,
                                onLinked: () {
                                  NavigatorUtils.navigatePage(
                                      context,
                                      AddBankScreen(
                                          bankTypeDTO:
                                              listUnAuthenticated[index]
                                                  .changeToBankTypeDTO),
                                      routeName: AddBankScreen.routeName);
                                },
                                onActive: () {
                                  Provider.of<MaintainChargeProvider>(context,
                                          listen: false)
                                      .selectedBank(
                                          listUnAuthenticated[index]
                                              .bankAccount,
                                          listUnAuthenticated[index]
                                              .bankShortName);
                                  showDialogActiveKey(
                                    context,
                                    bankId: listUnAuthenticated[index].id,
                                    bankCode:
                                        listUnAuthenticated[index].bankCode,
                                    bankName:
                                        listUnAuthenticated[index].bankName,
                                    bankAccount:
                                        listUnAuthenticated[index].bankAccount,
                                    userBankName:
                                        listUnAuthenticated[index].userBankName,
                                  );
                                },
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                    builder: (context, heightOfWidget, child) {
                      return SizedBox(
                        height: heightOfWidget,
                        child: child,
                      );
                    }),

                // SizedBox(
                //   height: (listUnAuthenticated.length * 126) -
                //       listUnAuthenticated.length * 12 -
                //       (listUnAuthenticated.length - 1) * 8,
                //   width: MediaQuery.of(context).size.width,
                //   child: Stack(
                //     children: listUnAuthenticated.map((e) {
                //       int index = listUnAuthenticated.indexOf(e);
                //       return Positioned(
                //         top: index * 106,
                //         left: 0,
                //         right: 0,
                //         child: CardWidget(
                //           isExtend: false,
                //           isAuthen: listUnAuthenticated[index].isAuthenticated,
                //           listBanks: listUnAuthenticated,
                //           index: index,
                //           onLinked: () {
                //             NavigatorUtils.navigatePage(
                //                 context,
                //                 AddBankScreen(
                //                     bankTypeDTO: listUnAuthenticated[index]
                //                         .changeToBankTypeDTO),
                //                 routeName: AddBankScreen.routeName);
                //           },
                //           onActive: () {
                //             Provider.of<MaintainChargeProvider>(context,
                //                     listen: false)
                //                 .selectedBank(
                //                     listUnAuthenticated[index].bankAccount,
                //                     listUnAuthenticated[index].bankShortName);
                //             showDialogActiveKey(
                //               context,
                //               bankId: listUnAuthenticated[index].id,
                //               bankCode: listUnAuthenticated[index].bankCode,
                //               bankName: listUnAuthenticated[index].bankName,
                //               bankAccount:
                //                   listUnAuthenticated[index].bankAccount,
                //               userBankName:
                //                   listUnAuthenticated[index].userBankName,
                //             );
                //           },
                //         ),
                //       );
                //     }).toList(),
                //   ),
                // ),
                const SizedBox(height: 24),
              ],
            );
          }
          return const SizedBox.shrink();
        });
  }
}
