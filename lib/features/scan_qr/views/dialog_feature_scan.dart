// ignore_for_file: deprecated_member_use

import 'package:clipboard/clipboard.dart';
import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/printer_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/contact/save_contact_screen.dart';
import 'package:vierqr/features/printer/views/printing_view.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/vietqr_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/sqflite/local_database.dart';


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
        _list.add(dataBank);
      } else {
        _list.add(dataOther);
      }
    } else {
      _list.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_list.length, (index) {
              final DataModel model = _list[index];
              if (!widget.isShowIconFirst) {
                return _buildItem(model);
              } else if (index < _list.length - 1) {
                return _buildItem(model);
              }
              return const SizedBox();
            }).toList(),
          ),
          const SizedBox(height: 8),
          if (widget.isShowIconFirst)
            Row(
              children: [
                _buildItem(dataHome),
                Expanded(
                  child: MButtonWidget(
                    title: _list.last.title,
                    isEnable: true,
                    onTap: () {
                      onHandle(_list.last.index);
                    },
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.typeQR == TypeContact.VietQR_ID ||
                            widget.typeQR == TypeContact.Bank)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6),
                            child: Image.asset(
                              _list.last.url,
                              color: AppColor.WHITE,
                            ),
                          ),
                        Text(
                          _list.last.title,
                          style: const TextStyle(
                            color: AppColor.WHITE,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
        ],
      ),
    );
  }

  void onHandle(int index) async {
    switch (index) {
      case 0:
        onPrint(widget.code);
        return;
      case 1:
        onSaveImage();
        return;
      case 2:
        onCopy(dto: widget.dto, code: widget.code);
        return;
      case 3:
        share(dto: widget.dto);
        return;
      case 4:
        Utils.navigateToRoot(context);
        return;
      case 5:
      default:
        if (widget.typeQR == TypeContact.Bank) {
          onSaveTK();
        } else {
          onSaveQR();
        }
        return;
    }
  }

  void onSaveTK() async {
    if (widget.dto is QRGeneratedDTO) {
      QRGeneratedDTO value = widget.dto;
      BankTypeDTO? bankTypeDTO = widget.bankTypeDTO;
      if (bankTypeDTO != null) {
        bankTypeDTO.bankAccount = value.bankAccount;
      }

      final data = await NavigatorUtils.navigatePage(
          context, AddBankScreen(bankTypeDTO: bankTypeDTO),
          routeName: AddBankScreen.routeName);

      // final data = await Navigator.pushNamed(
      //   context,
      //   Routes.ADD_BANK_CARD,
      //   arguments: {
      //     'step': 0,
      //     'bankDTO': widget.bankTypeDTO,
      //     'bankAccount': value.bankAccount,
      //     'name': ''
      //   },
      // );
      eventBus.fire(GetListBankScreen());

      if (data is bool) {
        Navigator.of(context).pop();
      }
    }
  }

  void onSaveQR() async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SaveContactScreen(
          code: widget.code,
          dto: widget.dto,
          typeQR: widget.typeQR,
        ),
      ),
    );

    if (data is bool) {
      Navigator.of(context).pop(true);
    }
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
              textColor: Theme.of(context).hintColor,
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
      } else if (dto is VCardModel) {
        text =
            '${dto.fullname} - ${dto.phoneNo}\nĐược tạo bởi vietqr.vn - Hotline 1900.6234';
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

  onPrint(String qr) async {
    String userId = SharePrefUtils.getProfile().userId;
    BluetoothPrinterDTO bluetoothPrinterDTO =
        await LocalDatabase.instance.getBluetoothPrinter(userId);
    if (bluetoothPrinterDTO.id.isNotEmpty) {
      bool isPrinting = false;
      if (!isPrinting) {
        isPrinting = true;
        DialogWidget.instance
            .showFullModalBottomContent(widget: const PrintingView());
        await PrinterUtils.instance.printQRCode(qr).then((value) {
          Navigator.pop(context);
          isPrinting = false;
        });
      }
    } else {
      DialogWidget.instance.openMsgDialog(
          title: 'Không thể in',
          msg: 'Vui lòng kết nối với máy in để thực hiện việc in.');
    }
  }

  Widget _buildItem(DataModel model) {
    final width = MediaQuery.of(context).size.width;
    final maxWidthItem = widget.isShowIconFirst
        ? (width - 64) * (1 / (_list.length - 1))
        : (width - 64) * (1 / (_list.length));

    double size = 15;
    return GestureDetector(
      onTap: () {
        onHandle(model.index);
      },
      child: Container(
        height: 40,
        width: maxWidthItem,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColor.BLUE_TEXT.withOpacity(0.3),
        ),
        child: Image.asset(
          model.url,
          width: size,
          color: AppColor.BLUE_TEXT,
        ),
      ),
    );
  }

  final DataModel dataBank = DataModel(
    title: 'Lưu TK ngân hàng',
    url: 'assets/images/ic-tb-card-selected.png',
    index: 5,
  );

  final DataModel dataOther = DataModel(
    title: 'Lưu thẻ QR',
    url: 'assets/images/ic-qr-wallet-grey.png',
    index: 5,
  );

  final DataModel dataHome = DataModel(
    title: 'Trang chủ',
    url: 'assets/images/ic-home-blue.png',
    index: 4,
  );

  final List<DataModel> _list = [
    DataModel(
      title: 'In',
      url: 'assets/images/ic-print-blue.png',
      index: 0,
    ),
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
