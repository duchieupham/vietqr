// ignore_for_file: deprecated_member_use

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/contact/save_contact_screen.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/vietqr_dto.dart';

class DialogFeatureWidget extends StatefulWidget {
  final dynamic dto;
  final TypeContact typeQR;
  final TypeQR? type;
  final String code;
  final GlobalKey? globalKey;

  const DialogFeatureWidget({
    super.key,
    required this.dto,
    required this.typeQR,
    required this.code,
    this.type = TypeQR.NONE,
    this.globalKey,
  });

  @override
  State<DialogFeatureWidget> createState() => _DialogFeatureWidgetState();
}

class _DialogFeatureWidgetState extends State<DialogFeatureWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor.WHITE,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(Icons.clear, color: AppColor.TRANSPARENT, size: 20),
                Expanded(
                  child: Text(
                    'Mã QR',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.clear,
                    color: AppColor.GREY_TEXT,
                    size: 20,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (widget.type == TypeQR.QR_LINK)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () async {
                  await launch(
                    widget.code,
                    forceSafariVC: false,
                  );
                },
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: const TextStyle(
                      color: AppColor.BLACK,
                    ),
                    children: [
                      const TextSpan(text: 'Đường dẫn: '),
                      TextSpan(
                        text: widget.code,
                        style: const TextStyle(
                          color: AppColor.BLUE_TEXT,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Text(
              widget.typeQR.dialogName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_list.length, (index) {
              return GestureDetector(
                onTap: () {
                  dataModel = _list[index];
                  onHandle(index);
                  setState(() {});
                },
                child: _buildItem(
                  _list[index],
                  isSelect: dataModel == _list[index],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void onHandle(int index) async {
    switch (index) {
      case 0:
        onSaveQR();
        return;
      case 1:
        onSaveImage();
        return;
      case 2:
        onCopy(dto: widget.dto, code: widget.code);
        return;
      case 3:
      default:
        share(dto: widget.dto);
        return;
    }
  }

  void onSaveQR() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SaveContactScreen(
          code: widget.code,
          dto: widget.dto,
          typeQR: widget.typeQR,
        ),
      ),
    );
    dataModel = null;
    setState(() {});
  }

  void onSaveImage() async {
    DialogWidget.instance.openLoadingDialog();
    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance
          .saveImageToGallery(widget.globalKey!)
          .then((value) {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: 'Đã lưu ảnh',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).cardColor,
          fontSize: 15,
        );
      });
    });
    dataModel = null;
    setState(() {});
  }

  void onCopy({required dynamic dto, required String code}) async {
    String text = '';
    if (dto != null) {
      if (dto is QRGeneratedDTO) {
        text = ShareUtils.instance.getTextSharing(dto);
      } else if (dto is VietQRDTO) {
        String prefix = '${dto.nickName}\nVietQR ID: ${dto.code}';
        text = '$prefix\nĐược tạo bởi vietqr.vn - Hotline 1900.6234';
      }
    } else {
      text = 'VietQR ID: $code\nĐược tạo bởi vietqr.vn - Hotline 1900.6234';
    }
    await FlutterClipboard.copy(text).then(
      (value) => Fluttertoast.showToast(
        msg: 'Đã sao chép',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Colors.black,
        fontSize: 15,
        webBgColor: 'rgba(255, 255, 255)',
        webPosition: 'center',
      ),
    );
    setState(() {
      dataModel = null;
    });
  }

  Future<void> share({required dynamic dto}) async {
    String text = 'Mã QR được tạo từ VietQR VN';
    if (dto != null && dto is QRGeneratedDTO) {
      text =
          '${dto.bankAccount} - ${dto.bankName}\nĐược tạo bởi vietqr.vn - Hotline 1900.6234'
              .trim();
    }

    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance.shareImage(
        key: widget.globalKey!,
        textSharing: text,
      );
    });
    setState(() {
      dataModel = null;
    });
  }

  Widget _buildItem(DataModel model, {bool isSelect = false}) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color:
                isSelect ? AppColor.BLUE_TEXT : AppColor.gray.withOpacity(0.4),
          ),
          child: Image.asset(
            model.url,
            width: 50,
            height: 50,
            color: isSelect ? AppColor.WHITE : AppColor.BLACK.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          model.title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  DataModel? dataModel;

  final List<DataModel> _list = [
    DataModel(title: 'Lưu thẻ QR', url: 'assets/images/ic-qr-wallet-grey.png'),
    DataModel(title: 'Lưu ảnh', url: 'assets/images/ic-img-blue.png'),
    DataModel(title: 'Sao chép', url: 'assets/images/ic_copy.png'),
    DataModel(title: 'Chia sẻ', url: 'assets/images/ic-share-blue.png'),
  ];
}

class DataModel {
  final String title;
  final String url;

  DataModel({required this.title, required this.url});
}
