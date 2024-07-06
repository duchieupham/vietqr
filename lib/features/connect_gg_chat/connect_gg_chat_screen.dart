import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/connect_gg_chat/states/connect_gg_chat_states.dart';
import 'package:vierqr/features/connect_gg_chat/views/info_gg_chat_screen.dart';
import 'package:vierqr/features/connect_gg_chat/views/webhook_gg_chat_screen.dart';
import 'package:vierqr/features/connect_gg_chat/widgets/popup_add_bank_widget.dart';
import 'package:vierqr/features/connect_gg_chat/widgets/popup_delete_webhook_widget.dart';
import 'package:vierqr/features/connect_gg_chat/widgets/popup_guide_widget.dart';
import 'package:vierqr/models/trans/trans_request_dto.dart';

import '../../commons/constants/configurations/app_images.dart';
import '../../commons/enums/enum_type.dart';
import '../../commons/utils/custom_button_switch.dart';
import '../../commons/widgets/dialog_widget.dart';
import '../../layouts/m_button_widget.dart';
import '../../models/bank_account_dto.dart';
import '../../models/connect_gg_chat_info_dto.dart';
import '../../services/providers/connect_gg_chat_provider.dart';
import '../../services/providers/invoice_provider.dart';
import 'blocs/connect_gg_chat_bloc.dart';
import 'events/connect_gg_chat_evens.dart';

class ConnectGgChatScreen extends StatelessWidget {
  const ConnectGgChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _Screen();
  }
}

class _Screen extends StatefulWidget {
  const _Screen({super.key});

  @override
  State<_Screen> createState() => __ScreenState();
}

class __ScreenState extends State<_Screen> {
  // late ConnectGgChatBloc _bloc;
  late ConnectGgChatProvider _provider;
  final _bloc = getIt.get<ConnectGgChatBloc>();
  PageController _pageController = PageController(initialPage: 0);
  TextEditingController _textEditingController = TextEditingController();

  int currentPageIndex = 0;
  bool hasInfo = false;
  bool? isFirst;

  List<BankAccountDTO> list = [];

  bool isChecked1 = true;
  bool isChecked2 = true;
  bool isChecked3 = true;
  bool isChecked4 = true;
  bool isChecked5 = true;
  bool isChecked6 = true;

  @override
  void initState() {
    super.initState();
    // _bloc = getIt.get<ConnectGgChatBloc>();
    _provider = Provider.of<ConnectGgChatProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _textEditingController.dispose();
  }

  initData() {
    isFirst = true;
    _textEditingController.clear();
    list = Provider.of<InvoiceProvider>(context, listen: false).listBank!;
    if (list.isNotEmpty) {
      _provider.init(list);
    }
    _bloc.add(GetInfoEvent());
  }

  void deleteWebhook(String id) {
    DialogWidget.instance.openDialogIntroduce(
        ctx: context,
        child: PopupDeleteWebhookWidget(
          onDelete: () {
            Navigator.of(context).pop();
            _bloc.add(DeleteWebhookEvent(id: id));
          },
        ));
  }

  void onRemoveBank(String? bankId, String? webhookId) {
    _bloc.add(RemoveGgChatEvent(bankId: bankId, webhookId: webhookId));
  }

  void onPopupAddBank(List<BankInfoGgChat> listBank, String webhookId) async {
    Set<String?> idsInList = listBank.map((bank) => bank.bankId).toSet();
    List<BankAccountDTO> filteredList =
        list.where((account) => !idsInList.contains(account.id)).toList();
    _provider.init(filteredList);
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => PopupAddBankWidget(
        onAddBank: () {
          List<String> listId = _provider.getListId();
          if (listId.isNotEmpty) {
            _bloc.add(
                AddBankGgChatEvent(webhookId: webhookId, listBankId: listId));
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  void onOpenGuide() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => PopupGuideWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectGgChatBloc, ConnectGgChatStates>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.status == BlocStatus.LOADING) {
          DialogWidget.instance.openLoadingDialog();
        }
        if (state.status == BlocStatus.UNLOADING) {
          Navigator.pop(context);
        }
        switch (state.request) {
          case ConnectGgChat.GET_INFO:
            isFirst = false;
            hasInfo = state.hasInfo!;
            break;
          case ConnectGgChat.CHECK_URL:
            _provider.checkValidInput(state.isValidUrl!);
            Navigator.pop(context);

            if (state.isValidUrl == true) {
              _provider.setUnFocusNode();
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
            }
            break;
          case ConnectGgChat.MAKE_CONNECTION:
            if (state.isConnectSuccess == true) {
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
            }
            break;
          case ConnectGgChat.ADD_BANKS:
            if (state.isAddSuccess == true) {
              _bloc.add(GetInfoEvent());
            }
            // initData();
            break;
          case ConnectGgChat.DELETE_URL:
            isFirst = true;
            _bloc.add(GetInfoEvent());
            break;
          case ConnectGgChat.REMOVE_BANK:
            _bloc.add(GetInfoEvent());
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
              body: CustomScrollView(
                physics: hasInfo == false
                    ? const NeverScrollableScrollPhysics()
                    : const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: false,
                    leadingWidth: 100,
                    leading: InkWell(
                      onTap: () {
                        if (currentPageIndex > 0 && hasInfo == false) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 200),
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
                    child: isFirst != true
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            child: hasInfo == false
                                ? WebhookGgChatScreen(
                                    isChecked1: isChecked1,
                                    isChecked2: isChecked2,
                                    isChecked3: isChecked3,
                                    isChecked4: isChecked4,
                                    isChecked5: isChecked5,
                                    isChecked6: isChecked6,
                                    onChecked: (value, type) {
                                      switch (type) {
                                        case 1:
                                          isChecked1 = value ?? true;
                                          break;
                                        case 2:
                                          isChecked2 = value ?? true;
                                          break;
                                        case 3:
                                          isChecked3 = value ?? true;
                                          break;
                                        case 4:
                                          isChecked4 = value ?? true;
                                          break;
                                        case 5:
                                          isChecked5 = value ?? true;
                                          break;
                                        case 6:
                                          isChecked6 = value ?? true;
                                          break;
                                        default:
                                          break;
                                      }
                                      setState(() {});
                                    },
                                    textController: _textEditingController,
                                    controller: _pageController,
                                    onGuide: onOpenGuide,
                                    onChangeInput: (text) {
                                      provider.validateInput(text);
                                    },
                                    onSubmitInput: (value) {
                                      _provider.setUnFocusNode();
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
                                      onPopupAddBank(
                                          state.dto!.banks!.isNotEmpty
                                              ? state.dto!.banks!
                                              : [],
                                          state.dto!.id!);
                                    },
                                    onDelete: () {
                                      deleteWebhook(state.dto!.id!);
                                    },
                                    onRemoveBank: (bankId) {
                                      if (bankId.isNotEmpty || bankId != null) {
                                        onRemoveBank(bankId, state.dto!.id);
                                      }
                                    },
                                  ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Center(
                              child: CircularProgressIndicator(),
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

  Widget bottomButton(ConnectGgChatStates state) {
    bool isEnable = true;
    String buttonText = '';
    if (currentPageIndex == 0) {
      buttonText = 'Bắt đầu kết nối';
    } else if (currentPageIndex == 1) {
      buttonText = 'Tiếp tục';

      isEnable = _provider.listBank.any((element) => element.value == true);
    } else if (currentPageIndex == 2) {
      buttonText = 'Tiếp tục';
      if (_textEditingController.text == '') {
        isEnable = false;
      } else {
        isEnable = _provider.isValidWebhook;
      }
    } else if (currentPageIndex == 3) {
      buttonText = 'Tiếp tục';
    } else if (currentPageIndex == 4) {
      buttonText = 'Tiếp tục';
    }

    Color textColor = isEnable ? AppColor.WHITE : AppColor.BLACK;
    Color iconColor = isEnable ? AppColor.WHITE : AppColor.BLACK;
    Color icon1Color = isEnable ? AppColor.BLUE_TEXT : AppColor.GREY_BUTTON;

    return Container(
      width: double.infinity,
      height: 70 + MediaQuery.of(context).viewInsets.bottom,
      child: MButtonWidget(
        margin: EdgeInsets.symmetric(horizontal: 40),
        height: 50,
        isEnable: isEnable,
        colorDisableBgr: AppColor.GREY_BUTTON,
        colorDisableText: AppColor.BLACK,
        title: '',
        onTap: () {
          switch (currentPageIndex) {
            case 0:
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
              break;
            case 1:
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
              break;
            case 2:
              if (_textEditingController.text != '' &&
                  _provider.isValidWebhook == true) {
                _provider.setUnFocusNode();
                _bloc.add(
                    CheckWebhookUrlEvent(url: _textEditingController.text));
              }

              break;
            case 3:
              List<String> listId = _provider.getListId();
              List<String> notificationTypes = [];
              List<String> notificationContents = [];
              if (isChecked1) notificationTypes.add('CREDIT');
              if (isChecked2) notificationTypes.add('DEBIT');
              if (isChecked3) notificationTypes.add('RECON');

              if (isChecked4) notificationContents.add('AMOUNT');
              if (isChecked5) notificationContents.add('REFERENCE_NUMBER');
              if (isChecked6) notificationContents.add('CONTENT');

              if (listId.isNotEmpty) {
                _bloc.add(MakeGgChatConnectionEvent(
                    webhook: _textEditingController.text,
                    listBankId: listId,
                    notificationTypes: notificationTypes,
                    notificationContents: notificationContents));
              }
              break;
            case 4:
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
