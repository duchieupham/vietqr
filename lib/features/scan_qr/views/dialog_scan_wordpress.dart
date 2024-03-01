import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/aes_convert.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class DialogScanWordPress extends StatefulWidget {
  final String code;

  const DialogScanWordPress({super.key, required this.code});

  @override
  State<DialogScanWordPress> createState() => _DialogScanWordPressState();
}

class _DialogScanWordPressState extends State<DialogScanWordPress> {
  final urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
          color: AppColor.WHITE, borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Get Key',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: AppColor.GREY_EBEBEB,
                borderRadius: BorderRadius.circular(4)),
            child: Row(
              children: [
                Text('Số điện thoại: ', style: TextStyle(fontSize: 14)),
                Text('${SharePrefUtils.getPhone()}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  color: errorText.isNotEmpty
                      ? AppColor.error700
                      : AppColor.grey979797),
            ),
            child: TextFieldCustom(
              isObscureText: false,
              maxLines: 1,
              textFieldType: TextfieldType.DEFAULT,
              title: 'Số tài khoản',
              hintText: 'URL*: Nhập đường dẫn tại đây',
              inputType: TextInputType.text,
              controller: urlController,
              keyboardAction: TextInputAction.next,
              onChange: _onChange,
            ),
          ),
          if (errorText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                errorText,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 20 / 12,
                  color: AppColor.error700,
                ),
              ),
            ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Trường "URL" là đường dẫn trang web đăng ký nhận biến động số dư của đối tác.',
              style: TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 60),
          MButtonWidget(
            title: 'Kích hoạt',
            isEnable: true,
            margin: EdgeInsets.symmetric(horizontal: 20),
            onTap: () => _onActivated(context),
          ),
          MButtonWidget(
            title: 'Đóng',
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

  String errorText = '';

  void _onChange(String value) {
    if (value.isEmpty) {
      errorText = '';
      setState(() {});
      return;
    }
    errorText = '';

    setState(() {});
  }

  _onActivated(BuildContext context) async {
    if (!StringUtils.isValidUrl(urlController.text) ||
        urlController.text.isEmpty) {
      errorText = 'Url không hợp lệ';
      setState(() {});
      return;
    }

    String loginId = '';
    String randomKey = '';

    List<String> splits = AESConvert.splitsKey(widget.code,
        replace: AESConvert.replaceWordPress,
        accessKey: AESConvert.accessKeyTokenPlugin);
    if (splits.isNotEmpty) {
      loginId = splits.last;
      randomKey = splits.first;
    }
    final body = {
      'loginId': loginId,
      'userId': SharePrefUtils.getProfile().userId,
      'randomKey': randomKey,
      'phoneNo': SharePrefUtils.getPhone(),
      'url': urlController.text,
    };
    try {
      final result = await _activatedPlugin(body);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: 'Kích hoạt thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).hintColor,
          fontSize: 15,
        );
      }
    } catch (e) {}
  }

  Future<ResponseMessageDTO> _activatedPlugin(body) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}accounts/push/ec';
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
