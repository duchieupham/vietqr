import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/account/repositories/account_res.dart';
import 'package:vierqr/features/account/views/dialog_nfc.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/card_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class VietQRIDCardView extends StatefulWidget {
  @override
  State<VietQRIDCardView> createState() => _VietQRIDCardViewState();
}

class _VietQRIDCardViewState extends State<VietQRIDCardView> {
  final repository = AccountRepository();
  CardDTO? cardDTO;

  String get userId => UserInformationHelper.instance.getUserId();

  //CARD: RFID
  //NFC_CARD: NFC
  static String cardType = 'CARD';
  static String nfcType = 'NFC_CARD';
  static String cardScanFirst = 'Quét lần 1';
  static String cardScanTwo = 'Quét lần 2';

  String type = '';
  int pageIndex = 0;

  String cardTitle = 'RFID';
  String cardScan = '';
  String cardNumber = '';

  String errorDialog = '';
  String errorText = '';

  @override
  void initState() {
    super.initState();
    getCard();
  }

  void getCard() async {
    final data = await repository.getCardID(userId);
    cardDTO = data;
    setState(() {});
  }

  void updateCard({bool isUnLink = false}) async {
    final data = await repository.updateCardID(userId, cardNumber, type);
    if (data.status == Stringify.RESPONSE_STATUS_SUCCESS) {
      setState(() {
        if (isUnLink) {
          pageIndex = 0;
          getCard();
        } else {
          pageIndex = 2;
        }
      });
    } else {
      setState(() {
        errorDialog = ErrorUtils.instance.getErrorMessage(data.message);
      });

      await showDialog(
        barrierDismissible: false,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return DialogNFC(
            msg: errorDialog,
            onTap: () {
              Navigator.pop(context);
              setState(() {
                errorDialog = '';
                pageIndex = 1;
                cardNumber = '';
              });
              onReadNFC();
            },
          );
        },
      );
    }
  }

  String readTagToKey(NfcTag tag, String userId) {
    String card = '';
    Object? tech;

    tech = FeliCa.from(tag);
    if (tech is FeliCa) {
      card =
          '${tech.currentIDm.toHexString()}-${tech.currentSystemCode.toHexString()}'
              .replaceAll(' ', '');
      return card;
    }

    tech = Iso15693.from(tag);
    if (tech is Iso15693) {
      card = '${tech.icSerialNumber.toHexString()}'.replaceAll(' ', '');
      return card;
    }

    tech = Iso7816.from(tag);
    if (tech is Iso7816) {
      card = '${tech.identifier.toHexString()}'.replaceAll(' ', '');
      return card;
    }

    tech = MiFare.from(tag);
    if (tech is MiFare) {
      return card;
    }
    tech = Ndef.from(tag);
    if (tech is Ndef) {
      return card;
    }

    return card;
  }

  NfcTag? tag;

  Map<String, dynamic>? additionalData;

  Future<Map<String, dynamic>?> handleTag(
      NfcTag tag, bool isScan, String? data) async {
    String card = readTagToKey(tag, userId);

    print('card: $card');

    if (data != null) {
      if (data == card) {
        cardNumber = card;
      }
    }

    if (isScan) {
      cardScan = '';
    } else {
      cardScan = cardScanTwo;
    }
    setState(() {});

    print('tag: ${tag.data.toString()}');

    return {
      'message': 'Hoàn tất.',
      'value': card,
    };
  }

  void onReadNFC({bool isScanSuccess = false, String? handle}) async {
    if (!(await NfcManager.instance.isAvailable())) {
      return DialogWidget.instance.openMsgDialog(
        title: 'Thông báo',
        msg: 'NFC có thể không được hỗ trợ hoặc có thể tạm thời bị tắt.',
        function: () {
          Navigator.pop(context);
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      );
    }

    await NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso14443,
        NfcPollingOption.iso15693,
      },
      onDiscovered: (tag) async {
        bool isCardFailed = false;

        try {
          final result = await handleTag(tag, isScanSuccess, handle);
          if (result == null) return;
          if (Platform.isAndroid) {
            await NfcManager.instance.stopSession();
          } else {
            await NfcManager.instance
                .stopSession(alertMessage: result['message']);
          }
          if (cardNumber.isNotEmpty) {
            updateCard();
          } else if (cardNumber.isEmpty && isScanSuccess) {
            setState(() {
              errorText = 'Thẻ không khớp, vui lòng quét lại';
              cardScan = cardScanTwo;
              isCardFailed = true;
            });
          }

          Future.delayed(const Duration(milliseconds: 3500), () {
            if (cardScan == cardScanTwo && !isCardFailed) {
              onReadNFC(isScanSuccess: true, handle: result['value']);
            }
          });
        } catch (e) {
          if (Platform.isAndroid) {
            await NfcManager.instance.stopSession();
          } else {
            await NfcManager.instance.stopSession(alertMessage: '');
          }
        }
      },
    ).catchError((e) {});
  }

  void onReadRFID({
    bool isScan = false,
    String? data,
  }) async {
    RawKeyboard.instance.addListener(
      (RawKeyEvent event) {
        bool isCardFailed = false;
        String card = event.character ?? '';
        if (data != null) {
          if (data == card) {
            setState(() {
              cardNumber = data;
            });
          }
        }

        if (isScan) {
          cardScan = '';
        } else {
          cardScan = cardScanTwo;
        }
        setState(() {});

        if (cardNumber.isNotEmpty) {
          updateCard();
        } else if (cardNumber.isEmpty && isScan) {
          setState(() {
            errorText = 'Thẻ không khớp, vui lòng quét lại';
            cardScan = cardScanTwo;
            isCardFailed = true;
          });
        }

        Future.delayed(const Duration(milliseconds: 500), () {
          if (cardScan == cardScanTwo && !isCardFailed) {
            onReadRFID(isScan: true, data: card);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        title: 'VietQR ID Card',
      ),
      body: (cardDTO == null)
          ? const SizedBox.shrink()
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/sem-contato.png',
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                  ),
                  if (pageIndex != 2)
                    Text(
                      'Giới thiệu về VietQR ID Card',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else
                    Text(
                      'Hoàn tất liên kết thẻ $cardTitle',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 12),
                  if (pageIndex == 0) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Liên kết thông tin VietQR ID của bạn với thẻ RFID hoặc thẻ NFC bằng cách đọc dữ liệu từ thẻ.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (cardDTO!.cardNumber.isEmpty &&
                        cardDTO!.cardNfcNumber.isEmpty)
                      _buildCardNotLink()
                    else if (cardDTO!.cardNumber.isNotEmpty &&
                        cardDTO!.cardNfcNumber.isNotEmpty)
                      _buildCardLink()
                    else if (cardDTO!.cardNumber.isNotEmpty &&
                        cardDTO!.cardNfcNumber.isEmpty)
                      _buildRFID()
                    else
                      _buildNFC(),
                    const SizedBox(height: 30),
                  ],
                  if (pageIndex == 1)
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Chạm thẻ vào thiết bị đọc $cardTitle để thực hiện liên kết',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          const Spacer(),
                          if (errorText.isEmpty)
                            Text(
                              cardScan,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: AppColor.grey979797,
                              ),
                            ),
                          if (errorText.isNotEmpty) ...[
                            Text(
                              errorText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColor.error700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            MButtonWidget(
                              title: 'Quét lại',
                              isEnable: true,
                              margin: EdgeInsets.zero,
                              onTap: () {
                                setState(() {
                                  pageIndex = 1;
                                  cardScan = cardScanFirst;
                                  errorText = '';
                                  cardNumber = '';
                                });
                                onReadNFC();
                              },
                            )
                          ],
                          const SizedBox(height: 35),
                        ],
                      ),
                    ),
                  if (pageIndex == 2) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Bạn có thể dùng thẻ $cardTitle để thực hiện đăng nhập vào hệ thống VietQR VN ngay bây giờ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    const Spacer(),
                    MButtonWidget(
                      title: 'Hoàn tất',
                      isEnable: true,
                      margin: EdgeInsets.zero,
                      onTap: () {
                        NavigatorUtils.navigateToRoot(context);
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildCardLink() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Thẻ RFID',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      'Đã liên kết',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColor.BLUE_TEXT,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            MButtonWidget(
              title: 'Huỷ liên kết',
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              isEnable: true,
              colorEnableBgr: AppColor.RED_EC1010.withOpacity(0.35),
              colorEnableText: AppColor.RED_EC1010,
              fontSize: 14,
              onTap: () {
                setState(() {
                  cardNumber = '';
                  type = cardType;
                });
                updateCard(isUnLink: true);
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Thẻ NFC',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      'Đã liên kết',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColor.BLUE_TEXT,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            MButtonWidget(
              title: 'Huỷ liên kết',
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              isEnable: true,
              colorEnableBgr: AppColor.RED_EC1010.withOpacity(0.35),
              colorEnableText: AppColor.RED_EC1010,
              fontSize: 14,
              onTap: () {
                setState(() {
                  cardNumber = '';
                  type = nfcType;
                });
                updateCard(isUnLink: true);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRFID() {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Thẻ RFID',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Đã liên kết',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColor.BLUE_TEXT,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              MButtonWidget(
                title: 'Huỷ liên kết',
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                isEnable: true,
                colorEnableBgr: AppColor.RED_EC1010.withOpacity(0.35),
                colorEnableText: AppColor.RED_EC1010,
                fontSize: 14,
                onTap: () {
                  setState(() {
                    cardNumber = '';
                    type = cardType;
                  });
                  updateCard(isUnLink: true);
                },
              ),
            ],
          ),
          const Spacer(),
          MButtonWidget(
            title: 'Thêm thẻ NFC',
            margin: EdgeInsets.zero,
            isEnable: true,
            colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.4),
            colorEnableText: AppColor.BLUE_TEXT,
            onTap: () {
              setState(() {
                pageIndex = 1;
                cardTitle = 'NFC';
                cardScan = cardScanFirst;
                type = nfcType;
              });
              onReadNFC();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNFC() {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Thẻ NFC',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Đã liên kết',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColor.BLUE_TEXT,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              MButtonWidget(
                title: 'Huỷ liên kết',
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                isEnable: true,
                colorEnableBgr: AppColor.RED_EC1010.withOpacity(0.35),
                colorEnableText: AppColor.RED_EC1010,
                fontSize: 14,
                onTap: () {
                  setState(() {
                    cardNumber = '';
                    type = nfcType;
                  });
                  updateCard(isUnLink: true);
                },
              ),
            ],
          ),
          const Spacer(),
          MButtonWidget(
            title: 'Thêm thẻ RFID',
            margin: EdgeInsets.zero,
            isEnable: true,
            colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.4),
            colorEnableText: AppColor.BLUE_TEXT,
            onTap: () {
              setState(() {
                pageIndex = 1;
                cardTitle = 'RFID';
                cardScan = cardScanFirst;
                type = cardType;
              });
              onReadRFID();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardNotLink() {
    return Column(
      children: [
        MButtonWidget(
          title: 'Thêm thẻ RFID',
          margin: EdgeInsets.zero,
          isEnable: true,
          colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.4),
          colorEnableText: AppColor.BLUE_TEXT,
          onTap: () {
            setState(() {
              pageIndex = 1;
              cardTitle = 'RFID';
              cardScan = cardScanFirst;
              type = cardType;
            });
            onReadRFID();
          },
        ),
        const SizedBox(height: 10),
        MButtonWidget(
          title: 'Thêm thẻ NFC',
          margin: EdgeInsets.zero,
          isEnable: true,
          colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.4),
          colorEnableText: AppColor.BLUE_TEXT,
          onTap: () async {
            setState(() {
              pageIndex = 1;
              cardTitle = 'NFC';
              cardScan = cardScanFirst;
              type = nfcType;
            });
            onReadNFC();
          },
        ),
      ],
    );
  }
}
