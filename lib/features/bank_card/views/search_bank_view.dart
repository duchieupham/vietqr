import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/generate_qr/views/create_qr.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/providers/bank_card_select_provider.dart';
import 'package:vierqr/services/providers/search_clear_provider.dart';

class SearchBankView extends StatelessWidget {
  static final SearchClearProvider _searchClearProvider =
      SearchClearProvider(false);

  static final TextEditingController searchController = TextEditingController();

  static final _formKey = GlobalKey<FormState>();

  const SearchBankView({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bankCardProvider =
        Provider.of<BankCardSelectProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          // SizedBox(
          //   width: width,
          //   height: 50,
          //   child: Row(
          //     children: [
          //       const SizedBox(
          //         width: 80,
          //         height: 50,
          //       ),
          //       Expanded(
          //         child: Container(
          //           alignment: Alignment.center,
          //           child: const Text(
          //             'TK ngân hàng',
          //             style: TextStyle(
          //               fontWeight: FontWeight.w500,
          //               fontSize: 15,
          //             ),
          //           ),
          //         ),
          //       ),
          //       InkWell(
          //         onTap: () {
          //           reset(context: context);
          //           Navigator.pop(context);
          //         },
          //         child: Container(
          //           width: 80,
          //           alignment: Alignment.centerRight,
          //           child: const Text(
          //             'Xong',
          //             style: TextStyle(
          //               color: DefaultTheme.GREEN,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // DividerWidget(width: width),
          SubHeader(title: 'Tìm kiếm TK ngân hàng'),
          Expanded(
            child: Consumer<BankCardSelectProvider>(
              builder: (context, provider, child) {
                return (provider.searchBanks.isNotEmpty)
                    ? Column(
                        children: [
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: provider.searchBanks.length,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              itemBuilder: (context, index) {
                                return _buildCardItem(
                                  context: context,
                                  index: index,
                                  dto: provider.searchBanks[index],
                                  color: provider.searchColors[index],
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : const SizedBox();
              },
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          BoxLayout(
            width: width - 40,
            borderRadius: 50,
            alignment: Alignment.center,
            bgColor: Theme.of(context).cardColor,
            // margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 15,
                  color: Theme.of(context).hintColor,
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFieldWidget(
                      width: width,
                      hintText: 'Nhập để tìm kiếm',
                      controller: searchController,
                      keyboardAction: TextInputAction.done,
                      autoFocus: false,
                      onChange: (value) {
                        search(bankCardProvider);
                      },
                      inputType: TextInputType.text,
                      isObscureText: false,
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: _searchClearProvider,
                  builder: (_, provider, child) {
                    return Visibility(
                      visible: provider == true,
                      child: InkWell(
                        onTap: () {
                          reset(context: context);
                        },
                        child: Icon(
                          Icons.close_rounded,
                          size: 15,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
        ],
      ),
    );
  }

  void search(BankCardSelectProvider bankCardProvider) {
    if (searchController.text.isNotEmpty) {
      _searchClearProvider.updateClearSearch(true);
    } else {
      _searchClearProvider.updateClearSearch(false);
    }
    //
    if (searchController.text.length >= 2) {
      List<BankAccountDTO> resultBanks = [];
      List<Color> resultColors = [];
      if (bankCardProvider.banks.isNotEmpty) {
        for (int i = 0; i < bankCardProvider.banks.length; i++) {
          if (bankCardProvider.banks[i].bankAccount
                  .contains(searchController.text.trim()) ||
              bankCardProvider.banks[i].userBankName
                  .toUpperCase()
                  .contains(searchController.text.trim().toUpperCase())) {
            resultBanks.add(bankCardProvider.banks[i]);
            resultColors.add(bankCardProvider.colors[i]);
          }
        }
      }

      bankCardProvider.updateSearchBanks(resultBanks);
      bankCardProvider.updateSearchColors(resultColors);
    } else {
      bankCardProvider.updateSearchBanks([]);
      bankCardProvider.updateSearchColors([]);
    }
  }

  void reset({required BuildContext context}) {
    final bankCardProvider =
        Provider.of<BankCardSelectProvider>(context, listen: false);
    searchController.clear();
    _searchClearProvider.updateClearSearch(false);
    bankCardProvider.updateSearchBanks([]);
    bankCardProvider.updateSearchColors([]);
  }

  Widget _buildCardItem({
    required BuildContext context,
    required int index,
    required BankAccountDTO dto,
    required Color color,
  }) {
    final double width = MediaQuery.of(context).size.width;

    return (dto.id.isNotEmpty)
        ? InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.BANK_CARD_DETAIL_VEW,
                arguments: {
                  'bankId': dto.id,
                },
              );
            },
            child: Container(
              width: width,
              height: 150,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                width: width,
                height: 100,
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: width,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 30,
                            decoration: BoxDecoration(
                              color: DefaultTheme.WHITE,
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: ImageUtils.instance.getImageNetWork(
                                  dto.imgId,
                                ),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Expanded(
                            child: Text(
                              '${dto.bankCode} - ${dto.bankAccount}\n${dto.bankName}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: DefaultTheme.WHITE,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 20)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dto.userBankName.toUpperCase(),
                                  style: const TextStyle(
                                    color: DefaultTheme.WHITE,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  (dto.isAuthenticated)
                                      ? 'Trạng thái: Đã liên kết'
                                      : 'Trạng thái: Chưa liên kết',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: DefaultTheme.WHITE,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              BankAccountDTO bankAccountDTO = BankAccountDTO(
                                id: dto.id,
                                bankAccount: dto.bankAccount,
                                userBankName: dto.userBankName,
                                bankCode: dto.bankCode,
                                bankName: dto.bankName,
                                imgId: dto.imgId,
                                type: dto.type,
                                branchId:
                                    (dto.branchId.isEmpty) ? '' : dto.branchId,
                                businessId: (dto.businessId.isEmpty)
                                    ? ''
                                    : dto.businessId,
                                branchName: (dto.branchName.isEmpty)
                                    ? ''
                                    : dto.branchName,
                                businessName: (dto.businessName.isEmpty)
                                    ? ''
                                    : dto.businessName,
                                isAuthenticated: dto.isAuthenticated,
                              );
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) => CreateQR(
                                    bankAccountDTO: bankAccountDTO,
                                  ),
                                ),
                              )
                                  .then((value) {
                                //
                              });
                            },
                            child: BoxLayout(
                              width: 110,
                              borderRadius: 5,
                              alignment: Alignment.center,
                              bgColor:
                                  Theme.of(context).cardColor.withOpacity(0.3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.add_rounded,
                                    color: DefaultTheme.WHITE,
                                    size: 15,
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 5)),
                                  Text(
                                    'Tạo QR',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: DefaultTheme.WHITE,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 20)),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
