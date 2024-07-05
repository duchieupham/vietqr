import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/connect_gg_chat/widgets/popup_confirm_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/enums/enum_type.dart';
import '../../../commons/utils/image_utils.dart';
import '../../../commons/widgets/separator_widget.dart';
import '../../../services/providers/connect_gg_chat_provider.dart';
import '../blocs/connect_gg_chat_bloc.dart';
import '../states/connect_gg_chat_states.dart';

class WebhookGgChatScreen extends StatefulWidget {
  final Function(int) onPageChanged;
  final Function(String) onSubmitInput;
  final Function(String) onChangeInput;
  final Function() onGuide;

  final TextEditingController textController;
  final PageController controller;
  const WebhookGgChatScreen({
    super.key,
    required this.controller,
    required this.textController,
    required this.onPageChanged,
    required this.onSubmitInput,
    required this.onChangeInput,
    required this.onGuide,
  });

  @override
  State<WebhookGgChatScreen> createState() => _WebhookGgChatScreenState();
}

class _WebhookGgChatScreenState extends State<WebhookGgChatScreen> {
  bool isChecked1 = true;
  bool isChecked2 = true;
  bool isChecked3 = true;
  bool isChecked4 = true;
  bool isChecked5 = true;
  bool isChecked6 = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: PageView(
        controller: widget.controller,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: widget.onPageChanged,
        children: [
          startConnectGgChat(),
          listAccountLinked(),
          inputWebhook(),
          settingConnect(),
          finishConnectGgChat(),
        ],
      ),
    );
  }

  Widget settingConnect() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Text(
            'Tiếp theo, cấu hình thông tin\nchia sẻ BĐSD qua Google Chat',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 30),
          const Text(
            'Cấu hình chia sẻ loại giao dịch',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCheckboxRow('Giao dịch có đối soát', isChecked1, (value) {
                setState(() {
                  isChecked1 = value ?? true;
                });
              }),
              InkWell(
                onTap: () {
                  DialogWidget.instance.showModelBottomSheet(
                    borderRadius: BorderRadius.circular(16),
                    widget: PopUpConfirm(),
                    // height: MediaQuery.of(context).size.height * 0.6,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: const LinearGradient(
                          colors: [
                            Color(0xFFE1EFFF),
                            Color(0xFFE5F9FF),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)),
                  child:
                      const XImage(imagePath: 'assets/images/ic-i-black.png'),
                ),
              ),
            ],
          ),
          const MySeparator(color: AppColor.GREY_DADADA),
          buildCheckboxRow('Giao dịch nhận tiền đến (+)', isChecked2, (value) {
            setState(() {
              isChecked2 = value ?? true;
            });
          }),
          const MySeparator(color: AppColor.GREY_DADADA),
          buildCheckboxRow('Giao dịch chuyển tiền đi (−)', isChecked3, (value) {
            setState(() {
              isChecked3 = value ?? true;
            });
          }),
          const SizedBox(height: 20),
          const Text(
            'Cấu hình chia sẻ thông tin giao dịch',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),
          buildCheckboxRow('Số tiền', isChecked4, (value) {
            setState(() {
              isChecked4 = value ?? true;
            });
          }),
          const MySeparator(color: AppColor.GREY_DADADA),
          buildCheckboxRow('Nội dung thanh toán', isChecked5, (value) {
            setState(() {
              isChecked5 = value ?? true;
            });
          }),
          const MySeparator(color: AppColor.GREY_DADADA),
          buildCheckboxRow('Mã giao dịch', isChecked6, (value) {
            setState(() {
              isChecked6 = value ?? true;
            });
          }),
        ],
      ),
    );
  }

  Widget buildCheckboxRow(
      String text, bool isChecked, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Theme(
          data: ThemeData(
            unselectedWidgetColor: AppColor.GREY_DADADA,
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
          child: Checkbox(
            value: isChecked,
            onChanged: onChanged,
            checkColor: AppColor.WHITE,
            activeColor: AppColor.BLUE_TEXT,
          ),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Widget startConnectGgChat() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 100),
          SizedBox(
            height: 100,
            width: 100,
            child: Image.asset('assets/images/ic-gg-chat-home.png'),
          ),
          const SizedBox(height: 30),
          const Text(
            'Kết nối Google Chat để nhận\nthông tin biến động số dư',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const SizedBox(
            width: double.infinity,
            child: Text(
              'Thực hiện kết nối chỉ với một vài thao tác đơn giản.\nAn tâm về vấn đề an toàn thông tin - dữ liệu\ncủa Google Chat mang lại.',
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget finishConnectGgChat() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          SizedBox(
            height: 100,
            width: 100,
            child: Image.asset('assets/images/ic-gg-chat-home.png'),
          ),
          const SizedBox(height: 30),
          const Text(
            'Kết nối Google Chat thành công!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            width: double.infinity,
            child: Text(
              'Cảm ơn quý khách đã sử dụng dịch vụ \nVietQR VN của chúng tôi.',
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget listAccountLinked() {
    return Consumer<ConnectGgChatProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                height: 50,
                width: 50,
                child: Image.asset('assets/images/ic-gg-chat-home.png'),
              ),
              const SizedBox(height: 30),
              const Text(
                'Đầu tiên, chọn tài khoản\nngân hàng mà bạn muốn\nnhận BĐSD qua Google Chat',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tất cả tài khoản đã liên kết',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
              const MySeparator(
                color: AppColor.GREY_DADADA,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  itemBuilder: (context, index) {
                    return _itemBank(provider.listBank[index], index, provider);
                  },
                  itemCount: provider.listBank.length,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _itemBank(
      BankSelection dto, int index, ConnectGgChatProvider ggChatProvider) {
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
              Container(
                width: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dto.bank!.bankAccount,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    Text(dto.bank!.userBankName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          CupertinoSwitch(
            activeColor: AppColor.BLUE_TEXT,
            value: dto.value!,
            onChanged: (value) {
              ggChatProvider.selectValue(value, index);
            },
          )
        ],
      ),
    );
  }

  Widget inputWebhook() {
    return Consumer<ConnectGgChatProvider>(
      builder: (context, value, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Container(
              //   height: 50,
              //   width: 50,
              //   child: Image.asset('assets/images/ic-gg-chat-home.png'),
              // ),
              // const SizedBox(height: 30),
              const SizedBox(
                width: double.infinity,
                child: Text(
                  'Tiếp theo, vui lòng thực hiện theo hướng dẫn và nhập URL Webhook',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: widget.onGuide,
                child: Container(
                  height: 30,
                  width: 250,
                  // margin: EdgeInsets.only(right: 40),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFE1EFFF),
                        Color(0xFFE5F9FF),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 15,
                        height: 15,
                        child:
                            Image.asset('assets/images/ic-guides-ggchat.png'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Xem hướng dẫn tại đây',
                        style:
                            TextStyle(color: AppColor.BLUE_TEXT, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const SizedBox(
                width: double.infinity,
                height: 20,
                child: Text(
                  'Webhook Google Chat',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                // margin: EdgeInsets.only(right: 40),
                height: 50,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: AppColor.GREY_TEXT, width: 0.5),
                    )),
                child: TextField(
                  focusNode: value.focusNode,
                  controller: widget.textController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,
                  onSubmitted: widget.onSubmitInput,
                  onChanged: widget.onChangeInput,
                  decoration: const InputDecoration(
                    hintText: 'Nhập đường dẫn Webhook tại đây',
                    hintStyle:
                        TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Visibility(
                visible: widget.textController.text.isNotEmpty
                    ? (!value.isValidWebhook ? true : false)
                    : false,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: const Text(
                    'Webhook không hợp lệ. Vui lòng kiểm tra lại thông tin.',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
