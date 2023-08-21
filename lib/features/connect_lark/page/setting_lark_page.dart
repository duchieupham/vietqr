import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/services/providers/connect_lark_provider.dart';

class SettingLarkPage extends StatefulWidget {
  const SettingLarkPage({Key? key}) : super(key: key);

  @override
  State<SettingLarkPage> createState() => _SettingLarkPageState();
}

class _SettingLarkPageState extends State<SettingLarkPage>
    with WidgetsBindingObserver {
  TextEditingController webHookEditingController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        Provider.of<ConnectLarkProvider>(context, listen: false)
            .getClipBoardData();
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

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
          if (provider.clipboardText.isNotEmpty)
            GestureDetector(
              onTap: () {
                webHookEditingController.text = provider.clipboardText;
                webHookEditingController.selection = TextSelection.fromPosition(
                    TextPosition(offset: provider.clipboardText.length));
                provider.updateWebHook(provider.clipboardText);
                provider.clearClipBoardData();
              },
              child: Container(
                margin: EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColor.BLUE_TEXT.withOpacity(0.2)),
                child: Text(
                  provider.clipboardText,
                  style:
                      const TextStyle(color: AppColor.BLUE_TEXT, fontSize: 13),
                ),
              ),
            )
        ],
      );
    });
  }
}
