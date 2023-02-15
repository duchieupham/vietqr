import 'dart:ui';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr_widget.dart';
import 'package:vierqr/features/generate_qr/views/create_qr.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/viet_qr_generate_dto.dart';
import 'package:vierqr/services/providers/create_qr_page_select_provider.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QRGenerated extends StatelessWidget {
  final VietQRGenerateDTO vietQRGenerateDTO;
  final BankAccountDTO bankAccountDTO;
  final String content;

  const QRGenerated({
    Key? key,
    required this.bankAccountDTO,
    required this.vietQRGenerateDTO,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey key = GlobalKey();
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-qr.png'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Column(children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 65,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 25,
                  sigmaY: 25,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor.withOpacity(0.6),
                  ),
                  child: SubHeader(
                    title: 'QR giao dịch',
                    function: () {
                      backToHome(context);
                    },
                  ),
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 50)),
          Expanded(
            child: VietQRWidget(
              width: width - 50,
              qrGeneratedDTO: const QRGeneratedDTO(
                bankCode: '',
                bankName: '',
                bankAccount: '',
                userBankName: '',
                amount: '',
                content: '',
                qrCode: '',
                imgId: '',
              ),
              content: content,
              isCopy: true,
              qrSize: width * 0.6,
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 50)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonIconWidget(
                width: width * 0.4,
                height: 50,
                borderRadius: 15,
                icon: Icons.home_rounded,
                alignment: Alignment.center,
                title: 'Trang chủ',
                function: () {
                  backToHome(context);
                },
                bgColor: DefaultTheme.GREEN,
                textColor: DefaultTheme.WHITE,
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              ButtonIconWidget(
                width: width * 0.4,
                height: 50,
                borderRadius: 15,
                icon: Icons.share_rounded,
                alignment: Alignment.center,
                title: 'Chia sẻ',
                function: () async {
                  await ShareUtils.instance.shareImage(
                    key: key,
                    textSharing: getTextSharing(),
                  );
                },
                bgColor: DefaultTheme.GREEN,
                textColor: DefaultTheme.WHITE,
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          ButtonIconWidget(
            width: width * 0.8 + 10,
            height: 50,
            borderRadius: 15,
            icon: Icons.refresh_rounded,
            alignment: Alignment.center,
            title: 'Tạo lại mã QR',
            function: () {
              Provider.of<CreateQRProvider>(context, listen: false).reset();
              Provider.of<CreateQRPageSelectProvider>(context, listen: false)
                  .updateIndex(0);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => CreateQR(
                    bankAccountDTO: bankAccountDTO,
                  ),
                ),
              );
            },
            bgColor: Theme.of(context).canvasColor,
            textColor: DefaultTheme.GREEN,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
        ]),
      ),
    );
  }

  void backToHome(BuildContext context) {
    Provider.of<CreateQRProvider>(context, listen: false).reset();
    Provider.of<CreateQRPageSelectProvider>(context, listen: false)
        .updateIndex(0);
    Navigator.pop(context);
  }

  String getTextSharing() {
    String result = '';
    if (vietQRGenerateDTO.transactionAmountValue != '' &&
        vietQRGenerateDTO.transactionAmountValue != '0') {
      if (content != '') {
        result =
            '${bankAccountDTO.bankAccount} - ${bankAccountDTO.bankName}\nSố tiền: ${vietQRGenerateDTO.transactionAmountValue}\nNội dung: $content';
      } else {
        result =
            '${bankAccountDTO.bankAccount} - ${bankAccountDTO.bankName}\nSố tiền: ${vietQRGenerateDTO.transactionAmountValue}';
      }
    } else {
      if (content != '') {
        result =
            '${bankAccountDTO.bankAccount} - ${bankAccountDTO.bankName}\nNội dung: $content';
      } else {
        result = '${bankAccountDTO.bankAccount} - ${bankAccountDTO.bankName}';
      }
    }
    return result.trim();
  }
}
