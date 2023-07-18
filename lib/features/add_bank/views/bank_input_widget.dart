import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';

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
  }) : super(key: key);

  final TextStyle? titleStyles;
  final TextStyle? contentStyles;
  final String tvTitle;
  final dynamic data;
  final String? noData;
  final String? searchType;
  final bool isSearch;
  final List list;

  @override
  State<StatefulWidget> createState() => _BodyWidget();
}

class _BodyWidget extends State<ModelBottomSheetView> {
  final TextEditingController controller = TextEditingController();

  List data = [];

  @override
  void initState() {
    List values = [];
    for (int i = 0; i < widget.list.length; i++) {
      final element = widget.list[i];
      final map = {
        'data': element,
        'index': i,
      };
      values.add(map);
    }
    setState(() {
      data = values;
    });

    super.initState();
  }

  bool get isShort => widget.list.isNotEmpty && widget.list.length < 5;

  bool get isLong => widget.list.isNotEmpty && widget.list.length >= 5;

  @override
  Widget build(BuildContext context) {
    var column = Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: List.generate(data.length, (index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(data[index]['index']);
                },
                child: Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 40,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: ImageUtils.instance.getImageNetWork(
                                        data[index]['data'].imageId)),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${data[index]['data'].bankShortName} - ${data[index]['data'].bankName}',
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
                      if (widget.data == data[index]['data'])
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
                isObscureText: false,
                controller: controller,
                onChange: (value) => onSearch(value),
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
    List values = [];
    List listMaps = [];
    data = widget.list;
    for (int i = 0; i < widget.list.length; i++) {
      final element = widget.list[i];
      final map = {
        'data': element,
        'index': i,
      };
      listMaps.add(map);
    }
    if (value.trim().isNotEmpty) {
      values.addAll(listMaps
          .where((dto) =>
              dto['data']
                  .bankCode
                  .toUpperCase()
                  .contains(value.toUpperCase()) ||
              dto['data']
                  .bankName
                  .toUpperCase()
                  .contains(value.toUpperCase()) ||
              dto['data']
                  .bankShortName!
                  .toUpperCase()
                  .contains(value.toUpperCase()))
          .toList());
    } else {
      values = listMaps;
    }
    setState(() {
      data = values;
    });
  }
}
