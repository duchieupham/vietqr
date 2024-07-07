import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/connect_media/states/connect_media_states.dart';
import 'package:vierqr/features/connect_media/views/info_media_screen.dart';
import 'package:vierqr/features/connect_media/views/webhook_media_screen.dart';
import 'package:vierqr/features/connect_media/widgets/popup_add_bank_widget.dart';
import 'package:vierqr/features/connect_media/widgets/popup_delete_webhook_widget.dart';
import 'package:vierqr/features/connect_media/widgets/popup_guide_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/trans/trans_request_dto.dart';
import 'package:vierqr/navigator/app_navigator.dart';

import '../../commons/constants/configurations/app_images.dart';
import '../../commons/enums/enum_type.dart';
import '../../commons/utils/custom_button_switch.dart';
import '../../commons/widgets/dialog_widget.dart';
import '../../layouts/m_button_widget.dart';
import '../../models/bank_account_dto.dart';
import '../../models/connect_gg_chat_info_dto.dart';
import '../../services/providers/connect_gg_chat_provider.dart';
import '../../services/providers/invoice_provider.dart';
import 'blocs/connect_media_bloc.dart';
import 'events/connect_media_evens.dart';

// ignore: constant_identifier_names
enum TypeConnect { GG_CHAT, TELE, LARK }

class ConnectMediaScreen extends StatelessWidget {
  final TypeConnect type;
  const ConnectMediaScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return _Screen(
      type: type,
    );
  }
}

class _Screen extends StatefulWidget {
  final TypeConnect type;
  const _Screen({super.key, required this.type});

  @override
  State<_Screen> createState() => __ScreenState();
}

class __ScreenState extends State<_Screen> {
  // late ConnectGgChatBloc _bloc;
  late ConnectGgChatProvider _provider;
  final _bloc = getIt.get<ConnectMediaBloc>();
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

  TypeConnect typeConnect = TypeConnect.GG_CHAT;

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
    typeConnect = widget.type;
    isFirst = true;
    _textEditingController.clear();
    list = Provider.of<InvoiceProvider>(context, listen: false).listBank!;
    if (list.isNotEmpty) {
      _provider.init(list);
    }
    _bloc.add(GetInfoEvent(type: typeConnect));
  }

  void deleteWebhook(String id) {
    DialogWidget.instance.openDialogIntroduce(
        ctx: context,
        child: PopupDeleteWebhookWidget(
          onDelete: () {
            Navigator.of(context).pop();
            _bloc.add(DeleteWebhookEvent(id: id, type: typeConnect));
          },
        ));
  }

  void onRemoveBank(String? bankId, String? webhookId) {
    _bloc.add(RemoveMediaEvent(
        bankId: bankId, webhookId: webhookId, type: typeConnect));
  }

  void onPopupAddBank(List<BankMedia> listBank, String webhookId) async {
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
            _bloc.add(AddBankMediaEvent(
                webhookId: webhookId, listBankId: listId, type: typeConnect));
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  void onOpenGuide() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => PopupGuideWidget(
        type: widget.type,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectMediaBloc, ConnectMediaStates>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.status == BlocStatus.LOADING) {
          DialogWidget.instance.openLoadingDialog();
        }
        if (state.status == BlocStatus.UNLOADING) {
          Navigator.pop(context);
        }
        switch (state.request) {
          case ConnectMedia.GET_INFO:
            isFirst = false;
            hasInfo = state.hasInfo!;
            break;
          case ConnectMedia.CHECK_URL:
            _provider.checkValidInput(state.isValidUrl!);
            Navigator.pop(context);

            if (state.isValidUrl == true) {
              _provider.setUnFocusNode();
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
            }
            break;
          case ConnectMedia.MAKE_CONNECTION:
            if (state.isConnectSuccess == true) {
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
            }
            break;
          case ConnectMedia.ADD_BANKS:
            if (state.isAddSuccess == true) {
              _bloc.add(GetInfoEvent(type: typeConnect));
            }
            // initData();
            break;
          case ConnectMedia.DELETE_URL:
            isFirst = true;
            _bloc.add(GetInfoEvent(type: typeConnect));
            break;
          case ConnectMedia.REMOVE_BANK:
            _bloc.add(GetInfoEvent(type: typeConnect));
            break;
          case ConnectMedia.UPDATE_SHARING:
            if (state.status == BlocStatus.SUCCESS) {
              _bloc.add(GetInfoEvent(type: typeConnect));
            }
            break;
          case ConnectMedia.UPDATE_URL:
            if (state.status == BlocStatus.SUCCESS) {
              _bloc.add(GetInfoEvent(type: typeConnect));
            }
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
              appBar: _buildAppBar(state),
              bottomNavigationBar:
                  hasInfo == false && state.status != BlocStatus.LOADING_PAGE
                      ? bottomButton(state)
                      : const SizedBox.shrink(),
              body: isFirst != true
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: hasInfo == false
                          ? WebhookMediaScreen(
                              type: typeConnect,
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
                                provider.validateInput(text, typeConnect);
                              },
                              onSubmitInput: (value) {
                                _provider.setUnFocusNode();
                                _bloc.add(CheckWebhookUrlEvent(
                                    url: value, type: typeConnect));
                              },
                              onPageChanged: (index) {
                                setState(() {
                                  currentPageIndex = index;
                                });
                              },
                            )
                          : InfoMediaScreen(
                              type: typeConnect,
                              dto: state.dto!,
                              onPopup: () {
                                onPopupAddBank(
                                    state.dto!.banks.isNotEmpty
                                        ? state.dto!.banks
                                        : [],
                                    state.dto!.id);
                              },
                              onDelete: () {
                                deleteWebhook(state.dto!.id);
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
            );
          },
        );
      },
    );
  }

  Widget bottomButton(ConnectMediaStates state) {
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
                _bloc.add(CheckWebhookUrlEvent(
                    url: _textEditingController.text, type: typeConnect));
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
                _bloc.add(MakeMediaConnectionEvent(
                    type: typeConnect,
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

  _buildAppBar(ConnectMediaStates state) {
    return AppBar(
      forceMaterialTransparency: true,
      backgroundColor: AppColor.WHITE,
      leadingWidth: double.infinity,
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
          child: const Row(
            children: [
              Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
                size: 25,
              ),
              SizedBox(width: 2),
              Text(
                "Trở về",
                style: TextStyle(color: Colors.black, fontSize: 14),
              )
            ],
          ),
        ),
      ),
      actions: [
        if (!hasInfo)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Image.asset(
              AppImages.icLogoVietQr,
              width: 95,
              fit: BoxFit.fitWidth,
            ),
          )
        else
          GestureDetector(
            onTapDown: (TapDownDetails details) {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  details.globalPosition.dx,
                  details.globalPosition.dy + 20,
                  details.globalPosition.dx,
                  details.globalPosition.dy + 20,
                ),
                items: <PopupMenuEntry<int>>[
                  const PopupMenuItem<int>(
                    value: 0,
                    child: ListTile(
                      title: Text(
                        'Thêm TK ngân hàng',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: ListTile(
                      title: Text(
                        'Cập nhật Webhook',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: ListTile(
                      title: Text(
                        'Cập nhật thông tin chia sẻ',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 3,
                    child: ListTile(
                      title: Text(
                        'Huỷ kết nối',
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ).then(
                (value) {
                  switch (value) {
                    case 0:
                      onPopupAddBank(
                          state.dto!.banks.isNotEmpty ? state.dto!.banks : [],
                          state.dto!.id);
                      break;
                    case 1:
                      final data = state.dto;
                      if (data != null) {
                        NavigationService.push(Routes.UPDATE_MEDIA_URL,
                            arguments: {
                              'type': typeConnect,
                              'id': data.id,
                            });
                      }
                      break;
                    case 2:
                      final data = state.dto;
                      if (data != null) {
                        NavigationService.push(Routes.UPDATE_SHARE_INFO_MEDIA,
                            arguments: {
                              'notificationTypes': data.notificationTypes,
                              'notificationContents': data.notificationContents,
                              'type': typeConnect,
                              'id': data.id,
                            });
                      }
                      break;
                    case 3:
                      deleteWebhook(state.dto!.id);
                      break;
                    default:
                      break;
                  }
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.only(right: 10),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: const LinearGradient(
                      colors: [Color(0xFFE1EFFF), const Color(0xFFE5F9FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight)),
              child:
                  const XImage(imagePath: 'assets/images/ic-option-black.png'),
            ),
          ),
      ],
    );
  }
}
