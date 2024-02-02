import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/aes_convert.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class DialogScanLogin extends StatelessWidget {
  final String code;

  const DialogScanLogin({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
          color: AppColor.WHITE, borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Đăng nhập web',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Image.asset('assets/images/ic-login-web-popup.png'),
          const SizedBox(height: 24),
          Text(
            'Đăng nhập vào Web VietQR VN',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          MButtonWidget(
            title: 'Đăng nhập',
            isEnable: true,
            margin: EdgeInsets.symmetric(horizontal: 20),
            onTap: () => _onLoginWeb(context),
          ),
          MButtonWidget(
            title: 'Huỷ',
            isEnable: true,
            colorEnableText: AppColor.BLACK,
            colorEnableBgr: AppColor.greyF0F0F0,
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  _onLoginWeb(BuildContext context) async {
    String loginId = '';
    String randomKey = '';
    List<String> splits = AESConvert.splitsKey(code);
    if (splits.isNotEmpty) {
      loginId = splits.last;
      randomKey = splits.first;
    }

    final body = {
      'loginId': loginId,
      'userId': UserHelper.instance.getUserId(),
      'randomKey': randomKey,
    };
    try {
      final result = await _loginWeb(body);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: 'Đăng nhập thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).hintColor,
          fontSize: 15,
        );
      }
    } catch (e) {}
  }

  Future<ResponseMessageDTO> _loginWeb(body) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}accounts/push';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: body,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        result = const ResponseMessageDTO(status: 'SUCCESS', message: '');
        print(response.body);
        // var data = jsonDecode(response.body);
        // result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }
}
