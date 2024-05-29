import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dashed_line.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr_new.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class PopupBankShare extends StatefulWidget {
  static String routeName = '/popup_bank_share';

  final QRGeneratedDTO dto;
  final TypeImage type;

  PopupBankShare({super.key, required this.dto, required this.type});

  @override
  State<PopupBankShare> createState() => _PopupBankShareState();
}

class _PopupBankShareState extends State<PopupBankShare> {
  final globalKey = GlobalKey();

  double get paddingHorizontal => 45;

  bool get small => MediaQuery.of(context).size.height < 800;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () async {
      if (widget.type == TypeImage.SAVE) {
        onSaveImage(context);
      } else if (widget.type == TypeImage.SHARE) {
        share();
      }
    });
  }

  void share() async {
    await ShareUtils.instance
        .shareImage(
            key: globalKey,
            textSharing: ShareUtils.instance.getTextSharing(widget.dto))
        .then((value) {
      Navigator.pop(context);
    });
  }

  void onSaveImage(BuildContext context) async {
    DialogWidget.instance.openLoadingDialog();
    await Future.delayed(
      const Duration(milliseconds: 200),
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
    return Scaffold(
      body: Stack(
        children: [
          RepaintBoundaryWidget(
            globalKey: globalKey,
            builder: (key) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg-qr-vqr.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.dto.bankAccount.isNotEmpty)
                            Container(
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AppColor.GREY_BG,
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: small ? 60 : 80,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: ImageUtils.instance
                                              .getImageNetWork(
                                                  widget.dto.imgId),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 10),
                                      child: VerticalDashedLine(),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              widget.dto.bankAccount,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: AppColor.BLACK,
                                                  fontSize: small ? 12 : 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              widget.dto.userBankName
                                                  .toUpperCase(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: AppColor.BLACK_TEXT,
                                                fontSize: small ? 11 : 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 12),
                          VietQrNew(qrCode: widget.dto.qrCode),
                          const SizedBox(height: 12),
                          if (widget.dto.amount.isNotEmpty ||
                              widget.dto.content.isNotEmpty)
                            Container(
                              width: 300,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColor.WHITE,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Số tiền:',
                                        style: TextStyle(
                                            color: AppColor.BLACK_TEXT
                                                .withOpacity(0.6)),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '+ ${CurrencyUtils.instance.getCurrencyFormatted(widget.dto.amount)} VND',
                                        style: TextStyle(
                                          color: AppColor.ORANGE_DARK,
                                          fontSize: widget.dto.amount.length > 8
                                              ? 18
                                              : 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  if (widget.dto.content.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    const Divider(color: AppColor.GREY_BORDER),
                                    Text(
                                      'Nội dung:',
                                      style: TextStyle(
                                          color: AppColor.BLACK_TEXT
                                              .withOpacity(0.6)),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      width: double.infinity,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.dto.content,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          if (small) const SizedBox(height: 30),
                        ],
                      ),
                    ),
                    Center(
                      child: Text('BY VIETQR VN',
                          style:
                              TextStyle(color: AppColor.WHITE, fontSize: 16)),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
          Positioned(
            top: small ? 40 : kToolbarHeight,
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.close,
                  color: AppColor.WHITE, size: small ? 28 : 36),
              padding: EdgeInsets.only(left: 16),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
