import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr_widget.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class QRShareView extends StatelessWidget {
  static bool isShowShareSheet = false;
  static final GlobalKey globalKey = GlobalKey();

  const QRShareView({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final QRGeneratedDTO dto = arg['qrGeneratedDTO'];
    if (!isShowShareSheet) {
      Future.delayed(const Duration(milliseconds: 300), () async {
        await share(dto: dto).then((value) => isShowShareSheet = false);
      });
    }
    return Scaffold(
      body: Stack(
        children: [
          _buildComponent(
            context: context,
            dto: dto,
            globalKey: globalKey,
            width: width,
            height: height,
          ),
          Positioned(
            top: 0,
            child: Container(
              width: width,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 65,
              alignment: Alignment.bottomLeft,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const SizedBox(
                    width: 40,
                    height: 20,
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 20,
                      color: DefaultTheme.WHITE,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Chia sẻ mã QR',
                  style: TextStyle(
                    fontSize: 20,
                    color: DefaultTheme.WHITE,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const SizedBox(
                  width: 40,
                  height: 20,
                ),
              ]),
            ),
          ),
          Positioned(
            bottom: 20,
            child: SizedBox(
              width: width,
              height: 40,
              child: Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 20)),
                  ButtonIconWidget(
                    width: width / 2 - 25,
                    height: 40,
                    icon: Icons.copy_rounded,
                    title: 'Sao chép nội dung',
                    function: () async {
                      await FlutterClipboard.copy(
                              ShareUtils.instance.getTextSharing(dto))
                          .then(
                        (value) => Fluttertoast.showToast(
                          msg: 'Đã sao chép',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).hintColor,
                          fontSize: 15,
                          webBgColor: 'rgba(255, 255, 255)',
                          webPosition: 'center',
                        ),
                      );
                    },
                    bgColor: Theme.of(context).cardColor,
                    textColor: DefaultTheme.BLUE_TEXT,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  ButtonIconWidget(
                    width: width / 2 - 25,
                    height: 40,
                    icon: Icons.share_rounded,
                    title: 'Chia sẻ mã QR',
                    function: () async {
                      await share(dto: dto);
                    },
                    bgColor: Theme.of(context).cardColor,
                    textColor: DefaultTheme.GREEN,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 20)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> share({required QRGeneratedDTO dto}) async {
    await ShareUtils.instance.shareImage(
      key: globalKey,
      textSharing: ShareUtils.instance.getTextSharing(dto),
    );
  }

  Widget _buildComponent({
    required BuildContext context,
    required GlobalKey globalKey,
    required QRGeneratedDTO dto,
    required double width,
    required double height,
  }) {
    return RepaintBoundaryWidget(
        globalKey: globalKey,
        builder: (key) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: Image.asset('assets/images/bg-qr.png').image),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VietQRWidget(
                  width: width,
                  qrGeneratedDTO: dto,
                  content: dto.content,
                ),
              ],
            ),
          );
        });
  }
}
