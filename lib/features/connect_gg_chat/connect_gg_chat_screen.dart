import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/features/connect_gg_chat/states/connect_gg_chat_states.dart';

import '../../commons/constants/configurations/app_images.dart';
import '../../commons/constants/configurations/theme.dart';
import '../../layouts/m_button_widget.dart';
import '../../services/providers/connect_gg_chat_provider.dart';
import 'blocs/connect_gg_chat_bloc.dart';

class ConnectGgChatScreen extends StatelessWidget {
  const ConnectGgChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConnectGgChatBloc>(
      create: (context) => ConnectGgChatBloc(context),
      child: _Screen(),
    );
  }
}

class _Screen extends StatefulWidget {
  const _Screen({super.key});

  @override
  State<_Screen> createState() => __ScreenState();
}

class __ScreenState extends State<_Screen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectGgChatBloc, ConnectGgChatStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Consumer<ConnectGgChatProvider>(
          builder: (context, value, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: true,
              bottomNavigationBar: bottomButton(),
              body: CustomScrollView(
                physics: NeverScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: false,
                    leadingWidth: 100,
                    leading: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.black,
                              size: 25,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              "Trở về",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Image.asset(
                          AppImages.icLogoVietQr,
                          width: 95,
                          fit: BoxFit.fitWidth,
                        ),
                      )
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [startConnectGgChat()],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget startConnectGgChat() {
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(left: 40),
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

  Widget bottomButton() {
    return Container(
      width: double.infinity,
      child: MButtonWidget(
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        height: 50,
        isEnable: true,
        title: '',
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.arrow_forward,
              color: AppColor.BLUE_TEXT,
              size: 20,
            ),
            Text(
              'Bắt đầu kết nối',
              style: TextStyle(fontSize: 15, color: AppColor.WHITE),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.arrow_forward,
                color: AppColor.WHITE,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
