part of '../bank_screen.dart';

class BanksAuthenticated extends StatefulWidget {
  const BanksAuthenticated({super.key});

  @override
  State<BanksAuthenticated> createState() => _BanksAuthenticatedState();
}

class _BanksAuthenticatedState extends State<BanksAuthenticated>
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
        listAuthenticated.length * (heightOfItemWidget.value - 20);
  }

  @override
  void dispose() {
    heightWidget.dispose();
    heightOfItemWidget.dispose();
    super.dispose();
  }

  List<BankAccountDTO> get listAuthenticated => bankBloc.state.listBanks
      .where((element) => element.isAuthenticated == true)
      .toList();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BankBloc, BankState, List<BankAccountDTO>>(
        bloc: bankBloc,
        selector: (state) => state.listBanks,
        builder: (context, state) {
          heightWidget.value = 1;
          heightOfItemWidget.value = 1;

          if (listAuthenticated.isNotEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tài khoản liên kết',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ValueListenableBuilder<double>(
                    valueListenable: heightWidget,
                    child: Wrap(
                      children: [
                        ...listAuthenticated.map((e) {
                          int index = listAuthenticated.indexOf(e);
                          return Transform.translate(
                            offset: Offset(0, -index * 20.0),
                            child: MeasureSize(
                              onChange: (size) {
                                print(size.height);
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
                                    listAuthenticated[index].isAuthenticated,
                                listBanks: listAuthenticated,
                                index: index,
                                onLinked: () {
                                  NavigatorUtils.navigatePage(
                                      context,
                                      AddBankScreen(
                                          bankTypeDTO: listAuthenticated[index]
                                              .changeToBankTypeDTO),
                                      routeName: AddBankScreen.routeName);
                                },
                                onActive: () {
                                  Provider.of<MaintainChargeProvider>(context,
                                          listen: false)
                                      .selectedBank(
                                          listAuthenticated[index].bankAccount,
                                          listAuthenticated[index]
                                              .bankShortName);
                                  showDialogActiveKey(
                                    context,
                                    bankId: listAuthenticated[index].id,
                                    bankCode: listAuthenticated[index].bankCode,
                                    bankName: listAuthenticated[index].bankName,
                                    bankAccount:
                                        listAuthenticated[index].bankAccount,
                                    userBankName:
                                        listAuthenticated[index].userBankName,
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
                //   height: (listAuthenticated.length * 162) -
                //       listAuthenticated.length * 12 -
                //       (listAuthenticated.length - 1) * 8,
                //   width: MediaQuery.of(context).size.width,
                //   child: Stack(
                //     children: listAuthenticated.map((e) {
                //       int index = listAuthenticated.indexOf(e);
                //       return Positioned(
                //         top: index * 145,
                //         left: 0,
                //         right: 0,
                //         child: CardWidget(
                //           isExtend: false,
                //           isAuthen: listAuthenticated[index].isAuthenticated,
                //           listBanks: listAuthenticated,
                //           index: index,
                //           onLinked: () {
                //             NavigatorUtils.navigatePage(
                //                 context,
                //                 AddBankScreen(
                //                     bankTypeDTO: listAuthenticated[index]
                //                         .changeToBankTypeDTO),
                //                 routeName: AddBankScreen.routeName);
                //           },
                //           onActive: () {
                //             Provider.of<MaintainChargeProvider>(context,
                //                     listen: false)
                //                 .selectedBank(
                //                     listAuthenticated[index].bankAccount,
                //                     listAuthenticated[index].bankShortName);
                //             showDialogActiveKey(
                //               context,
                //               bankId: listAuthenticated[index].id,
                //               bankCode: listAuthenticated[index].bankCode,
                //               bankName: listAuthenticated[index].bankName,
                //               bankAccount: listAuthenticated[index].bankAccount,
                //               userBankName:
                //                   listAuthenticated[index].userBankName,
                //             );
                //           },
                //         ),
                //       );
                //     }).toList(),
                //   ),
                // ),
                const SizedBox(height: 20),
              ],
            );
          }
          return const SizedBox.shrink();
        });
  }
}
