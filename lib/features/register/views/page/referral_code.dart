import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/services/providers/register_provider.dart';

import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/widgets/textfield_custom.dart';

class ReferralCode extends StatelessWidget {
  const ReferralCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: EdgeInsets.only(top: 150, left: 20, right: 20),
          alignment: Alignment.center,
          child: Column(
            children: [
              TextFieldCustom(
                isObscureText: false,
                maxLines: 1,
                autoFocus: true,
                textFieldType: TextfieldType.LABEL,
                title: 'Nhập thông tin\nngười giới thiệu cho bạn',
                titleSize: 25,
                hintText: 'Nhập mã giới thiệu ở đây',
                fontSize: 15,
                controller: provider.introduceController,
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onChange: provider.updateIntroduce,
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                height: 1,
                color: AppColor.GREY_LIGHT,
                width: double.infinity,
              ),
            ],
          ),
        );
      },
    );
  }
}