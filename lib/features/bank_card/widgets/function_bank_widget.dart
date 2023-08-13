import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/printer_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_detail/bank_card_detail_screen.dart';
import 'package:vierqr/features/business/blocs/business_information_bloc.dart';
import 'package:vierqr/features/printer/views/printing_view.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/providers/action_share_provider.dart';
import 'package:vierqr/services/providers/auth_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';
import 'package:vierqr/services/sqflite/local_database.dart';

class FunctionBankWidget extends StatelessWidget {
  final QRGeneratedDTO qrGeneratedDTO;
  final BankAccountDTO bankAccountDTO;
  final BusinessInformationBloc businessInformationBloc;

  const FunctionBankWidget({
    super.key,
    required this.qrGeneratedDTO,
    required this.bankAccountDTO,
    required this.businessInformationBloc,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width,
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonIconWidget(
                width: width * 0.2,
                height: 40,
                icon: Icons.print_rounded,
                title: '',
                function: () async {
                  Navigator.pop(context);
                  String userId = UserInformationHelper.instance.getUserId();
                  BluetoothPrinterDTO bluetoothPrinterDTO =
                      await LocalDatabase.instance.getBluetoothPrinter(userId);
                  if (bluetoothPrinterDTO.id.isNotEmpty) {
                    bool isPrinting = false;
                    if (!isPrinting) {
                      isPrinting = true;
                      DialogWidget.instance.showFullModalBottomContent(
                          widget: const PrintingView());
                      await PrinterUtils.instance
                          .print(qrGeneratedDTO)
                          .then((value) {
                        Navigator.pop(context);
                        isPrinting = false;
                      });
                    }
                  } else {
                    DialogWidget.instance.openMsgDialog(
                        title: 'Không thể in',
                        msg:
                            'Vui lòng kết nối với máy in để thực hiện việc in.');
                  }
                },
                bgColor: Theme.of(context).canvasColor,
                textColor: AppColor.ORANGE,
              ),
              ButtonIconWidget(
                width: width * 0.2,
                height: 40,
                icon: Icons.photo_rounded,
                title: '',
                function: () {
                  Navigator.pop(context);
                  Provider.of<AuthProvider>(context, listen: false)
                      .updateAction(false);
                  Navigator.pushNamed(
                    context,
                    Routes.QR_SHARE_VIEW,
                    arguments: {
                      'qrGeneratedDTO': qrGeneratedDTO,
                      'action': 'SAVE'
                    },
                  );
                },
                bgColor: Theme.of(context).canvasColor,
                textColor: AppColor.RED_CALENDAR,
              ),
              ButtonIconWidget(
                width: width * 0.2,
                height: 40,
                icon: Icons.copy_rounded,
                title: '',
                function: () async {
                  Navigator.pop(context);
                  await FlutterClipboard.copy(
                    ShareUtils.instance.getTextSharing(qrGeneratedDTO),
                  ).then(
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
                bgColor: Theme.of(context).canvasColor,
                textColor: AppColor.BLUE_TEXT,
              ),
              ButtonIconWidget(
                width: width * 0.2,
                height: 40,
                icon: Icons.share_rounded,
                title: '',
                function: () {
                  Navigator.pop(context);
                  Provider.of<AuthProvider>(context, listen: false)
                      .updateAction(false);
                  Navigator.pushNamed(
                    context,
                    Routes.QR_SHARE_VIEW,
                    arguments: {
                      'qrGeneratedDTO': qrGeneratedDTO,
                    },
                  );
                },
                bgColor: Theme.of(context).canvasColor,
                textColor: AppColor.GREEN,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        ButtonIconWidget(
          width: width,
          height: 40,
          icon: Icons.info_outline_rounded,
          title: 'Chi tiết',
          function: () async {
            Navigator.pop(context);
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    BankCardDetailScreen(bankId: bankAccountDTO.id),
                settings: const RouteSettings(
                  name: Routes.BANK_CARD_DETAIL_VEW,
                ),
              ),
            );
          },
          bgColor: Theme.of(context).canvasColor,
          textColor: Theme.of(context).hintColor,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        ButtonIconWidget(
          width: width,
          height: 40,
          icon: Icons.add_rounded,
          title: 'Tạo QR thanh toán',
          function: () {
            Navigator.pop(context);
            // Navigator.of(context)
            //     .push(
            //   MaterialPageRoute(
            //     builder: (context) => CreateQRScreen(
            //       bankAccountDTO: bankAccountDTO,
            //     ),
            //   ),
            // )
            //     .then((value) {
            //   String userId = UserInformationHelper.instance.getUserId();
            //   businessInformationBloc.add(
            //     BusinessInformationEventGetList(userId: userId),
            //   );
            // });
          },
          bgColor: Theme.of(context).canvasColor,
          textColor: Theme.of(context).hintColor,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        ButtonIconWidget(
          width: width,
          height: 40,
          icon: Icons.credit_card_rounded,
          title: 'Thêm TK ngân hàng',
          function: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, Routes.ADD_BANK_CARD);
          },
          bgColor: Theme.of(context).canvasColor,
          textColor: Theme.of(context).hintColor,
        ),
      ],
    );
  }
}
