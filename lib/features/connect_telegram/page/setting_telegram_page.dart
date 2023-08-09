import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';

import '../../../services/providers/connect_telegram_provider.dart';

class SettingTelegramPage extends StatelessWidget {
  const SettingTelegramPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectTelegramProvider>(
        builder: (context, provider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chat id',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 4,
          ),
          MTextFieldCustom(
            isObscureText: false,
            maxLines: 1,
            value: provider.chatId,
            fillColor: AppColor.WHITE,
            title: 'Số tiền',
            autoFocus: true,
            hintText: '',
            inputType: TextInputType.text,
            keyboardAction: TextInputAction.next,
            onChange: provider.updateChatId,
          ),
          if (provider.errChatId)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Chat ID không đúng định dạng',
                style: const TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
              ),
            ),
        ],
      );
    });
  }
}
