import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/connect_gg_chat/states/connect_gg_chat_states.dart';
import 'package:vierqr/features/connect_gg_chat/views/info_gg_chat_widget.dart';

import '../../commons/constants/configurations/app_images.dart';
import '../../commons/enums/enum_type.dart';
import '../../commons/utils/custom_button_switch.dart';
import '../../commons/utils/image_utils.dart';
import '../../commons/widgets/dialog_widget.dart';
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
  late ConnectGgChatBloc _bloc;
  late ConnectGgChatProvider _provider;
  bool hasInfo = true;
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _provider = Provider.of<ConnectGgChatProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  initData({bool isRefresh = false}) {
    if (isRefresh) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectGgChatBloc, ConnectGgChatStates>(
      listener: (context, state) {
        if (state.status == BlocStatus.LOADING) {
          DialogWidget.instance.openLoadingDialog();
        }
        if (state.status == BlocStatus.UNLOADING) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Consumer<ConnectGgChatProvider>(
          builder: (context, value, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: true,
              bottomNavigationBar:
                  hasInfo == false ? bottomButton() : const SizedBox.shrink(),
              body: CustomScrollView(
                // physics: NeverScrollableScrollPhysics(),
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
                      // height: MediaQuery.of(context).size.height,
                      child: hasInfo == false
                          ? PageView(
                              controller: _pageController,
                              children: [
                                startConnectGgChat(),
                                listAccountLinked(value),
                              ],
                            )
                          : InfoGgChatWidget(bloc: _bloc),
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

  Widget listAccountLinked(ConnectGgChatProvider provider) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(left: 40, right: 20),
      width: double.infinity,
      child: SingleChildScrollView(
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  CustomCupertinoSwitch(
                    value: provider.isAllLinked,
                    onChanged: (value) {
                      _provider.changeAllValue(value);
                    },
                  ),
                ],
              ),
            ),
            MySeparator(
              color: AppColor.GREY_DADADA,
            ),
            for (int i = 0; i < provider.linkedStatus.length; i++)
              _itemBank(i, provider),
          ],
        ),
      ),
    );
  }

  Widget _itemBank(int index, ConnectGgChatProvider provider) {
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
                ),
                child: Center(child: Text('Logo')), // Placeholder for bank logo
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1123355589',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text('PHAM DUC HIEU', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
          CustomCupertinoSwitch(
            value: provider.linkedStatus[index],
            onChanged: (value) {
              provider.linkedStatus[index] = value;
              // Kiểm tra nếu tất cả đều được chọn
              provider.changeAllValue(false);
            },
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
        onTap: () {
          _pageController.nextPage(
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        },
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
