import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';

class UpdateNoteWidget extends StatefulWidget {
  final String text;
  const UpdateNoteWidget({super.key, required this.text});

  @override
  State<UpdateNoteWidget> createState() => _UpdateNotWidgetState();
}

class _UpdateNotWidgetState extends State<UpdateNoteWidget> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
        )),
        Positioned(
          bottom: 0 + MediaQuery.of(context).viewInsets.bottom,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
            width: MediaQuery.of(context).size.width - 20,
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Cập nhật ghi chú giao dịch',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const XImage(
                        imagePath: 'assets/images/ic-close-black.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const MySeparator(color: AppColor.GREY_DADADA),
                const SizedBox(height: 10),
                Expanded(
                    child: MTextFieldCustom(
                        controller: textController,
                        contentPadding: EdgeInsets.zero,
                        enable: true,
                        maxLines: 9,
                        hintText: 'Nhập ghi chú tại đây.',
                        focusBorder: InputBorder.none,
                        enableBorder: InputBorder.none,
                        onSubmitted: (value) {
                          Navigator.of(context).pop(textController.text);
                        },
                        keyboardAction: TextInputAction.next,
                        onChange: (value) {},
                        inputType: TextInputType.text,
                        isObscureText: false)),
                const SizedBox(height: 10),
                const MySeparator(color: AppColor.GREY_DADADA),
                const SizedBox(height: 10),
                VietQRButton.gradient(
                    onPressed: () {
                      Navigator.of(context).pop(textController.text);
                    },
                    isDisabled: false,
                    child: const Center(
                      child: Text(
                        'Lưu thay đổi',
                        style: TextStyle(fontSize: 12, color: AppColor.WHITE),
                      ),
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }
}
