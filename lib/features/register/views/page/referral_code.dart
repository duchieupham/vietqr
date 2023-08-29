import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/services/providers/register_provider.dart';

import '../../../../commons/widgets/textfield_custom.dart';

class ReferralCode extends StatelessWidget {
  const ReferralCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        return TextFieldCustom(
          isObscureText: false,
          maxLines: 1,
          autoFocus: true,
          textFieldType: TextfieldType.LABEL,
          title: 'Thông tin người giới thiệu',
          hintText: 'Mã giới thiệu của bạn bè đã chia sẻ cho bạn trước đó',
          fontSize: 12,
          subTitle: '(Tuỳ chọn nếu có)',
          controller: provider.introduceController,
          inputType: TextInputType.text,
          keyboardAction: TextInputAction.next,
          onChange: provider.updateIntroduce,
        );
      },
    );
  }
}
