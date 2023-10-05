import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class MyQRBottomSheet extends StatefulWidget {
  MyQRBottomSheet({Key? key}) : super(key: key);

  @override
  State<MyQRBottomSheet> createState() => _MyQRBottomSheetState();
}

class _MyQRBottomSheetState extends State<MyQRBottomSheet> {
  final GlobalKey globalKey = GlobalKey();

  Future<void> share({required String name}) async {
    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance.shareImage(
        textSharing: 'VietId of $name',
        key: globalKey,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    bool isSmall = height < 800;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundaryWidget(
              globalKey: globalKey,
              builder: (key) {
                return Container(
                  margin: isSmall
                      ? EdgeInsets.symmetric(horizontal: 40, vertical: 16)
                      : EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: getBgGradient(colorType),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTypeQr(
                          typeQR: TypeContact.VietQR_ID,
                          name:
                              UserInformationHelper.instance.getUserFullname()),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: AppColor.greyF0F0F0,
                      ),
                      Stack(
                        children: [
                          Container(
                            margin: isSmall
                                ? const EdgeInsets.only(
                                    left: 20, right: 20, top: 15, bottom: 15)
                                : const EdgeInsets.only(
                                    left: 40, right: 40, top: 30, bottom: 30),
                            decoration: BoxDecoration(
                              color: AppColor.WHITE,
                            ),
                            child: QrImage(
                              data:
                                  UserInformationHelper.instance.getWalletId(),
                              version: QrVersions.auto,
                              size: isSmall ? width / 2 : null,
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: ImageUtils.instance
                                          .getImageNetWork(UserInformationHelper
                                              .instance
                                              .getAccountInformation()
                                              .imgId)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        UserInformationHelper.instance.getUserFullname(),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.WHITE),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              }),
          Container(
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
                          'My QR',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
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
                Text(
                  'Cùng chia sẻ mã QR của bạn',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_list.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        dataModel = _list[index];
                        onHandle(index);
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
          ),
        ],
      ),
    );
  }

  void onHandle(int index) async {
    switch (index) {
      case 0:
        onSaveImage();
        return;
      case 1:
        share(name: UserInformationHelper.instance.getUserFullname());
        return;
      case 2:
      default:
        onChangeColor();
        return;
    }
  }

  int colorType = 0;

  void onChangeColor() {
    final random = Random();

    int data = random.nextInt(5);
    if (colorType == data) {
      onChangeColor();
    } else {
      colorType = data;
    }
    setState(() {});
  }

  void onSaveImage() async {
    DialogWidget.instance.openLoadingDialog();
    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance.saveImageToGallery(globalKey).then((value) {
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

  Widget _buildTypeQr(
      {TypeContact typeQR = TypeContact.NONE, required String name}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: BorderRadius.circular(40),
              image: const DecorationImage(
                  image: AssetImage('assets/images/ic-viet-qr-small.png'),
                  fit: BoxFit.contain),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  typeQR.typeName,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Gradient getBgGradient(colorType) {
    switch (colorType) {
      case 0:
        return LinearGradient(
          colors: [
            const Color(0xFF5FFFD8),
            const Color(0xFF0A7AFF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 1:
        return LinearGradient(
          colors: [
            const Color(0xFF52FBFF),
            const Color(0xFF06711B),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 2:
        return LinearGradient(
          colors: [
            const Color(0xFFEECDFF),
            const Color(0xFF49558A),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 3:
        return LinearGradient(
          colors: [
            const Color(0xFFFBAE1F),
            const Color(0xFFFC6A01),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 4:
        return LinearGradient(
          colors: [
            const Color(0xFFFF6DC6),
            const Color(0xFFF8837A),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return LinearGradient(
          colors: [
            const Color(0xFF5FFFD8),
            const Color(0xFF0A7AFF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  Widget _buildItem(DataModel model, index) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: AppColor.GREY_F1F2F5,
          ),
          child: Image.asset(
            model.url,
            width: 40,
            height: 40,
            color: AppColor.BLACK.withOpacity(0.35),
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
    DataModel(title: 'Lưu ảnh', url: 'assets/images/ic-img-blue.png'),
    DataModel(title: 'Chia sẻ', url: 'assets/images/ic-share-blue.png'),
    DataModel(
        title: 'Đổi màu QR', url: 'assets/images/ic-change-color-my-qr.png'),
  ];
}

class DataModel {
  final String title;
  final String url;

  DataModel({required this.title, required this.url});
}
