import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/services/providers/connect_lark_provider.dart';

class SettingLarkPage extends StatelessWidget {
  const SettingLarkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectLarkProvider>(builder: (context, provider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Webhook Address',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 4,
          ),
          MTextFieldCustom(
            isObscureText: false,
            maxLines: 1,
            value: provider.webHook,
            fillColor: AppColor.WHITE,
            title: 'Số tiền',
            autoFocus: true,
            hintText: '',
            inputType: TextInputType.text,
            keyboardAction: TextInputAction.next,
            onChange: provider.updateWebHook,
          ),
          if (provider.errorWebhook)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Webhook Address không đúng định dạng',
                style: const TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
              ),
            ),
        ],
      );
    });
  }
}
