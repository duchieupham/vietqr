import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class ModelBottomSheetView extends StatefulWidget {
  const ModelBottomSheetView({
    Key? key,
    this.titleStyles,
    this.contentStyles,
    required this.tvTitle,
    required this.list,
    this.isSearch = false,
    this.data,
    this.searchType,
    this.noData,
    required this.ctx,
  }) : super(key: key);

  final TextStyle? titleStyles;
  final TextStyle? contentStyles;
  final String tvTitle;
  final dynamic data;
  final String? noData;
  final String? searchType;
  final bool isSearch;
  final List<BankTypeDTO> list;
  final BuildContext ctx;

  @override
  State<StatefulWidget> createState() => _BodyWidget();
}

class _BodyWidget extends State<ModelBottomSheetView> {
  final TextEditingController controller = TextEditingController();

  List<BankTypeDTO> data = [];

  @override
  void initState() {
    data = widget.list;

    setState(() {});

    super.initState();
  }

  bool get isShort => widget.list.isNotEmpty && widget.list.length < 5;

  bool get isLong => widget.list.isNotEmpty && widget.list.length >= 5;

  @override
  Widget build(BuildContext context) {
    var column = Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: List.generate(data.length, (index) {
              BankTypeDTO dto = data[index];
              return GestureDetector(
                onTap: () => _onSelect(dto),
                child: Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 40,
                              decoration: BoxDecoration(
                                image: dto.file == null
                                    ? DecorationImage(
                                        image: ImageUtils.instance
                                            .getImageNetWork(
                                                data[index].imageId))
                                    : DecorationImage(
                                        image: FileImage(dto.file!)),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${dto.bankShortName} - ${dto.bankName}',
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.data == dto)
                        const Icon(
                          Icons.check,
                          color: AppColor.GREEN,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.WHITE,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            blurRadius: 10,
            offset: Offset(0, -1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    widget.tvTitle,
                    textAlign: TextAlign.center,
                    style: widget.titleStyles ??
                        const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: Navigator.of(context).pop,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.clear,
                    size: 20,
                  ),
                )
              ],
            ),
          ),
          const Divider(thickness: 1),
          if (widget.isSearch)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFieldCustom(
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                isRequired: false,
                autoFocus: true,
                isObscureText: false,
                controller: controller,
                onChange: onSearch,
                hintText: 'Ngân hàng',
                fillColor: AppColor.GREY_EBEBEB,
                prefixIcon: const IconButton(
                  onPressed: null,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(
                    Icons.search,
                    size: 24,
                    // color: CommonColor.neutral0second300,
                  ),
                ),
              ),
            ),
          (data.isEmpty && widget.noData != null)
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 10,
                  ),
                  child: Text(
                    widget.noData!,
                    // style: tvStyle,
                  ),
                )
              : (isShort)
                  ? column
                  : Expanded(
                      child: SingleChildScrollView(
                        child: column,
                      ),
                    ),
        ],
      ),
    );
  }

  void onSearch(String value) {
    data = widget.list;
    List<BankTypeDTO> values = [];
    List<BankTypeDTO> listMaps = [...data];
    if (value.trim().isNotEmpty) {
      values.addAll(listMaps
          .where((dto) =>
              dto.bankCode.toUpperCase().contains(value.toUpperCase()) ||
              dto.bankName.toUpperCase().contains(value.toUpperCase()) ||
              dto.bankShortName!.toUpperCase().contains(value.toUpperCase()))
          .toList());
    } else {
      values = listMaps;
    }
    setState(() {
      data = values;
    });
  }

  _onSelect(BankTypeDTO dto) {
    final index = widget.list.indexOf(dto);
    Navigator.of(context).pop(index);
  }
}
