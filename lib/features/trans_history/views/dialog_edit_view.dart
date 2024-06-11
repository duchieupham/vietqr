import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/transaction_detail/repositories/transaction_repository.dart';
import 'package:vierqr/layouts/m_button_widget.dart';

class DialogEditView extends StatefulWidget {
  final String id;

  const DialogEditView({super.key, required this.id});

  @override
  State<DialogEditView> createState() => _DialogEditViewState();
}

class _DialogEditViewState extends State<DialogEditView> {
  final controller = TextEditingController();
  final transactionRepository = getIt.get<TransactionRepository>();

  String error = '';

  Future<void> _updateNote(Map<String, dynamic> body) async {
    final result = await transactionRepository.updateNote(body);
    if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: 'Cập nhật ghi chú thành công',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Theme.of(context).hintColor,
        fontSize: 15,
      );
    } else {
      String msg = ErrorUtils.instance.getErrorMessage(result.message);
      error = msg;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 12),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextFieldCustom(
                  isObscureText: false,
                  fillColor: AppColor.GREY_VIEW,
                  textFieldType: TextfieldType.LABEL,
                  title: 'Ghi chú',
                  autoFocus: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  hintText: 'Nhập ghi chú tại đây',
                  inputType: TextInputType.text,
                  keyboardAction: TextInputAction.next,
                  controller: controller,
                  onChange: (value) {
                    setState(() {
                      error = '';
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        if (error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 16, top: 8),
            child: Text(
              error,
              style: TextStyle(color: AppColor.error700),
            ),
          ),
        const SizedBox(height: 30),
        MButtonWidget(
          title: 'Cập nhật ghi chú',
          padding: EdgeInsets.symmetric(horizontal: 20),
          colorEnableBgr: AppColor.BLUE_TEXT,
          colorEnableText: AppColor.WHITE,
          colorDisableBgr: AppColor.gray,
          isEnable: error.isEmpty,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            Map<String, dynamic> body = {
              'note': controller.text,
              'id': widget.id,
            };
            _updateNote(body);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
