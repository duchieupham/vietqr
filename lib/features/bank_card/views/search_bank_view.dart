import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/create_qr/create_qr_screen.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/navigator/app_navigator.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/search_clear_provider.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/bank_card_detail_screen.dart';

class SearchBankView extends StatefulWidget {
  const SearchBankView({super.key});

  @override
  State<SearchBankView> createState() => _SearchBankViewState();
}

class _SearchBankViewState extends State<SearchBankView> {
  final _searchClearProvider = SearchClearProvider(false);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();
  List<BankAccountDTO> banks = [];
  List<BankAccountDTO> searchBanks = [];
  String msg = '';

  @override
  void initState() {
    super.initState();
    _getBankAccounts();
  }

  void _getBankAccounts() async {
    String userId = SharePrefUtils.getProfile().userId;

    try {
      List<BankAccountDTO> list =
          await bankCardRepository.getListBankAccount(userId);
      PaletteGenerator? paletteGenerator;
      BuildContext context = NavigationService.context!;
      if (list.isNotEmpty) {
        List<BankAccountDTO> listLinked =
            list.where((e) => e.isAuthenticated).toList();
        List<BankAccountDTO> listNotLinked =
            list.where((e) => !e.isAuthenticated).toList();

        list = [...listLinked, ...listNotLinked];

        for (BankAccountDTO dto in list) {
          NetworkImage image = ImageUtils.instance.getImageNetWork(dto.imgId);
          paletteGenerator = await PaletteGenerator.fromImageProvider(image);
          if (paletteGenerator.dominantColor != null) {
            dto.setColor(paletteGenerator.dominantColor!.color);
          } else {
            if (!mounted) return;
            dto.setColor(Theme.of(context).cardColor);
          }
        }
      }
      setState(() {
        banks = list;
      });
    } catch (e) {
      LOG.error(e.toString());
      setState(() {
        msg = 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối';
      });
    }
  }

  void updateSearchBanks(List<BankAccountDTO> value) {
    setState(() {
      searchBanks = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: MAppBar(
          title: 'Tìm kiếm TK ngân hàng',
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            reset(context: context);
            Future.delayed(const Duration(milliseconds: 200), () {
              Navigator.of(context).pop();
            });
          },
          callBackHome: () {
            reset(context: context);
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        body: Column(
          children: [
            Expanded(
              child: (banks.isEmpty)
                  ? const Center(
                      child: Text(
                        'Chưa có tài khoản ngân hàng nào được thêm',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : (searchController.text.isNotEmpty)
                      ? Column(
                          children: [
                            const Padding(padding: EdgeInsets.only(top: 10)),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: searchBanks.length,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                itemBuilder: (context, index) {
                                  return _buildCardItem(
                                    context: context,
                                    index: index,
                                    dto: searchBanks[index],
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            const Padding(padding: EdgeInsets.only(top: 10)),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: banks.length,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                itemBuilder: (context, index) {
                                  return _buildCardItem(
                                    context: context,
                                    index: index,
                                    dto: banks[index],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: BoxLayout(
                width: width - 40,
                height: 50,
                borderRadius: 50,
                alignment: Alignment.center,
                bgColor: Theme.of(context).cardColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
                            search();
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
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
          ],
        ),
      ),
    );
  }

  void search() {
    if (searchController.text.isNotEmpty) {
      _searchClearProvider.updateClearSearch(true);
    } else {
      _searchClearProvider.updateClearSearch(false);
    }
    //
    if (searchController.text.isNotEmpty) {
      List<BankAccountDTO> resultBanks = [];
      if (banks.isNotEmpty) {
        for (int i = 0; i < banks.length; i++) {
          if (banks[i].bankAccount.contains(searchController.text.trim()) ||
              banks[i]
                  .userBankName
                  .toUpperCase()
                  .contains(searchController.text.trim().toUpperCase())) {
            resultBanks.add(banks[i]);
          }
        }
      }

      updateSearchBanks(resultBanks);
    } else {
      updateSearchBanks([]);
    }
  }

  void reset({required BuildContext context}) {
    searchController.clear();
    _searchClearProvider.updateClearSearch(false);
  }

  Widget _buildCardItem({
    required BuildContext context,
    required int index,
    required BankAccountDTO dto,
  }) {
    final double width = MediaQuery.of(context).size.width;

    return (dto.id.isNotEmpty)
        ? InkWell(
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              final data = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BankCardDetailScreen(bankId: dto.id),
                  settings: const RouteSettings(
                    name: Routes.BANK_CARD_DETAIL_VEW,
                  ),
                ),
              );

              if (data != null && data) {
                _getBankAccounts();
              }
            },
            child: Container(
              width: width,
              height: 150,
              margin: const EdgeInsets.only(bottom: 10),
              // padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: dto.bankColor,
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
                              color: AppColor.WHITE,
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
                                color: AppColor.WHITE,
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColor.WHITE,
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
                                    color: AppColor.WHITE,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => _onCreateQR(dto),
                            child: BoxLayout(
                              width: 110,
                              borderRadius: 5,
                              alignment: Alignment.center,
                              bgColor:
                                  Theme.of(context).cardColor.withOpacity(0.3),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_rounded,
                                    color: AppColor.WHITE,
                                    size: 15,
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 5)),
                                  Text(
                                    'Tạo QR',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColor.WHITE,
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

  void _onCreateQR(BankAccountDTO dto) {
    BankAccountDTO bankAccountDTO = BankAccountDTO(
      id: dto.id,
      bankAccount: dto.bankAccount,
      userBankName: dto.userBankName,
      bankCode: dto.bankCode,
      bankName: dto.bankName,
      imgId: dto.imgId,
      type: dto.type,
      isAuthenticated: dto.isAuthenticated,
    );
    NavigatorUtils.navigatePage(
        context, CreateQrScreen(bankAccountDTO: bankAccountDTO),
        routeName: CreateQrScreen.routeName);
  }
}
