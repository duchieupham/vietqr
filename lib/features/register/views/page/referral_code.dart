import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/features/register/blocs/register_bloc.dart';
import 'package:vierqr/features/register/events/register_event.dart';
import 'package:vierqr/features/register/states/register_state.dart';

import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/widgets/textfield_custom.dart';

class ReferralCode extends StatelessWidget {
  const ReferralCode({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = getIt.get<RegisterBloc>();
    final TextEditingController introducController = TextEditingController();

    return BlocBuilder<RegisterBloc, RegisterState>(
      bloc: bloc,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(top: 150, left: 20, right: 20),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                fontSize: 15,
                controller: introducController,
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onChange: (value) {
                  bloc.add(RegisterEventUpdateIntroduce(introduce: value));
                },
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
