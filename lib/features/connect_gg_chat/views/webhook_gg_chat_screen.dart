import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/enums/enum_type.dart';
import '../../../commons/utils/image_utils.dart';
import '../../../commons/widgets/separator_widget.dart';
import '../../../services/providers/connect_gg_chat_provider.dart';
import '../blocs/connect_gg_chat_bloc.dart';
import '../states/connect_gg_chat_states.dart';

class WebhookGgChatScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectGgChatBloc, ConnectGgChatStates>(
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            controller: controller,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: onPageChanged,
            children: [
              startConnectGgChat(),
              listAccountLinked(),
              inputWebhook(),
              finishConnectGgChat(),
            ],
          ),
        );
      },
    );
  }

  Widget startConnectGgChat() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Container(
            height: 100,
            width: 100,
            child: Image.asset('assets/images/ic-gg-chat-home.png'),
          ),
          SizedBox(height: 30),
          Container(
            width: 250,
            height: 90,
            child: Text(
              'Kết nối Google Chat\nđể nhận thông tin\nBiến động số dư',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: Text(
              'Thực hiện kết nối chỉ với một vài thao tác đơn giản.\nAn tâm về vấn đề an toàn thông tin - dữ liệu\ncủa Google Chat mang lại.',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget finishConnectGgChat() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Container(
            height: 100,
            width: 100,
            child: Image.asset('assets/images/ic-gg-chat-home.png'),
          ),
          SizedBox(height: 30),
          Container(
            width: 250,
            height: 60,
            child: Text(
              'Kết nối Google Chat\nthành công!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: Text(
              'Cảm ơn quý khách đã sử dụng dịch vụ \nVietQR VN của chúng tôi.',
              style: TextStyle(fontSize: 15),
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
          padding: EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Container(
                height: 50,
                width: 50,
                child: Image.asset('assets/images/ic-gg-chat-home.png'),
              ),
              SizedBox(height: 30),
              Container(
                width: 350,
                child: Text(
                  'Đầu tiên, chọn tài khoản\nngân hàng mà bạn muốn\nnhận BĐSD qua Google Chat',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
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
              MySeparator(
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
          padding: EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Container(
                height: 50,
                width: 50,
                child: Image.asset('assets/images/ic-gg-chat-home.png'),
              ),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                child: Text(
                  'Tiếp theo, vui lòng thực hiện theo hướng dẫn và nhập URL Webhook',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
              SizedBox(height: 20),
              // InkWell(
              //   onTap: onGuide,
              //   child: Container(
              //     height: 50,
              //     margin: EdgeInsets.only(right: 40),
              //     decoration: BoxDecoration(
              //       color: AppColor.BLUE_TEXT.withOpacity(0.3),
              //       borderRadius: BorderRadius.circular(5),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Container(
              //           width: 15,
              //           height: 15,
              //           child:
              //               Image.asset('assets/images/ic-guides-ggchat.png'),
              //         ),
              //         const SizedBox(
              //           width: 10,
              //         ),
              //         Text(
              //           'Xem hướng dẫn tại đây',
              //           style:
              //               TextStyle(color: AppColor.BLUE_TEXT, fontSize: 15),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Container(
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
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: AppColor.GREY_TEXT, width: 0.5),
                    )),
                child: TextField(
                  focusNode: value.focusNode,
                  controller: textController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,
                  onSubmitted: onSubmitInput,
                  onChanged: onChangeInput,
                  decoration: InputDecoration(
                    hintText: 'Nhập đường dẫn Webhook tại đây',
                    hintStyle:
                        TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  style: TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: onGuide,
                child: Container(
                  height: 50,
                  // margin: EdgeInsets.only(right: 40),
                  decoration: BoxDecoration(
                    color: AppColor.BLUE_TEXT.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        child:
                            Image.asset('assets/images/ic-guides-ggchat.png'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Xem hướng dẫn tại đây',
                        style:
                            TextStyle(color: AppColor.BLUE_TEXT, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: textController.text.isNotEmpty
                    ? (!value.isValidWebhook ? true : false)
                    : false,
                child: Container(
                  // height: 20,
                  margin: EdgeInsets.only(right: 40, top: 20),
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Webhook không hợp lệ.',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Vui lòng kiểm tra lại thông tin.',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      )
                    ],
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
