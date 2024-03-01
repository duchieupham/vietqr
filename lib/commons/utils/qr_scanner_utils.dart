import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/aid.dart';
import 'package:vierqr/commons/constants/vietqr/viet_qr_id.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/contact/save_contact_screen.dart';
import 'package:vierqr/features/scan_qr/views/dialog_scan_login.dart';
import 'package:vierqr/features/scan_qr/views/dialog_scan_type_bank.dart';
import 'package:vierqr/features/scan_qr/views/dialog_scan_type_id.dart';
import 'package:vierqr/features/scan_qr/views/dialog_scan_type_other.dart';
import 'package:vierqr/features/scan_qr/views/dialog_scan_type_url.dart';
import 'package:vierqr/features/scan_qr/views/dialog_scan_type_vcard.dart';
import 'package:vierqr/features/scan_qr/views/dialog_scan_wordpress.dart';
import 'package:vierqr/features/web_view/views/custom_inapp_webview.dart';
import 'package:vierqr/models/viet_qr_scanned_dto.dart';
import 'package:vierqr/services/aes_convert.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class QRScannerUtils {
  const QRScannerUtils._privateConstructor();

  static const QRScannerUtils _instance = QRScannerUtils._privateConstructor();

  static QRScannerUtils get instance => _instance;

  VietQRScannedDTO getBankAccountFromQR(String qr) {
    VietQRScannedDTO result = const VietQRScannedDTO(
      caiValue: '',
      bankAccount: '',
    );
    try {
      if (qr.isNotEmpty) {
        if (qr.contains(VietQRId.MERCHANT_ACCOUNT_INFORMATION_ID)) {
          String mechantAccountInformationLength = qr
              .split(VietQRId.MERCHANT_ACCOUNT_INFORMATION_ID)[1]
              .substring(0, 2);
          LOG.info(
              'mechantAccountInformationLength: $mechantAccountInformationLength');
          String mechantAccountInformationValue = '';
          //14
          int length =
              (int.tryParse(mechantAccountInformationLength) ?? 0) + 14;
          mechantAccountInformationValue = qr.substring(14, length);
          LOG.info(
              'mechantAccountInformationValue: $mechantAccountInformationValue');
          //cut NAPAIS_AID
          String information = '';
          if (mechantAccountInformationValue.isNotEmpty) {
            information =
                mechantAccountInformationValue.split(AID.AID_NAPAS)[1];
          }
          LOG.info('information: $information');
          //get CAI length
          if (information.contains(VietQRId.PAYLOAD_FORMAT_INDICATOR_ID)) {
            String caiLength = information.substring(6, 8);
            if (information.substring(6, 8).isNotEmpty) {
              // LOG.info('caiLength: $caiLength');
              String caiValue =
                  information.substring(8, int.parse(caiLength) + 8);
              String bankAccountInformation = information.split(caiValue)[1];
              // LOG.info(
              //     'Bank Account bankAccountInformation: $bankAccountInformation');
              String bankAccountLength = bankAccountInformation.substring(2, 4);
              String bankAccount = bankAccountInformation.substring(
                  4, int.parse(bankAccountLength) + 4);
              LOG.info('CAI value: $caiValue');
              LOG.info('Bank Account: $bankAccount');
              result = VietQRScannedDTO(
                  caiValue: caiValue, bankAccount: bankAccount);
            }
          }
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }

    return result;
  }

  Future<TypeQR> checkScan(String code) async {
    VietQRScannedDTO vietQRScannedDTO =
        QRScannerUtils.instance.getBankAccountFromQR(code);
    if (vietQRScannedDTO.caiValue.isNotEmpty &&
        vietQRScannedDTO.bankAccount.isNotEmpty) {
      return TypeQR.QR_BANK;
    } else if (code.contains('|')) {
      return TypeQR.QR_CMT;
    } else if (code.trim().contains('VQRID')) {
      return TypeQR.QR_ID;
    } else if (code.trim().contains('http') || code.trim().contains('https')) {
      return TypeQR.QR_LINK;
    } else if (code.trim().contains('VCARD')) {
      return TypeQR.QR_VCARD;
    } else if (code.toUpperCase().trim().contains('VHI') ||
        code.toUpperCase().trim().contains('TSE') ||
        code.toUpperCase().trim().contains('VTS')) {
      return TypeQR.QR_SALE;
    } else {
      if (code.trim().endsWith('=')) {
        String dec = AESConvert.decrypt(code);
        if (dec.contains(AESConvert.accessKeyLoginWeb)) {
          if (SharePrefUtils.getProfile().userId.isEmpty) {
            return TypeQR.NEGATIVE_TWO;
          }
          return TypeQR.LOGIN_WEB;
        } else if (dec.contains(AESConvert.accessKeyTokenPlugin)) {
          if (SharePrefUtils.getProfile().userId.isEmpty) {
            return TypeQR.NEGATIVE_TWO;
          }
          return TypeQR.TOKEN_PLUGIN;
        }
      }
    }
    return TypeQR.OTHER;
  }

  Future onScanNavi(
    Map<String, dynamic> data,
    BuildContext context, {
    GestureTapCallback? onCallBack,
    bool isShowIconFirst = true,
  }) async {
    final type = data['type'];
    final typeQR = data['typeQR'];
    final value = data['data'];
    final bankTypeDTO = data['bankTypeDTO'];
    if (type != null && type is TypeContact) {
      switch (type) {
        case TypeContact.Bank:
          DialogWidget.instance.showModelBottomSheet(
            context: context,
            padding: EdgeInsets.zero,
            bgrColor: AppColor.TRANSPARENT,
            widget: DialogScanBank(
              dto: value,
              bankTypeDTO: bankTypeDTO,
              isShowIconFirst: isShowIconFirst,
            ),
          );
          break;
        case TypeContact.VietQR_ID:
          await DialogWidget.instance.showModelBottomSheet(
            context: context,
            padding: EdgeInsets.zero,
            bgrColor: AppColor.TRANSPARENT,
            widget: DialogScanTypeID(
              dto: value,
              typeQR: type,
              isShowIconFirst: isShowIconFirst,
            ),
          );

          if (onCallBack != null) {
            onCallBack();
          }
          break;
        case TypeContact.VCard:
          final data = await DialogWidget.instance.showModelBottomSheet(
            context: context,
            padding: EdgeInsets.zero,
            bgrColor: AppColor.TRANSPARENT,
            widget: DialogScanTypeVCard(
              dto: value,
              typeQR: type,
              isShowIconFirst: isShowIconFirst,
            ),
          );

          if (data is bool) {
            Fluttertoast.showToast(
              msg: 'Lưu thành công',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
            );
          }
          break;
        case TypeContact.Login_Web:
          DialogWidget.instance.openDialogLoginWeb(
            child: DialogScanLogin(code: value),
          );
          break;
        case TypeContact.token_plugin:
          DialogWidget.instance.openDialogLoginWeb(
            child: DialogScanWordPress(code: value),
          );
          break;
        case TypeContact.Sale:
          NavigatorUtils.navigatePage(
            context,
            CustomInAppWebView(
              url: 'https://vietqr.vn/service/may-ban-hang/active?mid=$value',
              userId: SharePrefUtils.getProfile().userId,
            ),
            routeName: CustomInAppWebView.routeName,
          );
          break;
        case TypeContact.Other:
          if (typeQR == TypeQR.QR_LINK) {
            await DialogWidget.instance.showModelBottomSheet(
              context: context,
              padding: EdgeInsets.zero,
              bgrColor: AppColor.TRANSPARENT,
              widget: DialogScanURL(
                code: value ?? '',
                isShowIconFirst: isShowIconFirst,
                onTapSave: () async {
                  final data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SaveContactScreen(
                        code: value,
                        typeQR: type,
                      ),
                      // settings: RouteSettings(name: ContactEditView.routeName),
                    ),
                  );
                  if (data is bool) {
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                      msg: 'Lưu thành công',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Theme.of(context).cardColor,
                      textColor: Theme.of(context).hintColor,
                      fontSize: 15,
                    );
                  }
                },
              ),
            );
          } else {
            await DialogWidget.instance.showModelBottomSheet(
              context: context,
              padding: EdgeInsets.zero,
              bgrColor: AppColor.TRANSPARENT,
              widget: DialogScanOther(
                code: value ?? '',
                isShowIconFirst: isShowIconFirst,
                onTapSave: () async {
                  final data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SaveContactScreen(
                        code: value,
                        typeQR: type,
                      ),
                      // settings: RouteSettings(name: ContactEditView.routeName),
                    ),
                  );
                  if (data is bool) {
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                      msg: 'Lưu thành công',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Theme.of(context).cardColor,
                      textColor: Theme.of(context).hintColor,
                      fontSize: 15,
                    );
                  }
                },
              ),
            );
          }
          if (onCallBack != null) {
            onCallBack();
          }

          break;
        case TypeContact.ERROR:
          DialogWidget.instance.openMsgDialog(
            title: 'Không thể xác nhận mã QR',
            msg:
                'Không tìm thấy thông tin trong đoạn mã QR. Vui lòng kiểm tra lại thông tin.',
            function: () {
              Navigator.pop(context);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          );
          break;
        case TypeContact.NOT_FOUND:
          DialogWidget.instance.openMsgDialog(
            title: 'Không tìm thấy thông tin',
            msg:
                'Không tìm thấy thông tin ngân hàng tương ứng. Vui lòng thử lại sau.',
            function: () {
              Navigator.pop(context);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          );
          break;
        case TypeContact.NONE:
        case TypeContact.UPDATE:
          break;
      }
    }
  }
}
