part of '../bank_screen.dart';

class BanksView extends StatefulWidget {
  final FocusNode focusNode;
  const BanksView({super.key, required this.focusNode});

  @override
  State<BanksView> createState() => _BanksViewState();
}

class _BanksViewState extends State<BanksView> {
  final TextEditingController controller = TextEditingController();
  List<BankTypeDTO> list = [];
  List<BankTypeDTO> listSearch = [];
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BankBloc, BankState>(
      bloc: getIt.get<BankBloc>(),
      listener: (context, state) {
        if (state.listBankTypeDTO.isNotEmpty) {
          list = state.listBankTypeDTO;
        }
      },
      builder: (context, state) {
        bool isEmpty = state.isEmpty;
        List<BankAccountDTO> listBanks = state.listBanks;

        if (!isEmpty || listBanks.length <= 5) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Chúng tôi hỗ trợ các ngân hàng',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Text(
                'Chọn ngân hàng để thực hiện thao tác thêm/liên kết.',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 16),
              GradientBorderButton(
                  widget: Container(
                    width: double.infinity,
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: MTextFieldCustom(
                        focusNode: widget.focusNode,
                        controller: controller,
                        focusBorder: InputBorder.none,
                        enableBorder: InputBorder.none,
                        enable: true,
                        contentPadding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                        hintText: 'Tìm kiếm ngân hàng',
                        prefixIcon: const XImage(
                            imagePath: 'assets/images/ic-search-black.png',
                            width: 30,
                            height: 30),
                        keyboardAction: TextInputAction.done,
                        onChange: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              isSearch = true;
                              listSearch = list
                                  .where(
                                    (element) =>
                                        element.bankCode
                                            .toUpperCase()
                                            .contains(value.toUpperCase()) ||
                                        element.bankName
                                            .toUpperCase()
                                            .contains(value.toUpperCase()) ||
                                        element.bankShortName!
                                            .toUpperCase()
                                            .contains(value.toUpperCase()),
                                  )
                                  .toList();
                            });
                          } else {
                            setState(() {
                              isSearch = false;
                            });
                          }
                        },
                        inputType: TextInputType.text,
                        isObscureText: false),
                  ),
                  borderRadius: BorderRadius.circular(100),
                  borderWidth: 1,
                  gradient: VietQRTheme.gradientColor.aiTextColor),
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
                itemCount: isSearch ? listSearch.length : list.length,
                itemBuilder: (context, index) {
                  var data = isSearch ? listSearch[index] : list[index];
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
                          alignment: Alignment.bottomRight,
                          child: data.linkType == LinkBankType.LINK
                              ? const XImage(
                                  imagePath: 'assets/images/ic-isAuthen.png',
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
