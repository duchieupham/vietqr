import 'dart:async';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/numeral.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/sms_information_utils.dart';
import 'package:vierqr/commons/widgets/bank_card_widget.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/pin_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_card_event.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_account_remove_dto.dart';
import 'package:vierqr/models/bank_information_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/services/providers/bank_card_position_provider.dart';
import 'package:vierqr/services/providers/pin_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class DialogWidget {
  //
  const DialogWidget._privateConstructor();
  static const DialogWidget _instance = DialogWidget._privateConstructor();
  static DialogWidget get instance => _instance;

  static bool isPopLoading = false;

  openPINDialog({required String title, required Function(String) onDone}) {
    final FocusNode focusNode = FocusNode();
    focusNode.requestFocus();
    return showDialog(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Material(
          color: DefaultTheme.TRANSPARENT,
          child: Center(
            child: (PlatformUtils.instance.isWeb())
                ? Container(
                    width: 300,
                    height: 300,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        const Text(
                          'Mật khẩu',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        const SizedBox(
                          width: 250,
                          height: 60,
                          child: Text(
                            'Mật khẩu bao gồm 6 số.',
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 80,
                          alignment: Alignment.center,
                          child: PinWidget(
                            width: 300,
                            pinSize: 15,
                            pinLength: Numeral.DEFAULT_PIN_LENGTH,
                            focusNode: focusNode,
                            onDone: onDone,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        ButtonWidget(
                          width: 250,
                          height: 30,
                          text: 'Đóng',
                          textColor: DefaultTheme.WHITE,
                          bgColor: DefaultTheme.GREEN,
                          borderRadius: 5,
                          function: () {
                            focusNode.dispose();
                            Provider.of<PinProvider>(context, listen: false)
                                .reset();
                            Navigator.pop(context);
                          },
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                      ],
                    ),
                  )
                : Container(
                    width: 350,
                    height: 200,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              focusNode.dispose();
                              Provider.of<PinProvider>(context, listen: false)
                                  .reset();
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 25,
                              height: 25,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Theme.of(context).canvasColor,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: DefaultTheme.RED_TEXT,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 50)),
                        PinWidget(
                          width: 350,
                          pinSize: 15,
                          pinLength: Numeral.DEFAULT_PIN_LENGTH,
                          focusNode: focusNode,
                          onDone: onDone,
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  openNotificationDialog({
    required Widget child,
    required double height,
    double? marginRight,
  }) {
    return showDialog(
        context: NavigationService.navigatorKey.currentContext!,
        barrierColor: DefaultTheme.TRANSPARENT,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Align(
            alignment: Alignment.topRight,
            child: UnconstrainedBox(
              child: BoxLayout(
                width: 300,
                height: height * 0.7,
                borderRadius: 5,
                enableShadow: true,
                margin: EdgeInsets.only(
                  right: (marginRight != null) ? marginRight : 120,
                  top: 60,
                ),
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Text(
                        'Thông báo',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          );
        });
  }

  openBoxWebConfirm({
    required String title,
    required String confirmText,
    required String imageAsset,
    required String description,
    required VoidCallback confirmFunction,
    VoidCallback? cancelFunction,
    Color? confirmColor,
  }) {
    return showDialog(
        barrierDismissible: false,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: DefaultTheme.TRANSPARENT,
            child: Center(
              child: Container(
                width: 300,
                height: 350,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      imageAsset,
                      width: 80,
                      height: 80,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    SizedBox(
                      width: 250,
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    ButtonWidget(
                      width: 250,
                      height: 30,
                      text: confirmText,
                      textColor: DefaultTheme.WHITE,
                      bgColor: (confirmColor != null)
                          ? confirmColor
                          : DefaultTheme.BLUE_TEXT,
                      borderRadius: 5,
                      function: confirmFunction,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    ButtonWidget(
                      width: 250,
                      height: 30,
                      text: 'Đóng',
                      textColor: Theme.of(context).hintColor,
                      bgColor: Theme.of(context).canvasColor,
                      borderRadius: 5,
                      function: (cancelFunction != null)
                          ? cancelFunction
                          : () {
                              Navigator.pop(context);
                            },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  openContentDialog(
    VoidCallback? onClose,
    Widget child,
  ) {
    return showDialog(
        barrierDismissible: false,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: DefaultTheme.TRANSPARENT,
            child: Center(
              child: Container(
                width: 500,
                height: 500,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Tooltip(
                        message: 'Đóng',
                        child: InkWell(
                          onTap: (onClose != null)
                              ? onClose
                              : () {
                                  Navigator.pop(context);
                                },
                          child: Container(
                            width: 25,
                            height: 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Theme.of(context).canvasColor,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: DefaultTheme.GREY_TEXT,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: child,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future openDateTimePickerDialog(
      String title, Function(DateTime) onChanged) async {
    double width = MediaQuery.of(NavigationService.navigatorKey.currentContext!)
        .size
        .width;
    return await showModalBottomSheet(
        isScrollControlled: true,
        context: NavigationService.navigatorKey.currentContext!,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: ClipRRect(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                child: Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                    ),
                    width: MediaQuery.of(context).size.width - 10,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: CupertinoDatePicker(
                            initialDateTime: DateTime.now(),
                            maximumDate: DateTime.now(),
                            mode: CupertinoDatePickerMode.dateAndTime,
                            onDateTimeChanged: onChanged,
                          ),
                        ),
                        ButtonWidget(
                          width: width,
                          text: 'OK',
                          textColor: DefaultTheme.WHITE,
                          bgColor: DefaultTheme.GREEN,
                          function: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 20)),
                      ],
                    )),
              ),
            ),
          );
        });
  }

  void openLoadingDialog() async {
    if (!isPopLoading) {
      isPopLoading = true;
      return await showDialog(
          barrierDismissible: false,
          context: NavigationService.navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return Material(
              color: DefaultTheme.TRANSPARENT,
              child: Center(
                child: (PlatformUtils.instance.isWeb())
                    ? Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(
                              color: DefaultTheme.GREEN,
                            ),
                            Padding(padding: EdgeInsets.only(top: 30)),
                            Text(
                              'Đang tải',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: 250,
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const CircularProgressIndicator(
                          color: DefaultTheme.GREEN,
                        ),
                      ),
              ),
            );
          }).then((value) => isPopLoading = false);
    }
  }

  openMsgDialog(
      {required String title, required String msg, VoidCallback? function}) {
    return showDialog(
        barrierDismissible: false,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: DefaultTheme.TRANSPARENT,
            child: Center(
              child: (PlatformUtils.instance.isWeb())
                  ? Container(
                      width: 300,
                      height: 300,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/ic-warning.png',
                            width: 80,
                            height: 80,
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          SizedBox(
                            width: 250,
                            height: 60,
                            child: Text(
                              msg,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 30)),
                          ButtonWidget(
                            width: 250,
                            height: 30,
                            autoFocus: true,
                            text: 'Đóng',
                            textColor: DefaultTheme.WHITE,
                            bgColor: DefaultTheme.GREEN,
                            borderRadius: 5,
                            function: (function != null)
                                ? function
                                : () {
                                    Navigator.pop(context);
                                  },
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                        ],
                      ),
                    )
                  : Container(
                      width: 300,
                      height: 250,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Text(
                            msg,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          ButtonWidget(
                            width: 230,
                            text: 'OK',
                            textColor: DefaultTheme.WHITE,
                            bgColor: DefaultTheme.GREEN,
                            function: (function != null)
                                ? function
                                : () {
                                    Navigator.pop(context);
                                  },
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 20)),
                        ],
                      )),
            ),
          );
        });
  }

  openTransactionDialog(String address, String body) {
    final ScrollController _scrollContoller = ScrollController();
    return showDialog(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Material(
          color: DefaultTheme.TRANSPARENT,
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
              width: 325,
              height: 450,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  const Text(
                    'Giao dịch mới',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  SizedBox(
                    width: 300,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text(
                            'Từ: ',
                            style: TextStyle(
                              fontSize: 15,
                              color: DefaultTheme.GREY_TEXT,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          child: Text(
                            address,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  SizedBox(
                    width: 300,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text(
                            'Nội dung: ',
                            style: TextStyle(
                              fontSize: 15,
                              color: DefaultTheme.GREY_TEXT,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          height: 250,
                          child: SingleChildScrollView(
                            controller: _scrollContoller,
                            child: Text(
                              body,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        color: DefaultTheme.GREEN,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: DefaultTheme.WHITE,
                        ),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  openTransactionFormattedDialog(String address, String body, String? date) {
    final ScrollController scrollContoller = ScrollController();
    final BankInformationDTO dto = SmsInformationUtils.instance.transferSmsData(
      BankInformationUtil.instance.getBankName(address),
      body,
      date,
    );
    Color transactionColor =
        (BankInformationUtil.instance.isIncome(dto.transaction))
            ? DefaultTheme.GREEN
            : DefaultTheme.RED_TEXT;
    return showDialog(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Material(
          color: DefaultTheme.TRANSPARENT,
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
              width: 325,
              height: 450,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  const Text(
                    'Biến động số dư',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 5)),
                  Text(
                    dto.transaction,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 25,
                      color: transactionColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  SizedBox(
                    width: 300,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text(
                            'Từ: ',
                            style: TextStyle(
                              fontSize: 15,
                              color: DefaultTheme.GREY_TEXT,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          child: Text(
                            address,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  SizedBox(
                    width: 300,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text(
                            'Tài khoản: ',
                            style: TextStyle(
                              fontSize: 15,
                              color: DefaultTheme.GREY_TEXT,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          child: Text(
                            dto.bankAccount,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  SizedBox(
                    width: 300,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text(
                            'Số dư: ',
                            style: TextStyle(
                              fontSize: 15,
                              color: DefaultTheme.GREY_TEXT,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          child: Text(
                            dto.accountBalance,
                            style: TextStyle(
                              color: transactionColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  SizedBox(
                    width: 300,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text(
                            'Nội dung: ',
                            style: TextStyle(
                              fontSize: 15,
                              color: DefaultTheme.GREY_TEXT,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          height: 140,
                          child: SingleChildScrollView(
                            controller: scrollContoller,
                            child: Text(
                              body,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        color: transactionColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: DefaultTheme.WHITE,
                        ),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  openRemoveBankCard({required BankAccountDTO bankAccountDTO}) {
    final BankCardBloc bankCardBloc =
        BlocProvider.of(NavigationService.navigatorKey.currentContext!);
    final BankCardPositionProvider bankCardPositionProvider =
        BankCardPositionProvider(false);
    final double width =
        MediaQuery.of(NavigationService.navigatorKey.currentContext!)
            .size
            .width;
    Future.delayed(const Duration(milliseconds: 200), () {
      bankCardPositionProvider.transform();
    });
    return showDialog(
      barrierDismissible: true,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Material(
          // color: Theme.of(context).cardColor.withOpacity(0.3),
          color: DefaultTheme.TRANSPARENT,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: ClipRRect(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ValueListenableBuilder(
                    valueListenable: bankCardPositionProvider,
                    builder: (_, provider, child) {
                      return AnimatedPositioned(
                        top: (provider == true) ? 200 : 100,
                        duration: const Duration(milliseconds: 200),
                        child: BankCardWidget(
                          dto: bankAccountDTO,
                          width: width - 40,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 50,
                    child: Container(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCircleButton(
                            context: context,
                            icon: Icons.delete_rounded,
                            color: DefaultTheme.RED_TEXT,
                            text: 'Huỷ liên kết',
                            function: () async {
                              String userId =
                                  UserInformationHelper.instance.getUserId();
                              BankAccountRemoveDTO dto = BankAccountRemoveDTO(
                                  bankId: bankAccountDTO.id,
                                  userId: userId,
                                  role: bankAccountDTO.role);
                              bankCardBloc.add(BankCardEventRemove(dto: dto));
                              bankCardPositionProvider.reset();
                              await Future.delayed(
                                  const Duration(milliseconds: 200), () {
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                          _buildCircleButton(
                            context: context,
                            icon: Icons.close_rounded,
                            color: DefaultTheme.GREY_TEXT,
                            text: 'Đóng',
                            function: () async {
                              bankCardPositionProvider.reset();
                              await Future.delayed(
                                  const Duration(milliseconds: 200), () {
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCircleButton(
      {required BuildContext context,
      required IconData icon,
      required Color color,
      required String text,
      required VoidCallback function}) {
    const double size = 50;
    return InkWell(
      onTap: function,
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(size / 2),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              color: DefaultTheme.WHITE,
            ),
          ),
        ],
      ),
    );
  }
}
