import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/numeral.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/sms_information_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/pin_widget.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_information_dto.dart';
import 'package:vierqr/services/providers/maintain_charge_provider.dart';
import 'package:vierqr/services/providers/pin_provider.dart';

import 'error_widget.dart';

class DialogWidget {
  //
  const DialogWidget._privateConstructor();

  static const DialogWidget _instance = DialogWidget._privateConstructor();

  static DialogWidget get instance => _instance;

  static bool isPopLoading = false;

  openActiveAnnualSuccess() {
    return showCupertinoModalPopup(
      // barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (context) {
        return Material(
          color: AppColor.TRANSPARENT,
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 30),
            padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
            height: MediaQuery.of(context).size.height * 0.55,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset(
                      AppImages.icSuccessInBlue,
                      height: 200,
                      fit: BoxFit.fitHeight,
                    ),
                    Text(
                      "Kích hoạt dịch vụ \nphần mềm VietQR thành công!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColor.BLUE_TEXT,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        "Hoàn thành",
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  openConfirmPassDialog(
      {required String title,
      required Function(String) onDone,
      required Function() onClose,
      required TextEditingController editingController}) {
    final FocusNode focusNode = FocusNode();
    focusNode.requestFocus();
    return showDialog(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (context) {
        return Material(
          color: AppColor.TRANSPARENT,
          child: Center(
            child: AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 100),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.25,
                // alignment: Alignment.center,
                child: ErrorDialogWidget(
                    title: title,
                    editingController: editingController,
                    focusNode: focusNode,
                    onDone: onDone,
                    onClose: onClose,
                    text: "Mật khẩu không khớp. Vui lòng thử lại."),
              ),
            ),
          ),
        );
      },
    );
  }

  openPINDialog({required String title, required Function(String) onDone}) {
    final FocusNode focusNode = FocusNode();
    focusNode.requestFocus();
    return showDialog(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Material(
          color: AppColor.TRANSPARENT,
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
                          textColor: AppColor.WHITE,
                          bgColor: AppColor.BLUE_TEXT,
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
                                color: AppColor.RED_TEXT,
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
        barrierColor: AppColor.TRANSPARENT,
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
            color: AppColor.TRANSPARENT,
            child: Center(
              child: Container(
                width: 300,
                height: 350,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
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
                    // const Padding(padding: EdgeInsets.only(top: 30)),
                    const Spacer(),
                    ButtonWidget(
                      width: 250,
                      height: 40,
                      text: confirmText,
                      textColor: AppColor.WHITE,
                      bgColor: (confirmColor != null)
                          ? confirmColor
                          : AppColor.BLUE_TEXT,
                      borderRadius: 5,
                      function: confirmFunction,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    ButtonWidget(
                      width: 250,
                      height: 40,
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
    BuildContext context = NavigationService.navigatorKey.currentContext!;
    final double width = MediaQuery.of(context).size.width;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Material(
            color: AppColor.TRANSPARENT,
            child: Center(
              child: Container(
                width: width,
                height: 400,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: child,
              ),
            ),
          );
        });
  }

  Future showFullModalBottomContent({
    BuildContext? context,
    required Widget widget,
    bool? isDissmiss,
    Color? color,
  }) async {
    context ??= NavigationService.navigatorKey.currentContext!;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return await showModalBottomSheet(
        isDismissible: (isDissmiss != null && !isDissmiss) ? isDissmiss : true,
        isScrollControlled: true,
        enableDrag: false,
        // Ngăn người dùng kéo ModalBottomSheet
        context: context,
        backgroundColor: (color != null) ? color : AppColor.TRANSPARENT,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              if (isDissmiss == null || isDissmiss) {
                Navigator.pop(context);
              }
              return false;
            },
            child: Container(
              width: width,
              height: height,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: (color != null) ? color : Theme.of(context).cardColor,
              ),
              child: widget,
            ),
          );
        });
  }

  Future showModalBottomContent({
    BuildContext? context,
    required Widget widget,
    required double height,
    double radius = 15,
    EdgeInsetsGeometry? padding,
    bool isDismissible = true,
  }) async {
    context ??= NavigationService.navigatorKey.currentContext!;
    return await showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: isDismissible,
        enableDrag: false,
        context: context,
        backgroundColor: AppColor.TRANSPARENT,
        builder: (_) {
          final keyboardHeight = MediaQuery.of(context!).viewInsets.bottom;
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: ClipRRect(
              child: Container(
                padding: padding ??
                    EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                      bottom: keyboardHeight,
                    ),
                width: MediaQuery.of(context).size.width - 10,
                height: height + keyboardHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  color: Theme.of(context).cardColor,
                ),
                child: widget,
              ),
            ),
          );
        });
  }

  Future showModelBottomSheet({
    BuildContext? context,
    required Widget widget,
    double? height,
    double radius = 15,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadiusGeometry? borderRadius,
    Color? bgrColor,
    bool isDismissible = true,
    double sigmaX = 5.0,
    double sigmaY = 5.0,
  }) async {
    context ??= NavigationService.navigatorKey.currentContext!;
    return showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: isDismissible,
      useRootNavigator: true,
      context: context,
      backgroundColor: AppColor.TRANSPARENT,
      builder: (context) {
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: ClipRRect(
            child: Container(
              margin: margin ?? const EdgeInsets.only(top: kToolbarHeight),
              padding: padding ??
                  EdgeInsets.only(left: 20, right: 20, bottom: keyboardHeight),
              width: MediaQuery.of(context).size.width - 10,
              height: height != null ? (height + keyboardHeight) : null,
              decoration: BoxDecoration(
                borderRadius: borderRadius ??
                    BorderRadius.vertical(top: Radius.circular(radius)),
                color: bgrColor ?? Theme.of(context).cardColor,
              ),
              child: widget,
            ),
          ),
        );
      },
    );
  }

  Future openDateTimePickerDialog(
      String title, Function(DateTime) onChanged) async {
    double width = MediaQuery.of(NavigationService.navigatorKey.currentContext!)
        .size
        .width;
    return await showModalBottomSheet(
        isScrollControlled: true,
        context: NavigationService.navigatorKey.currentContext!,
        backgroundColor: AppColor.TRANSPARENT,
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
                          textColor: AppColor.WHITE,
                          bgColor: AppColor.BLUE_TEXT,
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

  void openLoadingDialog({String msg = ''}) async {
    if (!isPopLoading) {
      isPopLoading = true;
      return await showDialog(
          barrierDismissible: false,
          context: NavigationService.navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return Material(
              color: AppColor.TRANSPARENT,
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
                              color: AppColor.BLUE_TEXT,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: AppColor.BLUE_TEXT,
                            ),
                            if (msg.isNotEmpty) ...[
                              Padding(padding: EdgeInsets.only(top: 30)),
                              Text(
                                msg,
                                textAlign: TextAlign.center,
                              ),
                            ]
                          ],
                        ),
                      ),
              ),
            );
          }).then((value) => isPopLoading = false);
    }
  }

  openMsgDialog({
    required String title,
    String? buttonExit,
    String? buttonConfirm,
    required String msg,
    VoidCallback? function,
    VoidCallback? functionConfirm,
    bool isSecondBT = false,
    bool showImageWarning = true,
    double width = 300,
    double height = 300,
  }) {
    return showDialog(
        barrierDismissible: false,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: AppColor.TRANSPARENT,
            child: Center(
              child: Container(
                width: width,
                height: height,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (showImageWarning)
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
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ButtonWidget(
                              height: 40,
                              text: buttonExit ?? 'Đóng',
                              textColor:
                                  isSecondBT ? AppColor.BLACK : AppColor.WHITE,
                              bgColor: isSecondBT
                                  ? AppColor.GREY_EBEBEB
                                  : AppColor.BLUE_TEXT,
                              borderRadius: 5,
                              function: (function != null)
                                  ? function
                                  : () {
                                      Navigator.pop(context);
                                    },
                            ),
                          ),
                          if (isSecondBT) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              child: ButtonWidget(
                                height: 40,
                                text: buttonConfirm ?? 'Xác nhận',
                                textColor: AppColor.WHITE,
                                bgColor: AppColor.BLUE_TEXT,
                                borderRadius: 5,
                                function: functionConfirm!,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // const Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                ),
              ),
              // : Container(
              //     width: 300,
              //     height: 250,
              //     alignment: Alignment.center,
              //     padding: const EdgeInsets.symmetric(horizontal: 40),
              //     decoration: BoxDecoration(
              //       color: Theme.of(context).cardColor,
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         const Spacer(),
              //         Text(
              //           msg,
              //           textAlign: TextAlign.center,
              //           style: const TextStyle(
              //             fontSize: 16,
              //           ),
              //         ),
              //         const Spacer(),
              //         ButtonWidget(
              //           width: 230,
              //           text: 'OK',
              //           textColor: DefaultTheme.WHITE,
              //           bgColor: DefaultTheme.GREEN,
              //           function: (function != null)
              //               ? function
              //               : () {
              //                   Navigator.pop(context);
              //                 },
              //         ),
              //         const Padding(padding: EdgeInsets.only(bottom: 20)),
              //       ],
              //     ),
              //   ),
            ),
          );
        });
  }

  openMsgSuccessDialog({
    required String title,
    String? buttonExit,
    String? buttonConfirm,
    required String msg,
    VoidCallback? function,
    VoidCallback? functionConfirm,
    bool isSecondBT = false,
    bool showImageWarning = true,
    double width = 300,
    double height = 340,
  }) {
    return showDialog(
        barrierDismissible: false,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: AppColor.TRANSPARENT,
            child: Center(
              child: Container(
                width: width,
                height: height,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (showImageWarning)
                      Image.asset(
                        'assets/images/ic-success.png',
                        width: 120,
                        height: 120,
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
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ButtonWidget(
                              height: 40,
                              text: buttonExit ?? 'OK',
                              textColor:
                                  isSecondBT ? AppColor.BLACK : AppColor.WHITE,
                              bgColor: isSecondBT
                                  ? AppColor.GREY_EBEBEB
                                  : AppColor.BLUE_TEXT,
                              borderRadius: 5,
                              function: (function != null)
                                  ? function
                                  : () {
                                      Navigator.pop(context);
                                    },
                            ),
                          ),
                          if (isSecondBT) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              child: ButtonWidget(
                                height: 40,
                                text: buttonConfirm ?? 'Xác nhận',
                                textColor: AppColor.WHITE,
                                bgColor: AppColor.BLUE_TEXT,
                                borderRadius: 5,
                                function: functionConfirm!,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // const Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                ),
              ),
              // : Container(
              //     width: 300,
              //     height: 250,
              //     alignment: Alignment.center,
              //     padding: const EdgeInsets.symmetric(horizontal: 40),
              //     decoration: BoxDecoration(
              //       color: Theme.of(context).cardColor,
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         const Spacer(),
              //         Text(
              //           msg,
              //           textAlign: TextAlign.center,
              //           style: const TextStyle(
              //             fontSize: 16,
              //           ),
              //         ),
              //         const Spacer(),
              //         ButtonWidget(
              //           width: 230,
              //           text: 'OK',
              //           textColor: DefaultTheme.WHITE,
              //           bgColor: DefaultTheme.GREEN,
              //           function: (function != null)
              //               ? function
              //               : () {
              //                   Navigator.pop(context);
              //                 },
              //         ),
              //         const Padding(padding: EdgeInsets.only(bottom: 20)),
              //       ],
              //     ),
              //   ),
            ),
          );
        });
  }

  openCustomMsgDialog({
    required String title,
    String? buttonExit,
    String? buttonConfirm,
    required String msg,
    VoidCallback? function,
    VoidCallback? functionConfirm,
    bool isSecondBT = false,
    bool showImageWarning = true,
    double width = 300,
    double height = 300,
    String? url,
    Widget? buttonColumn,
  }) {
    return showDialog(
        barrierDismissible: false,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: AppColor.TRANSPARENT,
            child: Center(
              child: Container(
                width: width,
                height: height,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showImageWarning)
                      url == null
                          ? Image.asset(
                              'assets/images/ic-warning.png',
                              width: 130,
                              height: 130,
                            )
                          : Expanded(
                              child: Image.asset(
                                url,
                                width: 130,
                                height: 130,
                              ),
                            ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    title.isNotEmpty
                        ? Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const SizedBox(),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    if (msg.isNotEmpty)
                      SizedBox(
                        width: 250,
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
                    if (buttonColumn == null) const Spacer(),
                    buttonColumn != null
                        ? buttonColumn
                        : Container(
                            margin: const EdgeInsets.only(
                                left: 12, right: 12, top: 30, bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ButtonWidget(
                                    height: 40,
                                    text: buttonExit ?? 'Đóng',
                                    textColor: isSecondBT
                                        ? AppColor.BLACK
                                        : AppColor.WHITE,
                                    bgColor: isSecondBT
                                        ? AppColor.GREY_EBEBEB
                                        : AppColor.BLUE_TEXT,
                                    borderRadius: 5,
                                    function: (function != null)
                                        ? function
                                        : () {
                                            Navigator.pop(context);
                                          },
                                  ),
                                ),
                                if (isSecondBT) ...[
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ButtonWidget(
                                      height: 40,
                                      text: buttonConfirm ?? 'Xác nhận',
                                      textColor: AppColor.WHITE,
                                      bgColor: AppColor.BLUE_TEXT,
                                      borderRadius: 5,
                                      function: functionConfirm!,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                    // const Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                ),
              ),
              // : Container(
              //     width: 300,
              //     height: 250,
              //     alignment: Alignment.center,
              //     padding: const EdgeInsets.symmetric(horizontal: 40),
              //     decoration: BoxDecoration(
              //       color: Theme.of(context).cardColor,
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         const Spacer(),
              //         Text(
              //           msg,
              //           textAlign: TextAlign.center,
              //           style: const TextStyle(
              //             fontSize: 16,
              //           ),
              //         ),
              //         const Spacer(),
              //         ButtonWidget(
              //           width: 230,
              //           text: 'OK',
              //           textColor: DefaultTheme.WHITE,
              //           bgColor: DefaultTheme.GREEN,
              //           function: (function != null)
              //               ? function
              //               : () {
              //                   Navigator.pop(context);
              //                 },
              //         ),
              //         const Padding(padding: EdgeInsets.only(bottom: 20)),
              //       ],
              //     ),
              //   ),
            ),
          );
        });
  }

  openWidgetDialog(
      {required Widget child,
      double? heightPopup,
      EdgeInsets? margin,
      EdgeInsets? padding,
      double? widthPopup,
      double radius = 15}) {
    final BuildContext context = NavigationService.navigatorKey.currentContext!;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: AppColor.TRANSPARENT,
          child: Center(
            child: UnconstrainedBox(
              child: Container(
                width: widthPopup ?? width - 40,
                height: heightPopup ?? height * 0.8,
                alignment: Alignment.center,
                padding: padding ??
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                margin: margin,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  openTransactionDialog(String address, String body) {
    final ScrollController scrollController = ScrollController();
    return showDialog(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Material(
          color: AppColor.TRANSPARENT,
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
                              color: AppColor.GREY_TEXT,
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
                              color: AppColor.GREY_TEXT,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          height: 250,
                          child: SingleChildScrollView(
                            controller: scrollController,
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
                        color: AppColor.BLUE_TEXT,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: AppColor.WHITE,
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
            ? AppColor.BLUE_TEXT
            : AppColor.RED_TEXT;
    return showDialog(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Material(
          color: AppColor.TRANSPARENT,
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
                              color: AppColor.GREY_TEXT,
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
                              color: AppColor.GREY_TEXT,
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
                              color: AppColor.GREY_TEXT,
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
                              color: AppColor.GREY_TEXT,
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
                          color: AppColor.WHITE,
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

  Future<dynamic> openDialogIntroduce(
      {required Widget child, BuildContext? ctx}) async {
    return await showDialog(
      barrierDismissible: false,
      context: ctx ?? NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Material(
          color: AppColor.TRANSPARENT,
          child: Center(child: child),
        );
      },
    );
  }

  Future<dynamic> openDialogLoginWeb({required Widget child}) async {
    return await showDialog(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Material(
          color: AppColor.TRANSPARENT,
          child: Center(child: child),
        );
      },
    );
  }
}
