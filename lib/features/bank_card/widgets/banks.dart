part of '../bank_screen.dart';

class BanksView extends StatelessWidget {
  const BanksView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BankBloc, BankState>(
      bloc: getIt.get<BankBloc>(),
      builder: (context, state) {
        bool isEmpty = state.isEmpty;
        List<BankTypeDTO> list = state.listBankTypeDTO;
        List<BankAccountDTO> listBanks = state.listBanks;

        if (isEmpty || listBanks.length <= 5) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Thêm tài khoản ngân hàng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 2,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  var data = list[index];
                  return GestureDetector(
                    onTap: () async {
                      await NavigatorUtils.navigatePage(
                          context, AddBankScreen(bankTypeDTO: data),
                          routeName: AddBankScreen.routeName);
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColor.WHITE,
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.BLACK.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              )
                            ],
                            image: data.fileBank != null
                                ? DecorationImage(
                                    image: FileImage(data.fileBank!))
                                : DecorationImage(
                                    image: ImageUtils.instance
                                        .getImageNetWork(data.imageId)),
                          ),
                          margin: const EdgeInsets.all(4),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: data.linkType == LinkBankType.LINK
                              ? const XImage(
                                  imagePath: ImageConstant.icAuthenticatedBank,
                                  width: 20)
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
