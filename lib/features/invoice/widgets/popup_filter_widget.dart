import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/services/providers/invoice_provider.dart';

import '../../../commons/utils/image_utils.dart';
import '../../../models/bank_account_dto.dart';

class PopupFilterWidget extends StatefulWidget {
  final InvoiceStatus status;
  const PopupFilterWidget({super.key, required this.status});

  @override
  State<PopupFilterWidget> createState() => _PopupFilterWidgetState();
}

class _PopupFilterWidgetState extends State<PopupFilterWidget> {
  int? status = 0;
  int? selectBank = 0;
  int? selectTime = 9;
  List<BankAccountDTO> list = [];

  @override
  void initState() {
    super.initState();
    selectBank = widget.status.id;
  }

  // bool? isLoading;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 30),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        height:
            MediaQuery.of(context).size.height * (selectBank == 0 ? 0.65 : 0.8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Consumer<InvoiceProvider>(
              builder: (context, provider, child) {
                if (provider.listBank != null) {
                  list = provider.listBank!;
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      child: Text(
                        selectBank == 0
                            ? "Bộ lọc hoá đơn"
                            : 'Chọn tài khoản ngân hàng',
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (selectBank == 0) ...[
                      DefaultTextStyle(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        child: Text(
                          "Trạng thái",
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: AppColor.GREY_DADADA, width: 0.5)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<int>(
                            items: [
                              DropdownMenuItem<int>(
                                value: 0,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Chưa thanh toán',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              DropdownMenuItem<int>(
                                value: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Đã thanh toán',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            value: status,
                            onChanged: (value) {
                              setState(() {
                                status = value!;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              width: MediaQuery.of(context).size.width,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(Icons.expand_more),
                              iconSize: 14,
                              iconEnabledColor: Colors.black,
                              iconDisabledColor: Colors.grey,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                  color: AppColor.WHITE,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      DefaultTextStyle(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        child: Text(
                          "Tài khoản ngân hàng",
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: AppColor.GREY_DADADA, width: 0.5)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<int>(
                            items: [
                              DropdownMenuItem<int>(
                                value: 0,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Tất cả',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              DropdownMenuItem<int>(
                                value: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Chọn ngân hàng',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            value: selectBank,
                            onChanged: (value) {
                              setState(() {
                                selectBank = value!;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              width: MediaQuery.of(context).size.width,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(Icons.expand_more),
                              iconSize: 14,
                              iconEnabledColor: Colors.black,
                              iconDisabledColor: Colors.grey,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                  color: AppColor.WHITE,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      DefaultTextStyle(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        child: Text(
                          "Thời gian",
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: AppColor.GREY_DADADA, width: 0.5)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<int>(
                            items: [
                              DropdownMenuItem<int>(
                                value: 9,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Tất cả',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              DropdownMenuItem<int>(
                                value: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Tháng',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            value: selectTime,
                            onChanged: (value) {
                              setState(() {
                                selectTime = value!;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              width: MediaQuery.of(context).size.width,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(Icons.expand_more),
                              iconSize: 14,
                              iconEnabledColor: Colors.black,
                              iconDisabledColor: Colors.grey,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                  color: AppColor.WHITE,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      _buildListBank(list)
                    ],
                  ],
                );
              },
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListBank(List<BankAccountDTO> list) {
    return list.isNotEmpty
        ? Container(
            height: MediaQuery.of(context).size.height * 0.65,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultTextStyle(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      child: Text(
                        "Tất cả tài khoản ngân hàng",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectBank = 0;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                        decoration: BoxDecoration(
                          color: AppColor.BLUE_TEXT.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Chọn',
                              style: TextStyle(
                                  fontSize: 12, color: AppColor.BLUE_TEXT),
                            ),
                            const SizedBox(width: 8),
                            Image.asset(
                              'assets/images/ic-arrow-right-blue.png',
                              width: 12,
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                MySeparator(
                  color: AppColor.GREY_DADADA,
                ),
                Expanded(
                  child: ListView.separated(
                      padding: EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColor.WHITE,
                                        border: Border.all(
                                            color: AppColor.GREY_DADADA,
                                            width: 0.5),
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: ImageUtils.instance
                                              .getImageNetWork(
                                                  list[index].imgId),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    SizedBox(
                                      height: 40,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            list[index].bankAccount,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            list[index].userBankName,
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 8, 10, 8),
                                  decoration: BoxDecoration(
                                    color: AppColor.BLUE_TEXT.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Chọn',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColor.BLUE_TEXT),
                                      ),
                                      const SizedBox(width: 8),
                                      Image.asset(
                                        'assets/images/ic-arrow-right-blue.png',
                                        width: 12,
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => MySeparator(
                            color: AppColor.GREY_DADADA,
                          ),
                      itemCount: list.length),
                ),
              ],
            ),
          )
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo-linked-bank.png",
                  width: 95,
                  height: 50,
                ),
                const SizedBox(height: 20),
                Text(
                  'Có vẻ bạn chưa liên kết \ntài khoản ngân hàng nào!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    decoration: BoxDecoration(
                      color: AppColor.BLUE_TEXT.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Liên kết tài khoản ngay',
                          style: TextStyle(
                              fontSize: 12, color: AppColor.BLUE_TEXT),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          'assets/images/ic-arrow-right-blue.png',
                          width: 12,
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
