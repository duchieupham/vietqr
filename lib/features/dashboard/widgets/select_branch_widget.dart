import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/features/business/repositories/business_information_repository.dart';
import 'package:vierqr/models/business_detail_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class SelectBranchWidget extends StatefulWidget {
  final String businessId;
  final TypeSelect tySelect;

  const SelectBranchWidget(
      {super.key, required this.businessId, this.tySelect = TypeSelect.BANK});

  @override
  State<SelectBranchWidget> createState() => _SelectBranchWidgetState();
}

class _SelectBranchWidgetState extends State<SelectBranchWidget> {
  late BusinessInformationRepository repository;
  String userId = UserInformationHelper.instance.getUserId();

  BusinessDetailDTO? businessDetailDTO;

  @override
  void initState() {
    super.initState();
    repository = const BusinessInformationRepository();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initData();
  }

  void initData() async {
    try {
      BusinessDetailDTO result =
          await repository.getBusinessDetail(widget.businessId, userId);
      setState(() {
        businessDetailDTO = result;
      });
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          color: DefaultTheme.BANK_CARD_COLOR_3.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      'Chọn chi nhánh',
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
                        color: DefaultTheme.GREEN,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DividerWidget(width: width),
          if (businessDetailDTO != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: width,
              child: ListView.builder(
                itemCount: businessDetailDTO!.branchs.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsetsDirectional.all(0),
                itemBuilder: (context, index) {
                  return _buildBranchList(
                    context: context,
                    dto: businessDetailDTO!.branchs[index],
                    index: index,
                  );
                },
              ),
            ),
          ]
        ],
      ),
    );

    return const SizedBox();
  }

  Widget _buildBranchList({
    required BuildContext context,
    required BusinessBranchDTO dto,
    required int index,
  }) {
    final double width = MediaQuery.of(context).size.width;
    if (dto.banks.isEmpty || widget.tySelect == TypeSelect.MEMBER) {
      return GestureDetector(
        onTap: () async {
          Navigator.of(context).pop(dto.id);
        },
        child: Container(
          width: width,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: DefaultTheme.BLACK_LIGHT.withOpacity(0.1),
                blurRadius: 1,
              ),
            ],
            color: DefaultTheme.WHITE,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.asset(
                      'assets/images/ic-avatar-business.png',
                      fit: BoxFit.cover,
                      width: 48,
                      height: 48,
                    ).image,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _buildElementInformation(
                      context: context,
                      description: dto.name,
                      isDescriptionBold: true,
                    ),
                    const SizedBox(height: 4),
                    (dto.banks.isNotEmpty)
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${dto.banks[index].bankCode} - ${dto.banks[index].bankAccount}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          )
                        : _buildElementInformation(
                            context: context,
                            descriptionColor: DefaultTheme.GREY_TEXT,
                            description: 'Chưa liên kết',
                          ),
                    const SizedBox(height: 4),
                    _buildElementInformation(
                      context: context,
                      descriptionColor: DefaultTheme.GREY_TEXT,
                      description: (dto.totalMember == 0)
                          ? 'Chưa có thành viên'
                          : '${dto.totalMember} thành viên',
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ),
      );
    }

    return const SizedBox();
  }

  Widget _buildElementInformation({
    required BuildContext context,
    required String description,
    bool? isCopy,
    bool? isDescriptionBold,
    Color? descriptionColor,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      child: Row(
        children: [
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontWeight: (isDescriptionBold != null && isDescriptionBold)
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: (descriptionColor != null)
                    ? descriptionColor
                    : Theme.of(context).hintColor,
              ),
            ),
          ),
          if (isCopy != null && isCopy)
            InkWell(
              onTap: () async {
                await FlutterClipboard.copy(description).then(
                  (value) => Fluttertoast.showToast(
                    msg: 'Đã sao chép',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).hintColor,
                    fontSize: 15,
                    webBgColor: 'rgba(255, 255, 255)',
                    webPosition: 'center',
                  ),
                );
              },
              child: const Icon(
                Icons.copy_rounded,
                color: DefaultTheme.GREY_TEXT,
                size: 15,
              ),
            ),
        ],
      ),
    );
  }
}
