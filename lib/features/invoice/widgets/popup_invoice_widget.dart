import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

import '../../../commons/utils/currency_utils.dart';

class PopupQrCreate extends StatelessWidget {
  final String totalAmount;
  final String billNumber;
  final String qr;
  final String invoiceName;
  final Function() onSave;
  final Function() onShare;

  const PopupQrCreate(
      {super.key,
      required this.totalAmount,
      required this.billNumber,
      required this.invoiceName,
      required this.onSave,
      required this.onShare,
      required this.qr});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 30),
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
      height: MediaQuery.of(context).size.height * 0.8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DefaultTextStyle(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
                child: Text(
                  'Quét mã VietQR để',
                ),
              ),
              Row(
                children: [
                  const DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                    child: Text(
                      'thanh toán',
                    ),
                  ),
                  DefaultTextStyle(
                    style: const TextStyle(
                      color: AppColor.ORANGE_DARK,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    child: Text(
                      ' ${CurrencyUtils.instance.getCurrencyFormatted(totalAmount)} VND',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                    child: Text(
                      'cho hoá đơn',
                    ),
                  ),
                  DefaultTextStyle(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    child: Text(
                      ' $billNumber',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('assets/images/bg-qr-vqr.png'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Container(
                    width: 280,
                    height: 300,
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                    decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 240,
                          height: 240,
                          // color: AppColor.GREY_DADADA,
                          child: QrImageView(
                            data: qr ?? '',
                            size: 220,
                            version: QrVersions.auto,
                            embeddedImage: const AssetImage(
                                'assets/images/ic-viet-qr-small.png'),
                            embeddedImageStyle: const QrEmbeddedImageStyle(
                              size: Size(30, 30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Image.asset(
                                  "assets/images/ic-viet-qr.png",
                                  height: 20,
                                ),
                              ),
                              Image.asset(
                                "assets/images/ic-napas247.png",
                                height: 30,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              DefaultTextStyle(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                child: Text(
                  invoiceName,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: onSave,
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.38,
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          decoration: BoxDecoration(
                              color: AppColor.WHITE,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: AppColor.BLUE_TEXT)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/ic-save-img-blue.png',
                                width: 25,
                                // height: 14,
                              ),
                              const SizedBox(width: 0),
                              const DefaultTextStyle(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColor.BLUE_TEXT,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                ),
                                child: Text(
                                  'Lưa ảnh QR',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onShare,
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.38,
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          decoration: BoxDecoration(
                              color: AppColor.WHITE,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: AppColor.BLUE_TEXT)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/ic-share-blue.png',
                                width: 25,
                                // height: 14,
                              ),
                              const SizedBox(width: 0),
                              const DefaultTextStyle(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColor.BLUE_TEXT,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                ),
                                child: Text(
                                  'Chia sẽ mã QR',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.close,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
