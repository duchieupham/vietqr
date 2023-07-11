import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/viet_qr_utils.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/viet_qr_generate_dto.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRStatisticWidget extends StatelessWidget {
  final BankAccountDTO bankAccountDTO;
  final bool? isWeb;
  final bool? isExpanded;

  const QRStatisticWidget({
    Key? key,
    required this.bankAccountDTO,
    this.isWeb,
    this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VietQRGenerateDTO dto = VietQRGenerateDTO(
      cAIValue: VietQRUtils.instance.generateCAIValue(
          bankAccountDTO.bankCode, bankAccountDTO.bankAccount),
      transactionAmountValue: '',
      additionalDataFieldTemplateValue: '',
    );
    String qrCode =
        VietQRUtils.instance.generateVietQRWithoutTransactionAmount(dto);
    double width = MediaQuery.of(context).size.width;
    return (isWeb != null && isWeb!)
        ? UnconstrainedBox(
            child: Container(
              width: (isExpanded != null && isExpanded!) ? 300 : 250,
              height: (isExpanded != null && isExpanded!) ? 400 : 250 * 4 / 3,
              decoration: BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(15),
              ),
              // child: SingleChildScrollView(
              //   padding: const EdgeInsets.all(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: (isExpanded != null && isExpanded!) ? 100 : 75,
                    height: 50,
                    child: Image.asset('assets/images/ic-viet-qr.png'),
                  ),
                  Container(
                    // padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      border: Border.all(
                        color: AppColor.GREY_TEXT,
                        width: 0.5,
                      ),
                    ),
                    child: QrImage(
                      data: qrCode,
                      version: QrVersions.auto,
                      size: (isExpanded != null && isExpanded!) ? 200 : 150,
                      embeddedImage: const AssetImage(
                          'assets/images/ic-viet-qr-small.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: (isExpanded != null && isExpanded!)
                            ? const Size(40, 40)
                            : const Size(20, 20),
                      ),
                      backgroundColor: AppColor.WHITE,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 65,
                        height: 30,
                        child: Image.asset('assets/images/ic-napas247.png'),
                      ),
                      Container(
                        width: 0.5,
                        height: 30,
                        color: AppColor.GREY_TOP_TAB_BAR,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      SizedBox(
                        width: 65,
                        height: 30,
                        child: Image.asset('assets/images/ic-napas247.png'),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                  ),
                  Text(
                    'Tên chủ TK: ${bankAccountDTO.bankName.toUpperCase()}',
                    style: const TextStyle(
                      color: AppColor.BLUE_TEXT,
                      fontSize: 13,
                    ),
                  ),
                  //Số tài khoản
                  Text(
                    // 'Số TK: ${BankInformationUtil.instance.hideBankAccount(bankAccountDTO.bankAccount)}',
                    'Số TK: ${bankAccountDTO.bankAccount}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.BLUE_TEXT,
                      fontSize: 13,
                    ),
                  ),
                  //Tên ngân hàng
                  Text(
                    bankAccountDTO.bankName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColor.BLUE_TEXT,
                      fontSize: 12,
                    ),
                  ),
                ],
                //   ),
              ),
            ),
          )
        : UnconstrainedBox(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              width: width - 60,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    child: Image.asset('assets/images/ic-viet-qr.png'),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 5)),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.WHITE,
                      border: Border.all(
                        color: AppColor.GREY_TEXT,
                        width: 0.5,
                      ),
                    ),
                    child: QrImage(
                      data: qrCode,
                      version: QrVersions.auto,
                      size: 200,
                      embeddedImage: const AssetImage(
                          'assets/images/ic-viet-qr-small.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: const Size(30, 30),
                      ),
                      backgroundColor: AppColor.WHITE,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 65,
                        height: 30,
                        child: Image.asset('assets/images/ic-napas247.png'),
                      ),
                      Container(
                        width: 0.5,
                        height: 30,
                        color: AppColor.GREY_TOP_TAB_BAR,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      SizedBox(
                        width: 65,
                        height: 30,
                        child: Image.asset('assets/images/ic-napas247.png'),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                  ),
                  Text(
                    'Tên chủ TK: ${bankAccountDTO.bankName.toUpperCase()}',
                    style: const TextStyle(
                      color: AppColor.BLUE_TEXT,
                      fontSize: 15,
                    ),
                  ),
                  //Số tài khoản
                  Text(
                    // 'Số TK: ${BankInformationUtil.instance.hideBankAccount(bankAccountDTO.bankAccount)}',
                    'Số TK: ${bankAccountDTO.bankAccount}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColor.BLUE_TEXT,
                      fontSize: 15,
                    ),
                  ),
                  //Tên ngân hàng
                  Text(
                    bankAccountDTO.bankName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColor.BLUE_TEXT,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
