import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr.dart';
import 'package:vierqr/commons/widgets/viet_qr_widget.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/providers/action_share_provider.dart';
import 'package:vierqr/services/providers/water_mark_provider.dart';

class QRShareView extends StatelessWidget {
  final GlobalKey globalKey = GlobalKey();
  final WaterMarkProvider _waterMarkProvider = WaterMarkProvider(false);

  QRShareView({super.key});

  void initialServices(
      BuildContext context, String action, QRGeneratedDTO dto) async {
    bool isShowShareSheet =
        Provider.of<ActionShareProvider>(context, listen: false).showAction;
    if (action == 'SHARE') {
      if (!isShowShareSheet) {
        await Future.delayed(const Duration(milliseconds: 0), () {
          Provider.of<ActionShareProvider>(context, listen: false)
              .updateAction(true);
        });

        _waterMarkProvider.updateWaterMark(true);
        await Future.delayed(const Duration(milliseconds: 300), () async {
          await share(dto: dto).then((value) {
            _waterMarkProvider.updateWaterMark(false);
          });
        });
      }
    } else if (action == 'SAVE') {
      if (!isShowShareSheet) {
        await Future.delayed(const Duration(milliseconds: 0), () {
          Provider.of<ActionShareProvider>(context, listen: false)
              .updateAction(true);
        });
        _waterMarkProvider.updateWaterMark(true);
        await Future.delayed(const Duration(milliseconds: 300), () async {
          _waterMarkProvider.updateWaterMark(false);
          await ShareUtils.instance.saveImageToGallery(globalKey).then((value) {
            Fluttertoast.showToast(
              msg: 'Đã lưu ảnh',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
            );
            // Navigator.pop(context);
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final QRGeneratedDTO dto = args['qrGeneratedDTO'];
    String action = 'SHARE';
    if (ModalRoute.of(context)!.settings.arguments != null) {
      action = args['action'] ?? 'SHARE';
    }
    initialServices(context, action, dto);
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
            top: (height > 700 && PlatformUtils.instance.isIOsApp()) ? 20 : 0,
            child: Container(
              width: width,
              padding: const EdgeInsets.only(left: 10, bottom: 20),
              height: 80,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bgr-header.png'),
                  fit: BoxFit.fill,
                ),
              ),
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
                      color: AppColor.BLACK,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Chia sẻ mã QR',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColor.BLACK,
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
                          backgroundColor: Theme.of(context).cardColor,
                          textColor: Theme.of(context).hintColor,
                          fontSize: 15,
                          webBgColor: 'rgba(255, 255, 255)',
                          webPosition: 'center',
                        ),
                      );
                    },
                    bgColor: Theme.of(context).cardColor,
                    textColor: AppColor.BLUE_TEXT,
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
                    textColor: AppColor.GREEN,
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
    _waterMarkProvider.updateWaterMark(true);
    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance
          .shareImage(
            key: globalKey,
            textSharing: ShareUtils.instance.getTextSharing(dto),
          )
          .then((value) => _waterMarkProvider.updateWaterMark(false));
    });
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VietQr(
                qrGeneratedDTO: dto,
                content: dto.content,
              ),
              ValueListenableBuilder(
                valueListenable: _waterMarkProvider,
                builder: (_, provider, child) {
                  return Visibility(
                    visible: provider == true,
                    child: Container(
                      width: width,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: RichText(
                        textAlign: TextAlign.right,
                        text: const TextSpan(
                          style: TextStyle(
                            color: AppColor.WHITE,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(text: 'Được tạo bởi '),
                            TextSpan(
                              text: 'vietqr.vn',
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                            TextSpan(text: ' - '),
                            TextSpan(text: 'Hotline '),
                            TextSpan(
                              text: '19006234',
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }
}
