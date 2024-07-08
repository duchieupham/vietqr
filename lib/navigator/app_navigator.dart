import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/bank_card/views/search_bank_view.dart';
import 'package:vierqr/features/connect_media/connect_media_screen.dart';
import 'package:vierqr/features/connect_lark_old/connect_lark_screen.dart';
import 'package:vierqr/features/connect_lark_old/widget/connect_screen.dart';
import 'package:vierqr/features/connect_media/views/update_sharing_info_screen.dart';
import 'package:vierqr/features/connect_media/views/update_url_screen.dart';
import 'package:vierqr/features/connect_telegram_old/connect_telegram_screen.dart';
import 'package:vierqr/features/connect_telegram_old/widget/connect_screen.dart';
import 'package:vierqr/features/contact/contact_screen.dart';
import 'package:vierqr/features/create_qr_un_authen/show_qr.dart';
import 'package:vierqr/features/customer_va/views/customer_va_confirm_otp_view.dart';
import 'package:vierqr/features/customer_va/views/customer_va_insert_bank_auth_view.dart';
import 'package:vierqr/features/customer_va/views/customer_va_insert_bank_info_view.dart';
import 'package:vierqr/features/customer_va/views/customer_va_insert_merchant_view.dart';
import 'package:vierqr/features/customer_va/views/customer_va_list_view.dart';
import 'package:vierqr/features/customer_va/views/customer_va_splash_view.dart';
import 'package:vierqr/features/customer_va/views/customer_va_success_view.dart';
import 'package:vierqr/features/dashboard/dashboard_screen.dart';
import 'package:vierqr/features/generate_qr/views/qr_share_view.dart';
import 'package:vierqr/features/introduce/views/introduce_screen.dart';
import 'package:vierqr/features/invoice/invoice_screen.dart';
import 'package:vierqr/features/invoice/widgets/invoice_detail_screen.dart';
import 'package:vierqr/features/login/login_screen.dart';
import 'package:vierqr/features/maintain_charge/maintain_charge_screen.dart';
import 'package:vierqr/features/maintain_charge/views/active_success_screen.dart';
import 'package:vierqr/features/maintain_charge/views/annual_fee_screen.dart';
import 'package:vierqr/features/maintain_charge/views/confirm_active_key_screen.dart';
import 'package:vierqr/features/maintain_charge/views/dynamic_active_key_screen.dart';
import 'package:vierqr/features/mobile_recharge/mobile_recharge_screen.dart';
import 'package:vierqr/features/mobile_recharge/qr_mobile_recharge.dart';
import 'package:vierqr/features/mobile_recharge/widget/recharege_success.dart';
import 'package:vierqr/features/personal/views/national_information_view.dart';
import 'package:vierqr/features/personal/views/user_edit_view.dart';
import 'package:vierqr/features/personal/views/user_update_password_view.dart';
import 'package:vierqr/features/qr_box/qr_box_screen.dart';
import 'package:vierqr/features/qr_feed/views/create_folder_screen.dart';
import 'package:vierqr/features/qr_feed/views/folder_detail_screen.dart';
import 'package:vierqr/features/qr_feed/views/qr_create_screen.dart';
import 'package:vierqr/features/qr_feed/views/qr_detail_screen.dart';
import 'package:vierqr/features/qr_feed/views/qr_folder_screen.dart';
import 'package:vierqr/features/qr_feed/views/qr_style.dart';
import 'package:vierqr/features/qr_feed/views/qr_update_screen.dart';
import 'package:vierqr/features/register_new_bank/register_mb_bank.dart';
import 'package:vierqr/features/report/report_screen.dart';
import 'package:vierqr/features/scan_qr/scan_qr_screen.dart';
import 'package:vierqr/features/top_up/qr_top_up.dart';
import 'package:vierqr/features/top_up/top_up_screen.dart';
import 'package:vierqr/features/transaction_wallet/trans_wallet_screen.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/maintain_charge_create.dart';
import 'package:vierqr/models/maintain_charge_dto.dart';
import 'package:vierqr/models/qr_create_type_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/respone_top_up_dto.dart';
import 'package:vierqr/splash_screen.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic>? onIniRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.SPLASH:
        return _buildRoute(settings, const SplashScreen());
      case Routes.APP:
        return _buildRoute(settings, const VietQRApp());
      case Routes.LOGIN:
        return _buildRoute(settings, const LoginScreen());
      case Routes.DASHBOARD:
        return _buildRoute(settings, const DashBoardScreen());
      case Routes.USER_EDIT:
        return _buildRoute(settings, const UserEditView());
      case Routes.UPDATE_PASSWORD:
        return _buildRoute(settings, const UserUpdatePassword());
      case Routes.ADD_BANK_CARD:
        return _buildRoute(settings, const AddBankScreen());
      case Routes.QR_SHARE_VIEW:
        return _buildRoute(settings, const QRShareView());
      case Routes.SCAN_QR_VIEW:
        return _buildRoute(settings, const ScanQrScreen());
      case Routes.SEARCH_BANK:
        return _buildRoute(settings, const SearchBankView());
      case Routes.NATIONAL_INFORMATION:
        return _buildRoute(settings, const NationalInformationView());
      case Routes.INTRODUCE_SCREEN:
        return _buildRoute(settings, const IntroduceScreen());
      case Routes.PHONE_BOOK:
        return _buildRoute(settings, const ContactScreen());
      case Routes.TOP_UP:
        return _buildRoute(settings, const TopUpScreen());
      case Routes.MOBILE_RECHARGE:
        return _buildRoute(settings, MobileRechargeScreen());
      case Routes.REGISTER_NEW_BANK:
        return _buildRoute(settings, const RegisterNewBank());
      case Routes.CONNECT_TELEGRAM:
        return _buildRoute(settings, const ConnectTelegramScreen());
      case Routes.CONNECT_STEP_TELE_SCREEN:
        return _buildRoute(settings, const ConnectTeleStepScreen());
      case Routes.CONNECT_STEP_LARK_SCREEN:
        return _buildRoute(settings, ConnectLarkStepScreen());
      case Routes.CONNECT_LARK:
        return _buildRoute(settings, const ConnectLarkScreen());
      case Routes.REPORT_SCREEN:
        return _buildRoute(settings, const ReportScreen());
      case Routes.TRANSACTION_WALLET:
        return _buildRoute(settings, const TransWalletScreen());
      case Routes.INVOICE_SCREEN:
        return _buildRoute(settings, const InvoiceScreen());
      case Routes.INSERT_CUSTOMER_VA_MERCHANT:
        return _buildRoute(settings, const CustomerVAInsertMerchantView());
      case Routes.INSERT_CUSTOMER_VA_BANK_INFO:
        return _buildRoute(settings, const CustomerVaInsertBankInfoView());
      case Routes.INSERT_CUSTOMER_VA_BANK_AUTH:
        return _buildRoute(settings, const CustomerVaInsertBankAuthView());
      case Routes.CUSTOMER_VA_CONFIRM_OTP:
        return _buildRoute(settings, const CustomerVaConfirmOtpView());
      case Routes.CUSTOMER_VA_SUCCESS:
        return _buildRoute(settings, const CustomerVaSuccessView());
      case Routes.CUSTOMER_VA_SPLASH:
        return _buildRoute(settings, const CustomerVaSplashView());
      case Routes.CUSTOMER_VA_LIST:
        return _buildRoute(settings, const CustomerVaListView());
      case Routes.QR_UPDATE_SCREEN:
        return _buildRoute(settings, const QrUpdateScreen());
      case Routes.QR_CREATE_SCREEN:
        return CupertinoPageRoute(
            builder: (context) => const QrCreateScreen(), settings: settings);
      case Routes.QR_FOLDER_SCREEN:
        return CupertinoPageRoute(
            builder: (context) => const QrFolderScreen(), settings: settings);
      case Routes.CREATE_QR_FOLDER_SCREEN:
        Map map = settings.arguments as Map;
        ActionType action = map['action'];

        int page = map['page'];
        return CupertinoPageRoute(
            builder: (context) => CreateFolderScreen(
                  action: action,
                  pageView: page,
                ),
            settings: settings);
      // case Routes.QR_STYLE:
      //   return CupertinoPageRoute(
      //       builder: (context) => const QrStyle(), settings: settings);
      // case Routes.QR_SCREEN:
      //   return CupertinoPageRoute(
      //       builder: (context) => const QrCreateScreen(), settings: settings);
      case Routes.UPDATE_MEDIA_URL:
        Map map = settings.arguments as Map;
        TypeConnect type = map['type'];
        String id = map['id'];
        return _buildRoute(
            settings,
            UpdateUrlScreen(
              id: id,
              type: type,
            ));
      case Routes.UPDATE_SHARE_INFO_MEDIA:
        Map map = settings.arguments as Map;
        List<String> notificationTypes = map['notificationTypes'];
        List<String> notificationContents = map['notificationContents'];
        TypeConnect type = map['type'];
        String id = map['id'];
        return _buildRoute(
            settings,
            UpdateSharingInfoScreen(
              id: id,
              notificationTypes: notificationTypes,
              notificationContents: notificationContents,
              type: type,
            ));
      case Routes.QR_FOLDER_DETAIL_SCREEN:
        Map map = settings.arguments as Map;
        String id = map['id'];
        String folderName = map['folderName'];

        return _buildRoute(
            settings,
            FolderDetailScreen(
              folderId: id,
              folderName: folderName,
            ));
      case Routes.QR_DETAIL_SCREEN:
        Map map = settings.arguments as Map;
        // String qrType = map['qrType'];
        String id = map['id'];
        return _buildRoute(
            settings,
            QrDetailScreen(
              id: id,
              // qrType: qrType,
            ));
      case Routes.QR_STYLE:
        Map map = settings.arguments as Map;

        QrCreateFeedDTO dto = map['dto'];
        int type = map['type'];

        return _buildRoute(
            settings,
            QrStyle(
              type: type,
              dto: dto,
            ));
      case Routes.DYNAMIC_ACTIVE_KEY_SCREEN:
        Map<String, dynamic> param = settings.arguments as Map<String, dynamic>;
        String activeKey = param['activeKey'] as String;
        return _buildRoute(
            settings, DynamicActiveKeyScreen(activeKey: activeKey));
      case Routes.QR_BOX:
        Map<String, dynamic> param;
        String cert = '';
        if (settings.arguments != null) {
          param = settings.arguments as Map<String, dynamic>;
          cert = param['cert'] as String;
        }
        return _buildRoute(settings, QRBoxScreen(cert: cert));
      case Routes.CONNECT_GG_CHAT_SCREEN:
        return _buildRoute(
            settings, const ConnectMediaScreen(type: TypeConnect.GG_CHAT));
      case Routes.CONNECT_LARK_SCREEN:
        return _buildRoute(
            settings,
            const ConnectMediaScreen(
              type: TypeConnect.LARK,
            ));
      case Routes.CONNECT_TELE_SCREEN:
        return _buildRoute(
            settings, const ConnectMediaScreen(type: TypeConnect.TELE));
      case Routes.SHOW_QR:
        Map map = settings.arguments as Map;

        QRGeneratedDTO dto = map['dto'];
        AppInfoDTO appInfoDTO = map['appInfo'];

        return _buildRoute(
            settings,
            ShowQr(
              dto: dto,
              appInfo: appInfoDTO,
            ));
      case Routes.MAINTAIN_CHARGE_SCREEN:
        Map<String, dynamic> param = settings.arguments as Map<String, dynamic>;
        int type = param['type'] as int;
        String bankId = param['bankId'] as String;
        String activeKey = param['activeKey'] as String;

        String bankCode = param['bankCode'] as String;
        String bankName = param['bankName'] as String;
        String bankAccount = param['bankAccount'] as String;
        String userBankName = param['userBankName'] as String;

        return _buildRoute(
            settings,
            MaintainChargeScreen(
              activeKey: activeKey,
              type: type,
              bankId: bankId,
              bankCode: bankCode,
              bankName: bankName,
              bankAccount: bankAccount,
              userBankName: userBankName,
            ));
      case Routes.ANNUAL_FEE_SCREEN:
        Map<String, dynamic> param = settings.arguments as Map<String, dynamic>;
        int amount = param['amount'] as int;
        int validFrom = param['validFrom'] as int;
        int validTo = param['validTo'] as int;
        int duration = param['duration'] as int;

        String qr = param['qr'] as String;
        String billNumber = param['billNumber'] as String;
        String bankCode = param['bankCode'] as String;
        String bankName = param['bankName'] as String;
        String bankAccount = param['bankAccount'] as String;
        String userBankName = param['userBankName'] as String;

        return _buildRoute(
            settings,
            QrAnnualFeeScreen(
              bankAccount: bankAccount,
              userBankName: userBankName,
              duration: duration,
              qr: qr,
              billNumber: billNumber,
              amount: amount,
              validFrom: validFrom,
              validTo: validTo,
              bankName: bankName,
              bankCode: bankCode,
            ));
      case Routes.ACTIVE_SUCCESS_SCREEN:
        Map<String, dynamic> param = settings.arguments as Map<String, dynamic>;
        int type = param['type'] as int;

        return _buildRoute(settings, ActiveSuccessScreen(type: type));
      case Routes.CONFIRM_ACTIVE_KEY_SCREEN:
        Map<String, dynamic> param = settings.arguments as Map<String, dynamic>;
        MaintainChargeDTO dto = param['dto'] as MaintainChargeDTO;
        MaintainChargeCreate createDto =
            param['createDto'] as MaintainChargeCreate;

        return _buildRoute(
            settings,
            ConfirmActiveKeyScreen(
              createDto: createDto,
              dto: dto,
            ));
      case Routes.QR_TOP_UP:
        Map<String, dynamic> param = settings.arguments as Map<String, dynamic>;
        ResponseTopUpDTO dto = param['dto'] as ResponseTopUpDTO;
        String phoneNo = param['phoneNo'] as String;

        return _buildRoute(
            settings,
            QRTopUpScreen(
              dto: dto,
              phoneNo: phoneNo,
            ));
      case Routes.QR_MOBILE_CHARGE:
        Map<String, dynamic> param = settings.arguments as Map<String, dynamic>;
        ResponseTopUpDTO dto = param['dto'] as ResponseTopUpDTO;
        String phoneNo = param['phoneNo'] as String;
        String nwProviders = param['nwProviders'] as String;

        return _buildRoute(
            settings,
            QRMobileRechargeScreen(
              dto: dto,
              phoneNo: phoneNo,
              nwProviders: nwProviders,
            ));
      case Routes.RECHARGE_SUCCESS:
        Map<String, dynamic> data = settings.arguments as Map<String, dynamic>;

        return _buildRoute(
            settings,
            RechargeSuccess(
              phoneNo: data['phoneNo'],
              money: data['money'],
            ));
      case Routes.INVOICE_DETAIL:
        Map map = settings.arguments as Map;

        String id = map['id'];

        return _buildRoute(
            settings,
            InvoiceDetailScreen(
              invoiceId: id,
            ));
      // case Routes.asd:
      //   return _buildRoute(settings, const ());
      default:
        return null;
    }
  }

  static _buildRoute(
    RouteSettings routeSettings,
    Widget builder,
  ) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(
        builder: (context) => builder,
        settings: routeSettings,
      );
    }
    return MaterialPageRoute(
      builder: (context) => builder,
      settings: routeSettings,
    );
  }

  static Future push<T>(
    String route, {
    Object? arguments,
  }) {
    return state.pushNamed(route, arguments: arguments);
  }

  static Future pushAndRemoveUntil<T>(
    String route, {
    Object? arguments,
  }) {
    return state.pushNamedAndRemoveUntil(
      route,
      (route) => false,
      arguments: arguments,
    );
  }

  static Future replaceWith<T>(
    String route, {
    Map<String, dynamic>? arguments,
  }) {
    return state.pushReplacementNamed(route, arguments: arguments);
  }

  static void popUntil<T>(String route) {
    state.popUntil(ModalRoute.withName(route));
  }

  static Future popAndPush<T>(
    String route, {
    Object? arguments,
  }) {
    return state.popAndPushNamed(route, arguments: arguments);
  }

  static void pop([Object? arguments]) {
    if (canPop) {
      state.pop(arguments);
    }
  }

  static bool get canPop => state.canPop();

  static BuildContext? get context => navigatorKey.currentContext;

  static NavigatorState get state => navigatorKey.currentState!;
}
