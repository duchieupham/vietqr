
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/utils/custom_button_switch.dart';
import '../../../commons/utils/image_utils.dart';
import '../../../commons/widgets/separator_widget.dart';
import '../../../models/bank_account_dto.dart';
import '../../../services/providers/connect_gg_chat_provider.dart';

class PopupAddBankWidget extends StatefulWidget {
  const PopupAddBankWidget({super.key});

  @override
  State<PopupAddBankWidget> createState() => _PopupAddBankWidgetState();
}

class _PopupAddBankWidgetState extends State<PopupAddBankWidget> {
  TextEditingController controller = TextEditingController(text: '');
  String? searchValue = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Consumer<ConnectGgChatProvider>(
        builder: (context, provider, child) {
          return Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 30),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            height: MediaQuery.of(context).size.height * 0.8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      child: Text(
                        'Thêm tài khoản ngân hàng \nđể chia sẻ BĐSD qua Google Chat',
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppColor.GREY_DADADA)),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        controller: controller,
                        onChanged: (value) {
                          setState(() {
                            searchValue = value;
                          });
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            searchValue = value;
                          });
                        },
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(top: 11, bottom: 10),
                            hintText: 'Nhập mã ở đây',
                            hintStyle: TextStyle(
                                fontSize: 20,
                                color: AppColor.BLACK.withOpacity(0.5)),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 20,
                            ),
                            prefixIconColor: AppColor.GREY_TEXT,
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.clear,
                                size: 20,
                                color: AppColor.GREY_TEXT,
                              ),
                              onPressed: () {
                                controller.clear();
                              },
                            )),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tất cả tài khoản đã liên kết',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          CupertinoSwitch(
                            activeColor: AppColor.BLUE_TEXT,
                            value: provider.isAllLinked,
                            onChanged: (value) {
                              provider.changeAllValue(value);
                            },
                          )
                        ],
                      ),
                    ),
                    MySeparator(
                      color: AppColor.GREY_DADADA,
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 0),
                        itemBuilder: (context, index) {
                          return _itemBank(provider.listBank[index], index);
                        },
                        itemCount: provider.listBank.length,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColor.BLUE_TEXT,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            'Hoàn thành',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColor.WHITE,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
          );
        },
      ),
    );
  }

  Widget _itemBank(BankSelection dto, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 75,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 0.5, color: Colors.grey),
                  image: DecorationImage(
                    image: ImageUtils.instance.getImageNetWork(dto.bank!.imgId),
                  ),
                ),
                // Placeholder for bank logo
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dto.bank!.bankAccount,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(dto.bank!.userBankName, style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
          CupertinoSwitch(
            activeColor: AppColor.BLUE_TEXT,
            value: dto.value!,
            onChanged: (value) {
              Provider.of<ConnectGgChatProvider>(context, listen: false)
                  .selectValue(value, index);
            },
          )
        ],
      ),
    );
  }
}
