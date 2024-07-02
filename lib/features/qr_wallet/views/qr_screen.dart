// ignore_for_file: constant_identifier_names

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/features/qr_wallet/widgets/custom_textfield.dart';
import 'package:vierqr/features/qr_wallet/widgets/default_appbar_widget.dart';
import 'package:vierqr/features/qr_wallet/widgets/vcard_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';

enum TypeQr {
  VIETQR,
  QR_LINK,
  VCARD,
  OTHER,
}

class QrLinkScreen extends StatefulWidget {
  final TypeQr type;
  const QrLinkScreen({super.key, required this.type});

  @override
  State<QrLinkScreen> createState() => _QrLinkScreenState();
}

class _QrLinkScreenState extends State<QrLinkScreen> {
  TypeQr? _qrType;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController sdtController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController webController = TextEditingController();
  final TextEditingController ctyController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String _clipboardContent = '';
  String phone = '';

  bool _showAdditionalOptions = false;

  void _toggleAdditionalOptions() {
    setState(() {
      _showAdditionalOptions = !_showAdditionalOptions;
    });
  }

  @override
  void initState() {
    super.initState();
    _qrType = widget.type;
    _getClipboardContent();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        sdtController.addListener(
          () {
            if (phone.isNotEmpty) {
              sdtController.text = phone;
              updateState();
            }
          },
        );
      },
    );
    // _controller.addListener(_updateButtonState);
  }

  void _getClipboardContent() async {
    final clipboardContent = await FlutterClipboard.paste();
    setState(() {
      _clipboardContent = clipboardContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool _isButtonEnabled = false;
    Widget? widget;
    switch (_qrType) {
      case TypeQr.QR_LINK:
        widget = _buildQr();
        break;
      case TypeQr.VIETQR:
        widget = _buildQr();
        break;
      case TypeQr.VCARD:
        if (sdtController.text.isNotEmpty &&
            contactController.text.isNotEmpty) {
          _isButtonEnabled = true;
        } else {
          _isButtonEnabled = false;
        }
        widget = VcardWidget(
          sdtController: sdtController,
          addressController: addressController,
          webController: webController,
          contactController: contactController,
          ctyController: ctyController,
          emailController: emailController,
          isShow: _showAdditionalOptions,
          onChangePhone: (value) {
            String formatText = StringUtils.instance.formatPhoneNumberVN(value);
            phone = formatText;
            setState(() {});
          },
          onToggle: _toggleAdditionalOptions,
          onClear: (type) {
            _controller.clear();
            switch (type) {
              case 1:
                sdtController.clear();
                setState(() {});
                break;
              case 2:
                contactController.clear();
                setState(() {});
                break;
              case 3:
                emailController.clear();
                setState(() {});
                break;
              case 4:
                webController.clear();
                setState(() {});
                break;
              case 5:
                ctyController.clear();
                setState(() {});
                break;
              case 6:
                addressController.clear();
                setState(() {});
                break;
              default:
            }
            // _updateButtonState();
          },
        );
        break;
      case TypeQr.OTHER:
        // widget = _buildVCard();
        break;
      default:
    }
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _bottomButton(_isButtonEnabled),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const DefaultAppbarWidget(),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: widget,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQr() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _qrType == TypeQr.QR_LINK
                  ? 'Nhập thông tin\ntạo mã QR Đường dẫn'
                  : 'Nhập thông tin\ntạo mã QR để lưu trữ',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColor.BLUE_TEXT.withOpacity(0.2),
                    ),
                    child: const XImage(
                        imagePath: 'assets/images/ic-scan-content.png'),
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColor.GREEN.withOpacity(0.2),
                    ),
                    child: const XImage(
                      fit: BoxFit.fitWidth,
                      width: 42,
                      height: 42,
                      imagePath: 'assets/images/ic-img-picker.png',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 30),
        Text(
          _qrType == TypeQr.QR_LINK ? 'URL*' : 'Thông tin mã QR*',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColor.GREY_DADADA,
                width: 1.0,
              ),
            ),
          ),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: _qrType == TypeQr.QR_LINK
                  ? 'Nhập thông tin đường dẫn tại đây'
                  : 'Nhập thông tin mã QR tại đây',
              hintStyle: const TextStyle(color: AppColor.GREY_TEXT),
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                      ),
                      onPressed: () {
                        _controller.clear();
                        // _updateButtonState();
                      },
                    )
                  : null,
            ),
            onChanged: (text) {
              // _updateButtonState();
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _controller.text = _clipboardContent;
            });
          },
          child: Container(
            width: 250,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(colors: [
                  AppColor.D8ECF8,
                  AppColor.FFEAD9,
                  AppColor.F5C9D1,
                ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: XImage(
                    imagePath: 'assets/images/ic-suggest.png',
                    width: 30,
                  ),
                ),
                Expanded(
                  child: Text(
                    _clipboardContent,
                    maxLines: 1,
                    style: const TextStyle(
                      color: AppColor.BLACK,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomButton(bool isEnable) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   border: Border(
      //     top: BorderSide(color: Colors.grey, width: 0.5),
      //   ),
      // ),
      child: GestureDetector(
        onTap: isEnable ? () {} : null,
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: isEnable
                ? const LinearGradient(
                    colors: [
                      Color(0xFF00C6FF),
                      Color(0xFF0072FF),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: isEnable ? null : const Color(0xFFF0F4FA),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColor.TRANSPARENT,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Tiếp tục',
                    style: TextStyle(
                      color: isEnable ? AppColor.WHITE : AppColor.BLACK,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.arrow_forward,
                  color: isEnable ? AppColor.WHITE : AppColor.BLACK,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateState() {
    setState(() {});
  }
}
