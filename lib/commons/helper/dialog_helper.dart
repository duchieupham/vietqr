import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/layouts/image/x_image.dart';

import '../../features/dashboard/blocs/dashboard_bloc.dart';
import '../../features/dashboard/events/dashboard_event.dart';
import '../../features/home/widget/dialog_update.dart';

mixin DialogHelper {
  static final _allPopups = <Key, BuildContext>{};

  void dismissAllPopups() {
    for (final context in _allPopups.values) {
      Navigator.of(context).pop();
    }
    _allPopups.clear();
  }

  void dismissPopup({required Key key, bool willPop = true}) {
    final aContext = _allPopups[key];
    if (aContext != null) {
      _allPopups.remove(key);
      if (willPop) {
        Navigator.of(aContext).pop();
      }
    }
  }

  Key _keyForPopup() {
    return UniqueKey();
  }

  Future<void> showXDialog(
    BuildContext context, {
    String? title,
    Widget? content,
    Key? key,
    String? closeItemLabel,
    List<Widget>? actions,
    Function()? onDialogClosed,
    double? width,
    double? height,
    Widget? headerWidget,
    Widget? footerWidget,
    bool barrierDismissible = false,
    EdgeInsetsGeometry? padding,
  }) async {
    Key keyDialog = key ?? _keyForPopup();
    _allPopups[keyDialog] = context;
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            padding: padding,
            width: width,
            height: height,
            child: Column(),
          ),
        );
      },
    ).then((value) {
      if (onDialogClosed != null) {
        onDialogClosed();
      }
      dismissPopup(key: keyDialog, willPop: false);
    });
  }

  Future<void> showDialogUpdateApp(
    BuildContext context, {
    Key? key,
    Function()? onCheckUpdate,
    bool isHideClose = false,
  }) async {
    Key keyDialog = key ?? _keyForPopup();
    _allPopups[keyDialog] = context;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return DialogUpdateView(
          key: keyDialog,
          isHideClose: isHideClose,
          onCheckUpdate: () {
            if (onCheckUpdate != null) {
              onCheckUpdate();
            } else {
              getIt
                  .get<DashBoardBloc>()
                  .add(GetVersionAppEventDashboard(isCheckVer: true));
            }
          },
        );
      },
    ).then((value) {
      dismissPopup(key: keyDialog, willPop: false);
    });
  }

  Future<void> showDialogActiveKey(
    BuildContext context, {
    Key? key,
    required String bankId,
    required String bankCode,
    required String bankName,
    required String bankAccount,
    required String userBankName,
  }) async {
    Key keyDialog = key ?? _keyForPopup();
    _allPopups[keyDialog] = context;
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        key: keyDialog,
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 30),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        height: MediaQuery.of(context).size.height * 0.38,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Text(
                    "Thanh toán phí \ndịch vụ phần mềm VietQR",
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, Routes.MAINTAIN_CHARGE_SCREEN,
                        arguments: {
                          'activeKey': '',
                          'type': 0,
                          'bankId': bankId,
                          'bankCode': bankCode,
                          'bankName': bankName,
                          'bankAccount': bankAccount,
                          'userBankName': userBankName,
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          width: 0.5, color: Colors.black.withOpacity(0.5)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              child: Text("Kích hoạt bằng mã"),
                            ),
                            SizedBox(height: 3),
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                              child: Text(
                                  "Sử dụng mã để kích hoạt \ndịch vụ nhận biến động số dư."),
                            )
                          ],
                        ),
                        XImage(
                          imagePath: AppImages.icPassUnlock,
                          height: 60,
                          width: 60,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, Routes.MAINTAIN_CHARGE_SCREEN,
                        arguments: {
                          'activeKey': '',
                          'type': 1,
                          'bankId': bankId,
                          'bankCode': bankCode,
                          'bankName': bankName,
                          'bankAccount': bankAccount,
                          'userBankName': userBankName,
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          width: 0.5, color: Colors.black.withOpacity(0.5)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              child: Text("Quét mã VietQR"),
                            ),
                            SizedBox(height: 3),
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                              child: Text(
                                  "Quét mã VietQR để thanh toán \nphí dịch vụ."),
                            )
                          ],
                        ),
                        Image.asset(
                          AppImages.icVietQrSemiSmall,
                          height: 60,
                          width: 60,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    ).then(
      (value) => dismissPopup(key: keyDialog, willPop: false),
    );
  }
}
