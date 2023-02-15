import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/setting_bank_sheet.dart';
import 'package:vierqr/features/log_sms/blocs/sms_bloc.dart';
import 'package:vierqr/features/log_sms/blocs/transaction_bloc.dart';
import 'package:vierqr/features/login/blocs/login_bloc.dart';
import 'package:vierqr/features/login/events/login_event.dart';
import 'package:vierqr/features/notification/blocs/notification_bloc.dart';
import 'package:vierqr/features/log_sms/events/sms_event.dart';
import 'package:vierqr/features/log_sms/events/transaction_event.dart';
import 'package:vierqr/features/notification/events/notification_event.dart';
import 'package:vierqr/features/log_sms/sms_detail.dart';
import 'package:vierqr/features/log_sms/states/sms_state.dart';
import 'package:vierqr/features/log_sms/states/transaction_state.dart';
import 'package:vierqr/features/log_sms/widgets/sms_list_item.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/features/notification/states/notification_state.dart';
import 'package:vierqr/features/bank_card/blocs/bank_manage_bloc.dart';
import 'package:vierqr/features/bank_card/states/bank_manage_state.dart';
import 'package:vierqr/features/personal/views/qr_scanner.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/transaction_dto.dart';
import 'package:vierqr/services/providers/bank_select_provider.dart';
import 'package:vierqr/services/providers/shortcut_provider.dart';
import 'package:vierqr/services/providers/suggestion_widget_provider.dart';
import 'package:vierqr/services/shared_references/event_bloc_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class SMSList extends StatelessWidget {
  static final Map<String, List<TransactionDTO>> transactionByAddr = {};
  static late SMSBloc _smsBloc;
  static late TransactionBloc _transactionBloc;
  static late NotificationBloc _notificationBloc;
  static late LoginBloc _loginBloc;

  static final TextEditingController _bankAccountController =
      TextEditingController();
  static final TextEditingController _bankAccountNameController =
      TextEditingController();

  const SMSList({Key? key}) : super(key: key);

  initialServices(BuildContext context) {
    String userId = UserInformationHelper.instance.getUserId();
    _transactionBloc = BlocProvider.of(context);
    _notificationBloc = BlocProvider.of(context);
    _smsBloc = BlocProvider.of(context);
    _loginBloc = BlocProvider.of(context);
    // _transactionBloc.add(TransactionEventGetList(userId: userId));
    //android process
    if (!EventBlocHelper.instance.isListenedNotification()) {
      _notificationBloc.add(NotificationEventListen(
          userId: userId, notificationBloc: _notificationBloc));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    initialServices(context);
    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: (PlatformUtils.instance.isAndroidApp(context))
            ? BlocListener<SMSBloc, SMSState>(
                listener: ((context, state) {
                  if (state is SMSReceivedState) {
                    if (BankInformationUtil.instance
                        .checkAvailableAddress(state.messageDTO.address)) {
                      DialogWidget.instance.openTransactionFormattedDialog(
                        state.messageDTO.address,
                        state.messageDTO.body,
                        state.messageDTO.date,
                      );
                    } else {
                      DialogWidget.instance.openTransactionDialog(
                        state.messageDTO.address,
                        state.messageDTO.body,
                      );
                    }
                    _transactionBloc.add(TransactionEventInsert(
                        transactionDTO: state.transactionDTO));
                  }
                  // if (state is SMSDeniedPermissionState) {
                  //   Future.delayed(const Duration(milliseconds: 0), () {
                  //     Provider.of<SuggestionWidgetProvider>(context,
                  //             listen: false)
                  //         .updateSMSPermission(true);
                  //   });
                  // }
                  // if (state is SMSAcceptPermissionState) {
                  //   Future.delayed(const Duration(milliseconds: 0), () {
                  //     Provider.of<SuggestionWidgetProvider>(context,
                  //             listen: false)
                  //         .updateSMSPermission(false);
                  //   });
                  // }
                }),
                child: BlocConsumer<NotificationBloc, NotificationState>(
                    listener: (context, state) {
                  if (state is NotificationReceivedSuccessState) {
                    _notificationBloc.add(NotificationEventUpdateStatus(
                        notificationId: state.notificationId));
                  }
                  if (state is NotificationUpdateSuccessState) {
                    String userId = UserInformationHelper.instance.getUserId();
                    _notificationBloc
                        .add(NotificationEventGetList(userId: userId));
                  }
                  if (state is NotificationListSuccessfulState) {
                    _notificationBloc.add(const NotificationInitialEvent());
                  }
                }, builder: (context, state) {
                  if (state is NotificationReceivedSuccessState) {
                    if (transactionByAddr
                        .containsKey(state.transactionDTO.address)) {
                      transactionByAddr[state.transactionDTO.address]!
                          .insert(0, state.transactionDTO);
                    } else {
                      transactionByAddr[state.transactionDTO.address] = [];
                      transactionByAddr[state.transactionDTO.address]!
                          .insert(0, state.transactionDTO);
                    }
                  }
                  return BlocConsumer<TransactionBloc, TransactionState>(
                    listener: ((context, state) {
                      if (state is TransactionInsertSuccessState) {
                        //insert transaction - notification here
                        _notificationBloc.add(NotificationEventInsert(
                          bankId: state.bankId,
                          transactionId: state.transactionId,
                          timeInserted: state.timeInserted,
                          address: state.address,
                          transaction: state.transaction,
                        ));
                      }
                      if (state is TransactionSuccessfulListState) {
                        transactionByAddr.clear();
                        if (transactionByAddr.isEmpty &&
                            state.list.isNotEmpty) {
                          // _transactions.addAll(state.list);
                          for (TransactionDTO transactionDTO in state.list) {
                            if (transactionByAddr
                                .containsKey(transactionDTO.address)) {
                              transactionByAddr[transactionDTO.address]!.add(
                                transactionDTO,
                              );
                            } else {
                              transactionByAddr[transactionDTO.address] = [];
                              transactionByAddr[transactionDTO.address]!.add(
                                transactionDTO,
                              );
                            }
                          }
                        }
                      }
                    }),
                    builder: ((context, state) {
                      if (state is TransactionSuccessfulListState) {
                        if (state.list.isEmpty) {
                          transactionByAddr.clear();
                        }
                      }
                      return ListView(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          _buildSuggestion(context),
                          _buildShortcut(context),
                          _buildTitle('Danh sách giao dịch'),
                          (state is TransactionLoadingListState)
                              ? SizedBox(
                                  width: width,
                                  height: 200,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: DefaultTheme.GREEN,
                                    ),
                                  ),
                                )
                              : (transactionByAddr.isEmpty)
                                  ? SizedBox(
                                      width: width,
                                      height: 200,
                                      child: const Center(
                                        child: Text(
                                          'Không có giao dịch nào',
                                          style: TextStyle(
                                            color: DefaultTheme.GREY_TEXT,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Visibility(
                                      visible: transactionByAddr.isNotEmpty,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: transactionByAddr.length,
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        itemBuilder: ((context, index) {
                                          String address = transactionByAddr
                                              .values
                                              .elementAt(index)
                                              .first
                                              .address
                                              .toString();
                                          return InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SmsDetailScreen(
                                                    address: address,
                                                    transactions:
                                                        transactionByAddr.values
                                                            .elementAt(index),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: SMSListItem(
                                                transactionDTO:
                                                    transactionByAddr.values
                                                        .elementAt(index)
                                                        .first),
                                          );
                                        }),
                                      ),
                                    ),
                          const Padding(padding: EdgeInsets.only(bottom: 100)),
                        ],
                      );
                    }),
                  );
                }),
              )
            : const SizedBox(),
      ),
    );
  }

  Widget _buildSuggestion(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<SuggestionWidgetProvider>(
      builder: (context, provider, child) {
        if (provider.smsStatus == 2) {
          if (PlatformUtils.instance.isAndroidApp(context)) {
            String userId = UserInformationHelper.instance.getUserId();
            _smsBloc.add(SMSEventListen(
              smsBloc: _smsBloc,
              userId: userId,
            ));
          }
        }
        return (provider.getSuggestion())
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildTitle('Gợi ý'),
                  const Padding(padding: EdgeInsets.only(top: 5)),
                  (provider.smsStatus != 2)
                      ? _buildSuggestionBox(
                          status:
                              'Trạng thái: Quyền truy cập tin nhắn bị từ chối',
                          text:
                              'Cho phép truy cập tin nhắn để đồng bộ giao dịch với hệ thống',
                          icon: Icons.message_rounded,
                          buttonIcon: Icons.settings_rounded,
                          color: DefaultTheme.GREEN,
                          function: () async {
                            await openAppSettings();
                          },
                        )
                      : const SizedBox(),
                  (provider.showCameraPermission)
                      ? _buildSuggestionBox(
                          status:
                              'Trạng thái: Quyền truy cập camera bị từ chối',
                          text:
                              'Cho phép truy cập quyền máy ảnh để thực hiện các chức năng quét mã QR/Barcode',
                          icon: Icons.camera_alt_rounded,
                          buttonIcon: Icons.settings_rounded,
                          color: DefaultTheme.BLUE_TEXT,
                          function: () async {
                            await openAppSettings();
                          },
                        )
                      : const SizedBox(),
                  (provider.showUserUpdate)
                      ? _buildSuggestionBox(
                          status: 'Trạng thái: Chưa cập nhật thông tin cá nhân',
                          text: 'Cập nhật thông tin cá nhân',
                          icon: Icons.person,
                          buttonIcon: Icons.navigate_next_rounded,
                          color: DefaultTheme.RED_CALENDAR,
                          function: () {
                            Navigator.of(context).pushNamed(Routes.USER_EDIT);
                          },
                        )
                      : const SizedBox(),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: (provider.getSuggestion()) ? 20 : 0,
                    ),
                    child: DividerWidget(width: width),
                  ),
                ],
              )
            : const SizedBox();
      },
    );
  }

  Widget _buildShortcut(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<ShortcutProvider>(
      builder: (context, provider, child) {
        return (provider.enableShortcut)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildTitle('Phím tắt'),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            provider.updateExpanded(!provider.expanded);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20, top: 20),
                            child: Icon(
                              (provider.expanded)
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              size: 25,
                              color: DefaultTheme.GREY_TEXT,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  if (provider.expanded) ...[
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildShorcutIcon(
                          widgetWidth: width,
                          title: 'Tạo QR\ngiao dịch',
                          icon: Icons.qr_code_rounded,
                          color: DefaultTheme.GREEN,
                          function: () async {
                            await SettingBankSheet.instance
                                .openChosingBankToCreateQR();
                          },
                        ),
                        BlocListener<BankManageBloc, BankManageState>(
                          listener: (context, state) {
                            if (state is BankManageLoadingState) {
                              DialogWidget.instance.openLoadingDialog();
                            }
                            if (state is BankManageAddFailedState) {
                              DialogWidget.instance.openMsgDialog(
                                  title: 'Không thể tải danh sách',
                                  msg:
                                      'Không thể thêm tài khoản ngân hàng. Vui lòng kiểm tra lại kết nối mạng');
                            }
                            if (state is BankManageAddSuccessState) {
                              //close loading dialog
                              FocusManager.instance.primaryFocus?.unfocus();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                          },
                          child: _buildShorcutIcon(
                            widgetWidth: width,
                            title: 'Thêm TK\nngân hàng',
                            icon: Icons.credit_card_rounded,
                            color: DefaultTheme.PURPLE_NEON,
                            function: () async {
                              // List<String> banks =
                              //     Provider.of<BankSelectProvider>(context,
                              //             listen: false)
                              //         .getListAvailableBank();
                              // resetAddingBankForm(context);
                              // await SettingBankSheet.instance
                              //     .openAddingFormCard(
                              //   banks,
                              //   _bankAccountController,
                              //   _bankAccountNameController,
                              // );
                              Navigator.pushNamed(
                                  context, Routes.ADD_BANK_CARD);
                            },
                          ),
                        ),
                        _buildShorcutIcon(
                          widgetWidth: width,
                          title: 'Thêm\nthành viên',
                          icon: Icons.person_add_alt_rounded,
                          color: DefaultTheme.RED_CALENDAR,
                          function: () async {
                            // await SettingBankSheet.instance.openChosingBank();
                          },
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildShorcutIcon(
                          widgetWidth: width,
                          title: 'Tra cứu\nsố dư',
                          icon: Icons.account_balance_rounded,
                          color: DefaultTheme.ORANGE,
                          function: () async {
                            // await SettingBankSheet.instance.openChosingBank();
                          },
                        ),
                        _buildShorcutIcon(
                          widgetWidth: width,
                          title: 'Lịch sử\ngiao dịch',
                          icon: Icons.search_rounded,
                          color: DefaultTheme.BLUE_TEXT,
                          function: () async {
                            // await SettingBankSheet.instance.openChosingBank();
                          },
                        ),
                        _buildShorcutIcon(
                          widgetWidth: width,
                          title: 'Đăng nhập\nbằng QR',
                          icon: Icons.web_rounded,
                          color: DefaultTheme.VERY_PERI,
                          function: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => const QRScanner(),
                              ),
                            )
                                .then((code) {
                              if (code != null) {
                                if (code.toString().isNotEmpty) {
                                  _loginBloc.add(
                                    LoginEventUpdateCode(
                                      code: code,
                                      userId: UserInformationHelper.instance
                                          .getUserId(),
                                    ),
                                  );
                                }
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],

                  // BoxLayout(
                  //     width: width,
                  //     margin: const EdgeInsets.symmetric(horizontal: 10),
                  //     enableShadow: true,
                  //     child:

                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: (provider.expanded) ? 20 : 0,
                    ),
                    child: DividerWidget(width: width),
                  ),
                ],
              )
            : const SizedBox();
      },
    );
  }

  Widget _buildShorcutIcon(
      {required double widgetWidth,
      required String title,
      required IconData icon,
      required Color color,
      required VoidCallback function}) {
    return InkWell(
      onTap: function,
      child: BoxLayout(
        width: widgetWidth * 0.25,
        height: widgetWidth * 0.25,
        enableShadow: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: widgetWidth * 0.08,
            ),
            const Padding(padding: EdgeInsets.only(top: 5)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionBox({
    required String status,
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback function,
    IconData? buttonIcon,
  }) {
    double width = MediaQuery.of(NavigationService.navigatorKey.currentContext!)
        .size
        .width;
    return InkWell(
      onTap: function,
      child: BoxLayout(
        width: width,
        borderRadius: 10,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        bgColor: color.withOpacity(0.2),
        enableShadow: true,
        child: Row(
          children: [
            Icon(
              icon,
              size: 25,
              color: color,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(
                              NavigationService.navigatorKey.currentContext!)
                          .hintColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 5)),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            (buttonIcon != null)
                ? Container(
                    width: 25,
                    height: 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(
                              NavigationService.navigatorKey.currentContext!)
                          .canvasColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      buttonIcon,
                      size: 15,
                      color: DefaultTheme.GREY_TEXT,
                    ),
                  )
                : const SizedBox(
                    width: 25,
                    height: 25,
                  ),
          ],
        ),
      ),
    );
  }

  void resetAddingBankForm(BuildContext context) {
    _bankAccountController.clear();
    _bankAccountNameController.clear();
    Provider.of<BankSelectProvider>(context, listen: false)
        .updateErrs(false, false, false);
  }
}
