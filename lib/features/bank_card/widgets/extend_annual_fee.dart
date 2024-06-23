part of '../bank_screen.dart';

class ExtendAnnualFee extends StatelessWidget with DialogHelper {
  const ExtendAnnualFee({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BankBloc, BankState, List<BankAccountDTO>>(
      bloc: getIt.get<BankBloc>(),
      selector: (state) => state.listBanks,
      builder: (context, state) {
        List<BankAccountDTO> extendAnnualFeeList = [];
        DateTime now = DateTime.now();
        DateTime sevenDaysFromNow = now.add(const Duration(days: 7));
        int sevenDaysFromNowTimestamp =
            sevenDaysFromNow.millisecondsSinceEpoch ~/ 1000;
        extendAnnualFeeList = state
            .where((element) =>
                element.isValidService == true &&
                element.validFeeTo! - sevenDaysFromNowTimestamp <= 7)
            .toList();
        if (extendAnnualFeeList.isNotEmpty) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 0,
              ),
              SizedBox(
                height: (extendAnnualFeeList.length *
                        (extendAnnualFeeList.length != 1 ? 120 : 135)) -
                    extendAnnualFeeList.length * 12 -
                    (extendAnnualFeeList.length - 1) * 8,
                child: Stack(
                  children: [
                    Container(
                      height: 90,
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3DF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Gia hạn dịch vụ phần mềm VietQR",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: SizedBox(
                        height: (extendAnnualFeeList.length * 100) -
                            extendAnnualFeeList.length * 12 -
                            (extendAnnualFeeList.length - 1) * 8,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            ...extendAnnualFeeList.map((e) {
                              int index = extendAnnualFeeList.indexOf(e);
                              return Positioned(
                                top: index * 65,
                                left: 0,
                                right: 0,
                                child: CardWidget(
                                  isExtend: true,
                                  isAuthen: false,
                                  listBanks: extendAnnualFeeList,
                                  index: index,
                                  onLinked: () {
                                    NavigatorUtils.navigatePage(
                                        context,
                                        AddBankScreen(
                                            bankTypeDTO:
                                                extendAnnualFeeList[index]
                                                    .changeToBankTypeDTO),
                                        routeName: AddBankScreen.routeName);
                                  },
                                  onActive: () {
                                    Provider.of<MaintainChargeProvider>(context,
                                            listen: false)
                                        .selectedBank(
                                            extendAnnualFeeList[index]
                                                .bankAccount,
                                            extendAnnualFeeList[index]
                                                .bankShortName);
                                    showDialogActiveKey(
                                      context,
                                      bankId: extendAnnualFeeList[index].id,
                                      bankCode:
                                          extendAnnualFeeList[index].bankCode,
                                      bankName:
                                          extendAnnualFeeList[index].bankName,
                                      bankAccount: extendAnnualFeeList[index]
                                          .bankAccount,
                                      userBankName: extendAnnualFeeList[index]
                                          .userBankName,
                                    );
                                  },
                                ),
                              );
                            })
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
