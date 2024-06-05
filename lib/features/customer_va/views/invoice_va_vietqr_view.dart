import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/features/customer_va/repositories/customer_va_repository.dart';
import 'package:vierqr/features/popup_bank/popup_bank_share.dart';
import 'package:vierqr/layouts/dashedline/horizontal_dashed_line.dart';
import 'package:vierqr/layouts/dashedline/vertical_dashed_line.dart';
import 'package:vierqr/models/invoice_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/vietqr_va_request_dto.dart';

class InvoiceVaVietQRView extends StatefulWidget {
  final VietQRVaRequestDTO vietQRVaRequestDTO;
  final InvoiceDTO invoiceDTO;

  const InvoiceVaVietQRView({
    super.key,
    required this.vietQRVaRequestDTO,
    required this.invoiceDTO,
  });

  @override
  State<StatefulWidget> createState() => _InvoiceVaVietQRView();
}

class _InvoiceVaVietQRView extends State<InvoiceVaVietQRView> {
  final CustomerVaRepository customerVaRepository =
      const CustomerVaRepository();
  PaletteGenerator? paletteGenerator;
  Color? _color;
  String _qr = '';

  @override
  void initState() {
    super.initState();
    _initialService();
    _generateVietQRVa(widget.vietQRVaRequestDTO);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    // final double qrLogoMidSize = width / Numeral.QR_LOGO_MIDDLE_SIZE_RATIO;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                // child: Text(
                //   'Mã VietQR thanh toán\nhoá đơn ${widget.vietQRVaRequestDTO.billId}',
                //   style: TextStyle(
                //     fontSize: 25,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Quét mã VietQR để\n',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: AppColor.BLACK,
                        ),
                      ),
                      TextSpan(
                        text: 'thanh toán ',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: AppColor.BLACK,
                        ),
                      ),
                      TextSpan(
                        text: CurrencyUtils.instance.getCurrencyFormatted(
                          widget.invoiceDTO.amount.toString(),
                        ),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: AppColor.ORANGE_DARK,
                        ),
                      ),
                      TextSpan(
                        text: ' VND',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: AppColor.ORANGE_DARK,
                        ),
                      ),
                      TextSpan(
                        text: '\ncho hoá đơn ',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: AppColor.BLACK,
                        ),
                      ),
                      TextSpan(
                        text: widget.invoiceDTO.billId,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColor.BLACK,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close_rounded,
                  color: AppColor.BLACK,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        (_qr.isNotEmpty)
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/bg-qr-vqr.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                padding: const EdgeInsets.all(25),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColor.WHITE,
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      QrImage(
                        data: _qr,
                        version: QrVersions.auto,
                        embeddedImage: const AssetImage(
                            'assets/images/ic-viet-qr-small.png'),
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: Size(
                            30,
                            30,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 35,
                              // margin: const EdgeInsets.only(right: 20),
                              child: Image.asset(
                                'assets/images/logo-bidv.png',
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 80,
                              height: 35,
                              child: Image.asset(
                                'assets/images/ic-napas247.png',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : (_qr.trim() == 'empty')
                ? const SizedBox()
                : Center(
                    child: SizedBox(
                      width: width,
                      height: width,
                      child: Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            color: AppColor.BLUE_TEXT,
                          ),
                        ),
                      ),
                    ),
                  ),
        const SizedBox(
          height: 20,
        ),
        Text(
          widget.vietQRVaRequestDTO.userBankName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
            width: 100,
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Divider(
              height: 1,
              color: Color(0XFF666A72),
            )),
        Text(
          widget.invoiceDTO.bankAccount.toString(),
          style: TextStyle(
            fontSize: 18,
            color: (_color != null) ? _color : AppColor.BLACK,
            // fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        SizedBox(
          child: Row(
            children: [
              ButtonWidget(
                width: width / 2 - 5 - 20,
                height: 40,
                borderRadius: 5,
                text: 'Lưu ảnh QR',
                textColor: AppColor.BLUE_TEXT,
                bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                function: () {
                  QRGeneratedDTO qrgeneratedDTO = QRGeneratedDTO(
                    bankCode: 'BIDV',
                    bankName: widget.invoiceDTO.userBankName ?? '',
                    bankAccount: widget.invoiceDTO.bankAccount ?? '',
                    userBankName: widget.invoiceDTO.userBankName ?? '',
                    amount: widget.invoiceDTO.amount.toString(),
                    content: widget.invoiceDTO.billId ?? '',
                    qrCode: _qr,
                    imgId: 'cb18c1b3-d661-4695-b2e8-dba8e887abd6',
                  );
                  NavigatorUtils.navigatePage(context,
                      PopupBankShare(dto: qrgeneratedDTO, type: TypeImage.SAVE),
                      routeName: PopupBankShare.routeName);
                },
              ),
              const Spacer(),
              ButtonWidget(
                width: width / 2 - 5 - 20,
                height: 40,
                borderRadius: 5,
                text: 'Chia sẻ QR',
                textColor: AppColor.BLUE_TEXT,
                bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                function: () {
                  QRGeneratedDTO qrgeneratedDTO = QRGeneratedDTO(
                    bankCode: 'BIDV',
                    bankName: widget.invoiceDTO.userBankName ?? '',
                    bankAccount: widget.invoiceDTO.bankAccount ?? '',
                    userBankName: widget.invoiceDTO.userBankName ?? '',
                    amount: widget.invoiceDTO.amount.toString(),
                    content: widget.invoiceDTO.billId ?? '',
                    imgId: 'cb18c1b3-d661-4695-b2e8-dba8e887abd6',
                    qrCode: _qr,
                  );
                  NavigatorUtils.navigatePage(
                      context,
                      PopupBankShare(
                          dto: qrgeneratedDTO, type: TypeImage.SHARE),
                      routeName: PopupBankShare.routeName);
                },
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
      ],
    );
  }

  void _initialService() async {
    AssetImage image = AssetImage('assets/images/logo-bidv.png');
    paletteGenerator = await PaletteGenerator.fromImageProvider(image);
    if (paletteGenerator != null && paletteGenerator!.dominantColor != null) {
      _color = paletteGenerator!.dominantColor!.color;
    }
  }

  void _generateVietQRVa(VietQRVaRequestDTO dto) async {
    ResponseMessageDTO result =
        await customerVaRepository.generateVietQRVa(dto);
    if (result.status == 'SUCCESS') {
      _qr = result.message;
      setState(() {});
    } else {
      _qr = 'empty';
    }
  }
}
