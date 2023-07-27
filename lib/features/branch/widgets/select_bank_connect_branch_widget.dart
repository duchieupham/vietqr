import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/features/branch/blocs/branch_bloc.dart';
import 'package:vierqr/features/branch/repositories/branch_repository.dart';
import 'package:vierqr/features/branch/states/branch_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_bank_branch_insert_dto.dart';
import 'package:vierqr/models/account_bank_connect_branch_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class SelectBankConnectBranchWidget extends StatefulWidget {
  final String businessId;
  final String branchId;

  const SelectBankConnectBranchWidget({
    super.key,
    required this.branchId,
    required this.businessId,
  });

  @override
  State<SelectBankConnectBranchWidget> createState() =>
      _SelectBankConnectBranchWidgetState();
}

class _SelectBankConnectBranchWidgetState
    extends State<SelectBankConnectBranchWidget> {
  List<AccountBankConnectBranchDTO> list = [];
  List<Color> _colors = [];
  String _msgError = '';
  bool _isConnectBank = false;

  String userId = UserInformationHelper.instance.getUserId();
  late BranchRepository branchRepository;

  @override
  void initState() {
    super.initState();
    branchRepository = const BranchRepository();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getConnectBanks();
  }

  void _getConnectBanks() async {
    try {
      final List<AccountBankConnectBranchDTO> listData =
          await branchRepository.getBranchConnectBanks(userId);
      final List<Color> colors = [];
      PaletteGenerator? paletteGenerator;
      BuildContext context = NavigationService.navigatorKey.currentContext!;
      if (listData.isNotEmpty) {
        for (AccountBankConnectBranchDTO dto in listData) {
          NetworkImage image = ImageUtils.instance.getImageNetWork(dto.imgId);
          paletteGenerator = await PaletteGenerator.fromImageProvider(image);
          if (paletteGenerator.dominantColor != null) {
            colors.add(paletteGenerator.dominantColor!.color);
          } else {
            colors.add(Theme.of(context).cardColor);
          }
        }
      }

      setState(() {
        _colors = colors;
        list = listData;
      });
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: width,
            height: 50,
            child: Row(
              children: [
                const SizedBox(
                  width: 80,
                  height: 50,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Kết nối TK ngân hàng',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 80,
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'Xong',
                      style: TextStyle(
                        color: AppColor.BLUE_TEXT,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DividerWidget(width: width),
          const Padding(padding: EdgeInsets.only(top: 30)),
          Expanded(
            child: BlocBuilder<BranchBloc, BranchState>(
              builder: (context, state) {
                if (state is BranchGetConnectBankSuccessState) {
                  list.clear();
                  _colors.clear();
                  if (list.isEmpty) {
                    list.addAll(state.list);
                    _colors.addAll(state.colors);
                  }
                }
                return (list.isEmpty)
                    ? const SizedBox()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return _buildCardItem(
                            context: context,
                            index: index,
                            dto: list[index],
                            color: _colors[index],
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardItem({
    required BuildContext context,
    required int index,
    required AccountBankConnectBranchDTO dto,
    required Color color,
  }) {
    final double width = MediaQuery.of(context).size.width;

    return (dto.bankId.isNotEmpty)
        ? InkWell(
            onTap: () {},
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
                                  dto.bankAccountName.toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColor.WHITE,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  (dto.authenticated)
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
                            onTap: () async {
                              AccountBankBranchInsertDTO
                                  accountBankBranchInsertDTO =
                                  AccountBankBranchInsertDTO(
                                userId: userId,
                                bankId: dto.bankId,
                                businessId: widget.businessId,
                                branchId: widget.branchId,
                              );
                              await _connectBank(accountBankBranchInsertDTO);
                              if (!mounted) return;
                              Navigator.pop(context, _isConnectBank);
                            },
                            child: BoxLayout(
                              width: 100,
                              borderRadius: 5,
                              alignment: Alignment.center,
                              bgColor:
                                  Theme.of(context).cardColor.withOpacity(0.3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Chọn',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColor.WHITE,
                                    ),
                                  ),
                                  Icon(
                                    Icons.navigate_next_rounded,
                                    color: AppColor.WHITE,
                                    size: 15,
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

  Future _connectBank(dto) async {
    try {
      DialogWidget.instance.openLoadingDialog();
      final ResponseMessageDTO result =
          await branchRepository.addBankConnectBranch(dto);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        if (!mounted) return;
        Navigator.of(context).pop();
        setState(() {
          _isConnectBank = true;
        });
      } else {
        setState(() {
          _msgError = ErrorUtils.instance.getErrorMessage(result.message);
        });
      }
    } catch (e) {
      ResponseMessageDTO result =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      LOG.error(e.toString());
      setState(() {
        _msgError = ErrorUtils.instance.getErrorMessage(result.message);
      });
    }
  }
}
