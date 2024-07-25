import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';

class SaveShareTransDetail extends StatefulWidget {
  final TypeImage type;

  const SaveShareTransDetail({super.key, required this.type});

  @override
  State<SaveShareTransDetail> createState() => _SaveShareTransDetailState();
}

class _SaveShareTransDetailState extends State<SaveShareTransDetail> {
  final globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(milliseconds: 2000),
      () async {
        if (widget.type == TypeImage.SAVE) {
          onSaveImage(context);
        } else if (widget.type == TypeImage.SHARE) {
          share();
        }
      },
    );
  }

  void share() async {
    await ShareUtils.instance
        .shareImage(key: globalKey, textSharing: '')
        .then((value) {
      Navigator.pop(context);
    });
  }

  void onSaveImage(BuildContext context) async {
    DialogWidget.instance.openLoadingDialog();
    await Future.delayed(
      const Duration(milliseconds: 2000),
      () async {
        await ShareUtils.instance.saveImageToGallery(globalKey).then(
          (value) {
            Navigator.pop(context);
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: 'Đã lưu ảnh',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: AppColor.WHITE,
    );
  }
}
