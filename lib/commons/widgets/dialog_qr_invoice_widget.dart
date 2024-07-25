import 'package:flutter/material.dart';

import '../constants/configurations/theme.dart';

class DialogQrInvoiceDetailWidget extends StatefulWidget {
  const DialogQrInvoiceDetailWidget({super.key});

  @override
  State<DialogQrInvoiceDetailWidget> createState() =>
      _DialogQrInvoiceDetailWidgetState();
}

class _DialogQrInvoiceDetailWidgetState
    extends State<DialogQrInvoiceDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: const Color(0xFFFFFFFF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: const Color(0xFFFFFFFF),
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  IntrinsicHeight(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0x99000000),
                      ),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      width: double.infinity,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IntrinsicHeight(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColor.WHITE,
                                ),
                                padding:
                                    const EdgeInsets.only(top: 56),
                                margin: const EdgeInsets.only(top: 80),
                                width: double.infinity,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      IntrinsicHeight(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 40,
                                              left: 20,
                                              right: 20),
                                          width: double.infinity,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const IntrinsicHeight(
                                                  child: SizedBox(
                                                    width: 304,
                                                    child: Text(
                                                      'Quét mã VietQR để\nthanh toán 7,020,000 VND\ncho hoá đơn VAFXXXXXXXXXX',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 20),
                                                      child: const Icon(
                                                          Icons.close)),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      IntrinsicHeight(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 25, right: 25),
                                          margin: const EdgeInsets.only(
                                              bottom: 34,
                                              left: 30,
                                              right: 30),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: const DecorationImage(
                                                image: NetworkImage(
                                                    "https://i.imgur.com/1tMFzp8.png"),
                                                fit: BoxFit.cover),
                                          ),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 25),
                                                      height: 300,
                                                      width:
                                                          double.infinity,
                                                      child: Image.network(
                                                        'https://i.imgur.com/1tMFzp8.png',
                                                        fit: BoxFit.fill,
                                                      )),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 126,
                                            left: 74,
                                            right: 74),
                                        width: double.infinity,
                                        child: const Text(
                                          'Hoá đơn phí giao dịch\ntháng 02/2024',
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                      IntrinsicHeight(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          width: double.infinity,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IntrinsicHeight(
                                                  child: Container(
                                                    decoration:
                                                        BoxDecoration(
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xFF0A7AFF),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(5),
                                                      color:
                                                          const Color(0xFFFFFFFF),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                            vertical: 14),
                                                    width: 165,
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          12),
                                                              width: 14,
                                                              height: 11,
                                                              child: Image
                                                                  .network(
                                                                'https://i.imgur.com/1tMFzp8.png',
                                                                fit: BoxFit
                                                                    .fill,
                                                              )),
                                                          const IntrinsicHeight(
                                                            child: Text(
                                                              'Lưu ảnh QR',
                                                              style:
                                                                  TextStyle(
                                                                color: Color(
                                                                    0xFF0A7AFF),
                                                                fontSize:
                                                                    13,
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                  ),
                                                ),
                                                IntrinsicHeight(
                                                  child: Container(
                                                    decoration:
                                                        BoxDecoration(
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xFF0A7AFF),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(5),
                                                      color:
                                                          const Color(0xFFFFFFFF),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                            vertical: 14),
                                                    width: 165,
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          10),
                                                              width: 11,
                                                              height: 13,
                                                              child: Image
                                                                  .network(
                                                                'https://i.imgur.com/1tMFzp8.png',
                                                                fit: BoxFit
                                                                    .fill,
                                                              )),
                                                          const IntrinsicHeight(
                                                            child: Text(
                                                              'Chia sẻ mã QR',
                                                              style:
                                                                  TextStyle(
                                                                color: Color(
                                                                    0xFF0A7AFF),
                                                                fontSize:
                                                                    13,
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ]),
                    ),
                  ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
