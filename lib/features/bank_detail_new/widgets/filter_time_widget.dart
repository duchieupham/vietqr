import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class FilterTransWidget extends StatefulWidget {
  final FilterTrans? filter;
  final bool isFilerTime;
  const FilterTransWidget({
    super.key,
    this.filter,
    required this.isFilerTime,
  });

  @override
  State<FilterTransWidget> createState() => _FilterTransWidgetState();
}

class _FilterTransWidgetState extends State<FilterTransWidget> {
  List<FilterTrans> list = [
    FilterTrans(
        title: 'Hôm nay',
        type: 1,
        fromDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 00:00:00',
        toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59'),
    FilterTrans(
        title: '7 ngày gần đây',
        type: 0,
        fromDate:
            '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 7)))} 00:00:00',
        toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59'),
    FilterTrans(
        title: '3 tháng gần đây',
        type: 2,
        fromDate:
            '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 90)))} 00:00:00',
        toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59'),
    FilterTrans(title: 'Tuỳ chọn', type: 3),
  ];

  List<FilterTrans> listTransType = [
    FilterTrans(title: 'Tất cả giao dịch', type: 9),
    FilterTrans(title: 'Giao dịch đến (+)', type: 0),
    FilterTrans(title: 'Giao dịch đi (-)', type: 1),
  ];

  FilterTrans selectedFilter = FilterTrans(
      title: '7 ngày gần đây',
      type: 0,
      fromDate:
          '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 7)))} 00:00:00',
      toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59');

  FilterTrans selectFilterTransType =
      FilterTrans(title: 'Tất cả giao dịch', type: 9);

  @override
  void initState() {
    super.initState();
    if (widget.filter != null && widget.isFilerTime == true) {
      selectedFilter = widget.filter!;
    }
    if (widget.filter != null && widget.isFilerTime == false) {
      selectFilterTransType = widget.filter!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(
                widget.isFilerTime ? selectedFilter : selectFilterTransType);
          },
        )),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: widget.isFilerTime ? 300 : 250,
            margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 15, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.isFilerTime
                            ? 'Chọn thời gian'
                            : 'Chọn loại giao dịch',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop(widget.isFilerTime
                              ? selectedFilter
                              : selectFilterTransType);
                        },
                        child: const XImage(
                          imagePath: 'assets/images/ic-close-black.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        itemBuilder: (context, index) {
                          final item = widget.isFilerTime
                              ? list[index]
                              : listTransType[index];
                          int type = widget.isFilerTime
                              ? selectedFilter.type
                              : selectFilterTransType.type;
                          bool isSelect = type == item.type;
                          return InkWell(
                            onDoubleTap: () {
                              if (widget.isFilerTime) {
                                setState(() {
                                  selectedFilter = item;
                                });
                              } else {
                                setState(() {
                                  selectFilterTransType = item;
                                });
                              }
                              Navigator.of(context).pop(item);
                            },
                            onTap: () {
                              if (widget.isFilerTime) {
                                setState(() {
                                  selectedFilter = item;
                                });
                              } else {
                                setState(() {
                                  selectFilterTransType = item;
                                });
                              }
                              Navigator.of(context).pop(item);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                        fontSize: 12, color: AppColor.BLACK),
                                  ),
                                  Container(
                                    width: 18,
                                    height: 18,
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: AppColor.WHITE,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            color: isSelect
                                                ? AppColor.BLUE_TEXT
                                                : AppColor.GREY_LIGHT,
                                            width: 2)),
                                    child: isSelect
                                        ? Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: AppColor.BLUE_TEXT,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    // child:,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const MySeparator(
                              color: AppColor.GREY_DADADA,
                            ),
                        itemCount: widget.isFilerTime
                            ? list.length
                            : listTransType.length))
              ],
            ),
          ),
        )
      ],
    );
  }
}

class FilterTrans {
  String title;
  int type;
  String? fromDate;
  String? toDate;

  FilterTrans(
      {required this.title, required this.type, this.fromDate, this.toDate});
}
