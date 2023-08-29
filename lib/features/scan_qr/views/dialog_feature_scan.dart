// ignore_for_file: deprecated_member_use

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/contact/save_contact_screen.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/vietqr_dto.dart';

class DialogFeatureWidget extends StatefulWidget {
  final dynamic dto;
  final TypeContact typeQR;
  final TypeQR? type;
  final String code;
  final GlobalKey? globalKey;
  final BankTypeDTO? bankTypeDTO;
  final bool isSmall;
  final bool isShowIconFirst;

  const DialogFeatureWidget({
    super.key,
    required this.dto,
    required this.typeQR,
    required this.code,
    this.type = TypeQR.NONE,
    this.globalKey,
    this.bankTypeDTO,
    this.isSmall = false,
    this.isShowIconFirst = true,
  });

  @override
  State<DialogFeatureWidget> createState() => _DialogFeatureWidgetState();
}

class _DialogFeatureWidgetState extends State<DialogFeatureWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.isShowIconFirst) {
      if (widget.typeQR == TypeContact.Bank) {
        _list.first = dataBank;
      } else {
        _list.first = dataOther;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
                Icon(
                  Icons.clear,
                  color: AppColor.TRANSPARENT,
                  size: widget.isSmall ? 16 : 20,
                ),
                Expanded(
                  child: Text(
                    'Mã QR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: widget.isSmall ? 14 : 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.clear,
                    color: AppColor.GREY_TEXT,
                    size: widget.isSmall ? 16 : 20,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
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
              style: TextStyle(
                  fontSize: widget.isSmall ? 12 : 15,
                  fontWeight: FontWeight.w400),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_list.length, (index) {
              return GestureDetector(
                onTap: () {
                  onHandle(_list[index].index);
                },
                child: _buildItem(
                  _list[index],
                  index,
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
        if (widget.typeQR == TypeContact.Bank) {
          onSaveTK();
        } else {
          onSaveQR();
        }
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

  void onSaveTK() async {
    if (widget.dto is QRGeneratedDTO) {
      QRGeneratedDTO value = widget.dto;
      if (value.isNaviAddBank) {
        await Navigator.pushNamed(
          context,
          Routes.ADD_BANK_CARD,
          arguments: {
            'step': 0,
            'bankDTO': widget.bankTypeDTO,
            'bankAccount': value.bankAccount,
            'name': ''
          },
        );

        eventBus.fire(ChangeThemeEvent());
      } else {
        context
            .read<DashBoardBloc>()
            .add(DashBoardCheckExistedEvent(dto: value));
      }
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
  }

  void onSaveImage() async {
    DialogWidget.instance.openLoadingDialog();
    await Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        await ShareUtils.instance.saveImageToGallery(widget.globalKey!).then(
          (value) {
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: 'Đã lưu ảnh',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).cardColor,
              fontSize: 15,
            );
          },
        );
      },
    );
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
  }

  Widget _buildItem(DataModel model, index) {
    final height = MediaQuery.of(context).size.height;
    double size = 40;
    if (height < 800) {
      size = 28;
    }
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: index == 0 ? AppColor.BLUE_TEXT : AppColor.GREY_F1F2F5,
          ),
          child: Image.asset(
            model.url,
            width: size,
            height: size,
            color:
                index == 0 ? AppColor.WHITE : AppColor.BLACK.withOpacity(0.35),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          model.title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: height < 800 ? 12 : 15),
        ),
      ],
    );
  }

  final DataModel dataBank = DataModel(
    title: 'Lưu TK',
    url: 'assets/images/ic-tb-card-selected.png',
    index: 0,
  );

  final DataModel dataOther = DataModel(
    title: 'Lưu thẻ QR',
    url: 'assets/images/ic-qr-wallet-grey.png',
    index: 0,
  );

  List<DataModel> _list = [
    DataModel(
      title: 'Lưu ảnh',
      url: 'assets/images/ic-img-blue.png',
      index: 1,
    ),
    DataModel(
      title: 'Sao chép',
      url: 'assets/images/ic_copy.png',
      index: 2,
    ),
    DataModel(
      title: 'Chia sẻ',
      url: 'assets/images/ic-share-blue.png',
      index: 3,
    ),
  ];
}

class DataModel {
  final String title;
  final String url;
  final int index;

  DataModel({
    required this.title,
    required this.url,
    required this.index,
  });
}
