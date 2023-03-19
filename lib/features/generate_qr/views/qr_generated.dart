import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr_widget.dart';
import 'package:vierqr/features/generate_qr/widgets/popup_transaction_content.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/providers/create_qr_page_select_provider.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QRGenerated extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRGenerated();

  const QRGenerated({
    Key? key,
  }) : super(key: key);
}

class _QRGenerated extends State<QRGenerated> {
  static final GlobalKey globalKey = GlobalKey();
  static late QRGeneratedDTO qrGeneratedDTO;
  static late BankAccountDTO bankAccountDTO;
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 1000),
      () {
        DialogWidget.instance.openContentDialog(
          () {
            Navigator.pop(context);
          },
          PopupTransactionContent(
              qrGeneratedDTO: qrGeneratedDTO,
              bankAccountDTO: bankAccountDTO,
              status: 0),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    qrGeneratedDTO = args['qrGeneratedDTO'];
    bankAccountDTO = args['bankAccountDTO'];
    return Scaffold(
      body: Stack(
        children: [
          _buildComponent(
            context: context,
            dto: qrGeneratedDTO,
            globalKey: globalKey,
            width: width,
            height: height,
          ),
          Positioned(
            bottom: 70,
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
                      await FlutterClipboard.copy(ShareUtils.instance
                              .getTextSharing(qrGeneratedDTO))
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
                      await share(dto: qrGeneratedDTO);
                    },
                    bgColor: Theme.of(context).cardColor,
                    textColor: DefaultTheme.GREEN,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 20)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ButtonIconWidget(
              width: width - 40,
              height: 40,
              icon: Icons.home_rounded,
              title: 'Trang chủ',
              function: () {
                Navigator.pop(context);
              },
              bgColor: DefaultTheme.GREEN,
              textColor: DefaultTheme.WHITE,
            ),
          ),
        ],
      ),
      // Container(
      //   width: width,
      //   height: height,
      //   decoration: const BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage('assets/images/bg-qr.png'),
      //       fit: BoxFit.fitHeight,
      //     ),
      //   ),
      //   child: Column(children: [
      //     // SizedBox(
      //     //   width: MediaQuery.of(context).size.width,
      //     //   height: 65,
      //     //   child: ClipRRect(
      //     //     child: BackdropFilter(
      //     //       filter: ImageFilter.blur(
      //     //         sigmaX: 25,
      //     //         sigmaY: 25,
      //     //       ),
      //     //       child: Container(
      //     //         decoration: BoxDecoration(
      //     //           color: Theme.of(context).canvasColor.withOpacity(0.6),
      //     //         ),
      //     //         child: SubHeader(
      //     //           title: 'QR giao dịch',
      //     //           function: () {
      //     //             backToHome(context);
      //     //           },
      //     //         ),
      //     //       ),
      //     //     ),
      //     //   ),
      //     // ),
      //     const Padding(padding: EdgeInsets.only(top: 50)),
      //     Expanded(
      //       child: VietQRWidget(
      //         width: width - 10,
      //         qrGeneratedDTO: qrGeneratedDTO,
      //         content: '',
      //         isCopy: true,
      //         isStatistic: true,
      //       ),
      //     ),
      //     const Padding(padding: EdgeInsets.only(bottom: 30)),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         ButtonIconWidget(
      //           width: width * 0.4,
      //           height: 50,
      //           borderRadius: 15,
      //           icon: Icons.home_rounded,
      //           alignment: Alignment.center,
      //           title: 'Trang chủ',
      //           function: () {
      //             backToHome(context);
      //           },
      //           bgColor: DefaultTheme.GREEN,
      //           textColor: DefaultTheme.WHITE,
      //         ),
      //         const Padding(padding: EdgeInsets.only(left: 10)),
      //         ButtonIconWidget(
      //           width: width * 0.4,
      //           height: 50,
      //           borderRadius: 15,
      //           icon: Icons.share_rounded,
      //           alignment: Alignment.center,
      //           title: 'Chia sẻ',
      //           function: () async {
      //             await ShareUtils.instance.shareImage(
      //               key: key,
      //               textSharing:
      //                   ShareUtils.instance.getTextSharing(qrGeneratedDTO),
      //             );
      //           },
      //           bgColor: DefaultTheme.GREEN,
      //           textColor: DefaultTheme.WHITE,
      //         ),
      //       ],
      //     ),
      //     const Padding(padding: EdgeInsets.only(top: 10)),
      //     ButtonIconWidget(
      //       width: width * 0.8 + 10,
      //       height: 50,
      //       borderRadius: 15,
      //       icon: Icons.refresh_rounded,
      //       alignment: Alignment.center,
      //       title: 'Tạo lại mã QR',
      //       function: () {
      //         Provider.of<CreateQRProvider>(context, listen: false).reset();
      //         Provider.of<CreateQRPageSelectProvider>(context, listen: false)
      //             .updateIndex(0);
      //         Navigator.of(context).pushReplacement(
      //           MaterialPageRoute(
      //             builder: (context) => CreateQR(
      //               bankAccountDTO: bankAccountDTO,
      //             ),
      //           ),
      //         );
      //       },
      //       bgColor: Theme.of(context).canvasColor,
      //       textColor: DefaultTheme.GREEN,
      //     ),
      //     const Padding(padding: EdgeInsets.only(bottom: 20)),
      //   ]),
      // ),
    );
  }

  Future<void> share({required QRGeneratedDTO dto}) async {
    await ShareUtils.instance.shareImage(
        key: globalKey,
        textSharing: '${dto.bankAccount} - ${dto.bankName}'.trim());
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(top: 70)),
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

  void backToHome(BuildContext context) {
    Provider.of<CreateQRProvider>(context, listen: false).reset();
    Provider.of<CreateQRPageSelectProvider>(context, listen: false)
        .updateIndex(0);
    Navigator.pop(context);
  }
}
