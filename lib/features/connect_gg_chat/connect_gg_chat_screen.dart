import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/connect_gg_chat/states/connect_gg_chat_states.dart';
import 'package:vierqr/features/connect_gg_chat/views/info_gg_chat_widget.dart';
import 'package:vierqr/models/trans/trans_request_dto.dart';

import '../../commons/constants/configurations/app_images.dart';
import '../../commons/enums/enum_type.dart';
import '../../commons/utils/custom_button_switch.dart';
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
  bool hasInfo = false;
  PageController _pageController = PageController(initialPage: 0);
  int currentPageIndex = 0;
  bool isEnableButton1 = true;
  bool isEnableButton2 = true;

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
                slivers: [
                  SliverAppBar(
                    pinned: false,
                    leadingWidth: 100,
                    leading: InkWell(
                      onTap: () {
                        if (currentPageIndex > 0) {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.of(context).pop();
                        }
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
                      child: hasInfo == false
                          ? Container(
                              height: MediaQuery.of(context).size.height,
                              child: PageView(
                                controller: _pageController,
                                physics: NeverScrollableScrollPhysics(),
                                onPageChanged: (int index) {
                                  setState(() {
                                    currentPageIndex = index;
                                  });
                                },
                                children: [
                                  startConnectGgChat(),
                                  listAccountLinked(),
                                  start1ConnectGgChat(),
                                  finishConnectGgChat(),
                                ],
                              ),
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

  Widget finishConnectGgChat() {
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

  Widget start1ConnectGgChat() {
    bool isValid = false;
    return Container(
      padding: EdgeInsets.only(left: 40),
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
              'Tiếp theo, vui lòng\nthực hiện theo hướng dẫn\nvà nhập URL Webhook',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          SizedBox(height: 30),
          Container(
            height: 50,
            margin: EdgeInsets.only(right: 40),
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
                  child: Image.asset('assets/images/ic-guides-ggchat.png'),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Xem hướng dẫn tại đây',
                  style: TextStyle(color: AppColor.BLUE_TEXT, fontSize: 15),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Container(
            height: 20,
            child: Text(
              'Webhook Google Chat',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 40),
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: AppColor.GREY_TEXT, width: 0.5),
                )),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Nhập đường dẫn Webhook tại đây',
                  hintStyle: TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
                  contentPadding: EdgeInsets.symmetric(vertical: 15)),
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            height: 20,
            margin: EdgeInsets.only(right: 40),
            alignment: Alignment.centerRight,
            child: Visibility(
              visible: !isValid,
              child: Text(
                'Webhook không hợp lệ.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Container(
            height: 20,
            margin: EdgeInsets.only(right: 40),
            alignment: Alignment.centerRight,
            child: Visibility(
              visible: !isValid,
              child: Text(
                'Vui lòng kiểm tra lại thông tin.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                ),
              ),
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
          padding: EdgeInsets.only(left: 40, right: 20),
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
                    CustomCupertinoSwitch(
                      value: provider.isAllLinked,
                      onChanged: (value) {
                        provider.changeAllValue(value);
                      },
                    ),
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
                    return _itemBank(provider.linkedStatus[index], index);
                  },
                  itemCount: provider.linkedStatus.length,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _itemBank(bool value, int index) {
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
            value: value,
            onChanged: (value) {
              _provider.selectValue(value, index);
              // provider.linkedStatus[index] = value;
              // Kiểm tra nếu tất cả đều được chọn
            },
          ),
        ],
      ),
    );
  }

  Widget bottomButton() {
    bool isEnable = true;
    String buttonText = '';
    if (currentPageIndex == 0) {
      buttonText = 'Bắt đầu kết nối';
    } else if (currentPageIndex == 1) {
      buttonText = 'Tiếp tục';
      isEnable = isEnableButton1;
    } else if (currentPageIndex == 2) {
      buttonText = 'Kết nối';
      isEnable = isEnableButton2;
    } else if (currentPageIndex == 3) {
      buttonText = 'Hoàn thành';
    }

    Color textColor = isEnable ? AppColor.WHITE : AppColor.BLACK;
    Color iconColor = isEnable ? AppColor.WHITE : AppColor.BLACK;
    Color icon1Color = isEnable ? AppColor.BLUE_TEXT : AppColor.GREY_BUTTON;

    return Container(
      width: double.infinity,
      child: MButtonWidget(
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        height: 50,
        isEnable: isEnable,
        colorDisableBgr: AppColor.GREY_BUTTON,
        colorDisableText: AppColor.BLACK,
        title: '',
        onTap: () {
          if (currentPageIndex < 2) {
            _pageController.nextPage(
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          } else if (currentPageIndex == 2) {
            _pageController.nextPage(
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          } else {
            Navigator.of(context).pop();
            // Thực hiện kết nối khi ở trang cuối cùng
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.arrow_forward, color: icon1Color, size: 20),
            Text(buttonText, style: TextStyle(fontSize: 15, color: textColor)),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.arrow_forward, color: iconColor, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
