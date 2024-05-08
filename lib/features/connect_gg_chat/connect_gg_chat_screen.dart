import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/connect_gg_chat/states/connect_gg_chat_states.dart';
import 'package:vierqr/features/connect_gg_chat/views/info_gg_chat_screen.dart';
import 'package:vierqr/features/connect_gg_chat/views/webhook_gg_chat_screen.dart';
import 'package:vierqr/features/connect_gg_chat/widgets/popup_add_bank_widget.dart';
import 'package:vierqr/models/trans/trans_request_dto.dart';

import '../../commons/constants/configurations/app_images.dart';
import '../../commons/enums/enum_type.dart';
import '../../commons/utils/custom_button_switch.dart';
import '../../commons/widgets/dialog_widget.dart';
import '../../layouts/m_button_widget.dart';
import '../../models/bank_account_dto.dart';
import '../../services/providers/connect_gg_chat_provider.dart';
import '../../services/providers/invoice_provider.dart';
import 'blocs/connect_gg_chat_bloc.dart';
import 'events/connect_gg_chat_evens.dart';

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

  PageController _pageController = PageController(initialPage: 0);
  TextEditingController _textEditingController = TextEditingController();

  int currentPageIndex = 0;
  bool hasInfo = false;

  List<BankAccountDTO> list = [];

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _provider = Provider.of<ConnectGgChatProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _provider.setUnFocusNode();
    _pageController.dispose();
    _textEditingController.dispose();
  }

  initData() {
    _textEditingController.clear();
    list = Provider.of<InvoiceProvider>(context, listen: false).listBank!;
    if (list.isNotEmpty) {
      _provider.init(list);
    }
    _bloc.add(GetInfoEvent());
  }

  void deleteWebhook(String id) {
    _bloc.add(DeleteWebhookEvent(id: id));
    initData();
  }

  void onPopupAddBank() async {
    if (list.isNotEmpty) {
      await showCupertinoModalPopup(
        context: context,
        builder: (context) => PopupAddBankWidget(),
      );
    }
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
        switch (state.request) {
          case ConnectGgChat.GET_INFO:
            hasInfo = state.hasInfo!;
            break;
          case ConnectGgChat.CHECK_URL:
            _provider.checkValidInput(state.isValidUrl!);
            Navigator.pop(context);
            if (state.isValidUrl == true) {
              _provider.setUnFocusNode();
              List<String> listId = _provider.getListId();
              if (listId.isNotEmpty) {
                _bloc.add(MakeGgChatConnectionEvent(
                    webhook: _textEditingController.text, listBankId: listId));
              }
            }
            break;
          case ConnectGgChat.MAKE_CONNECTION:
            if (state.isConnectSuccess == true) {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
            }
            break;
          case ConnectGgChat.DELETE_URL:
            hasInfo = state.hasInfo!;
            break;
          default:
            break;
        }
      },
      builder: (context, state) {
        return Consumer<ConnectGgChatProvider>(
          builder: (context, provider, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: false,
              bottomNavigationBar:
                  hasInfo == false && state.status != BlocStatus.LOADING_PAGE
                      ? bottomButton(state)
                      : const SizedBox.shrink(),
              body: state.status != BlocStatus.LOADING_PAGE
                  ? CustomScrollView(
                      physics: hasInfo == false
                          ? NeverScrollableScrollPhysics()
                          : AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverAppBar(
                          pinned: false,
                          leadingWidth: 100,
                          leading: InkWell(
                            onTap: () {
                              if (currentPageIndex > 0 && hasInfo == false) {
                                _pageController.previousPage(
                                  duration: Duration(milliseconds: 200),
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
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
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
                                ? WebhookGgChatScreen(
                                    textController: _textEditingController,
                                    controller: _pageController,
                                    onChangeInput: (text) {
                                      provider.validateInput(text);
                                    },
                                    onSubmitInput: (value) {
                                      _bloc.add(
                                          CheckWebhookUrlEvent(url: value));
                                    },
                                    onPageChanged: (index) {
                                      setState(() {
                                        currentPageIndex = index;
                                      });
                                    },
                                  )
                                : InfoGgChatScreen(
                                    dto: state.dto!,
                                    onPopup: () {
                                      onPopupAddBank();
                                    },
                                    onDelete: () {
                                      deleteWebhook(state.dto!.id!);
                                    },
                                  ),
                          ),
                        )
                      ],
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            );
          },
        );
      },
    );
  }

  Widget bottomButton(ConnectGgChatStates state) {
    bool isEnable = true;
    String buttonText = '';
    if (currentPageIndex == 0) {
      buttonText = 'Bắt đầu kết nối';
    } else if (currentPageIndex == 1) {
      buttonText = 'Tiếp tục';

      isEnable = _provider.listBank.any((element) => element.value == true);
    } else if (currentPageIndex == 2) {
      buttonText = 'Kết nối';
      if (_textEditingController.text == '') {
        isEnable = false;
      } else {
        isEnable = _provider.isValidWebhook;
      }
    } else if (currentPageIndex == 3) {
      buttonText = 'Hoàn thành';
    }

    Color textColor = isEnable ? AppColor.WHITE : AppColor.BLACK;
    Color iconColor = isEnable ? AppColor.WHITE : AppColor.BLACK;
    Color icon1Color = isEnable ? AppColor.BLUE_TEXT : AppColor.GREY_BUTTON;

    return Container(
      width: double.infinity,
      height: 100 + MediaQuery.of(context).viewInsets.bottom,
      child: MButtonWidget(
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        height: 50,
        isEnable: isEnable,
        colorDisableBgr: AppColor.GREY_BUTTON,
        colorDisableText: AppColor.BLACK,
        title: '',
        onTap: () {
          switch (currentPageIndex) {
            case 0:
              _pageController.nextPage(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
              break;
            case 1:
              _pageController.nextPage(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
              break;
            case 2:
              if (_textEditingController.text != '' &&
                  _provider.isValidWebhook == true) {
                _bloc.add(
                    CheckWebhookUrlEvent(url: _textEditingController.text));
              }
              break;
            case 3:
              _pageController.jumpToPage(0);
              initData();

              break;
            default:
              break;
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
