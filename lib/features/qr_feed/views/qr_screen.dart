// ignore_for_file: constant_identifier_names

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/add_bank/views/bank_input_widget.dart';
import 'package:vierqr/features/qr_feed/blocs/qr_feed_bloc.dart';
import 'package:vierqr/features/qr_feed/events/qr_feed_event.dart';
import 'package:vierqr/features/qr_feed/states/qr_feed_state.dart';
import 'package:vierqr/features/qr_feed/views/qr_style.dart';
import 'package:vierqr/features/qr_feed/widgets/custom_textfield.dart';

import 'package:vierqr/features/qr_feed/widgets/default_appbar_widget.dart';
import 'package:vierqr/features/qr_feed/widgets/vcard_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/qr_create_type_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

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
  String get userId => SharePrefUtils.getProfile().userId.trim();

  TypeQr? _qrType;
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _controller = TextEditingController();
  final TextEditingController sdtController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController webController = TextEditingController();
  final TextEditingController ctyController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController stk = TextEditingController();
  final TextEditingController userBankName = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  String _clipboardContent = '';
  String phone = '';

  bool _showAdditionalOptions = false;
  bool _isActiveTextField = false;
  bool _showAdditionalOptional = false;
  String contentBank = '';

  int _charCount = 0;

  double _keyboardHeight = 0;
  final QrFeedBloc _bloc = getIt.get<QrFeedBloc>();
  BankTypeDTO? selectedBank;

  void _updateCharCount(String text) {
    setState(() {
      _charCount = text.length;
    });
  }

  void _toggleAdditionalOptions() {
    setState(() {
      _showAdditionalOptions = !_showAdditionalOptions;
    });
  }

  void _toggleAdditionalOptional() {
    setState(() {
      _showAdditionalOptional = !_showAdditionalOptional;
    });
  }

  @override
  void initState() {
    super.initState();

    _qrType = widget.type;
    _getClipboardContent();
    initData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.clear();
    super.dispose();
  }

  void initData() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (_qrType == TypeQr.VIETQR) {
          _bloc.add(LoadBanksEvent());
        }
      },
    );
  }

  void _getClipboardContent() async {
    if (_qrType == TypeQr.OTHER || _qrType == TypeQr.QR_LINK) {
      final clipboardContent = await FlutterClipboard.paste();
      _clipboardContent = clipboardContent;
      updateState();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _isButtonEnabled = false;
    Widget? widget;
    switch (_qrType) {
      case TypeQr.QR_LINK:
        if (_controller.text.isNotEmpty) {
          _isButtonEnabled = true;
        } else {
          _isButtonEnabled = false;
        }
        widget = _buildQr();
        break;
      case TypeQr.VIETQR:
        if (stk.text.isNotEmpty &&
            userBankName.text.isNotEmpty &&
            selectedBank != null) {
          _isButtonEnabled = true;
        } else {
          _isButtonEnabled = false;
        }
        widget = _buildVietQr();
        break;
      case TypeQr.VCARD:
        if (phone.isNotEmpty && contactController.text.isNotEmpty) {
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
            sdtController.text = phone;
            updateState();
          },
          onChange: (value) {
            addressController;
            webController;
            contactController;
            ctyController;
            emailController;
            updateState();
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
        if (_controller.text.isNotEmpty) {
          _isButtonEnabled = true;
        } else {
          _isButtonEnabled = false;
        }
        widget = _buildQr();
        break;
      default:
    }
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _bottomButton(_isButtonEnabled),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        slivers: [
          const DefaultAppbarWidget(),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  widget!,
                  // SizedBox(height: _keyboardHeight),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVietQr() {
    return BlocConsumer<QrFeedBloc, QrFeedState>(
      bloc: _bloc,
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nhập thông tin\ntạo mã VietQR ',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
            const Text(
              'Ngân hàng*',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () {
                if (state.listBanks != null) {
                  onSelectBankType(state.listBanks!);
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColor.GREY_DADADA,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (selectedBank != null) ...[
                            Container(
                              width: 60,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: AppColor.GREY_DADADA),
                                image: DecorationImage(
                                  image: ImageUtils.instance
                                      .getImageNetWork(selectedBank!.imageId),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                          Text(
                            selectedBank != null
                                ? selectedBank!.bankShortName!
                                : 'Chọn ngân hàng thụ hưởng',
                            style: const TextStyle(
                                fontSize: 15, color: AppColor.GREY_TEXT),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColor.GREY_TEXT,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            CustomTextField(
              isActive: _isActiveTextField,
              controller: stk,
              hintText: 'Nhập số tài khoản ngân hàng',
              labelText: 'Số tài khoản*',
              onClear: () {
                stk.clear();
                updateState();
                // _updateButtonState();
              },
              onChanged: (text) {
                updateState();
                // _updateButtonState();
              },
            ),
            const SizedBox(height: 30),
            CustomTextField(
              isActive: _isActiveTextField,
              controller: userBankName,
              hintText: 'Nhập tên chủ tài khoản ngân hàng',
              labelText: 'Chủ tài khoản*',
              onClear: () {
                userBankName.clear();
                updateState();
              },
              onChanged: (text) {
                updateState();
                // _updateButtonState();
              },
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _toggleAdditionalOptional,
              child: Container(
                width: 150,
                height: 30,
                decoration: BoxDecoration(
                    gradient: VietQRTheme.gradientColor.scan_qr,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _showAdditionalOptional
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColor.BLUE_TEXT,
                      size: 15,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _showAdditionalOptional
                          ? 'Đóng tuỳ chọn'
                          : 'Tuỳ chọn thêm',
                      style: const TextStyle(
                        color: AppColor.BLUE_TEXT,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _showAdditionalOptional,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Số tiền',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: amount,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                                  final formattedText =
                                      StringUtils.formatCurrency(newValue.text);
                                  return newValue.copyWith(
                                    text: formattedText,
                                    selection: TextSelection.collapsed(
                                        offset: formattedText.length),
                                  );
                                },
                              ),
                            ],
                            decoration: InputDecoration(
                              hintText: 'Nhập số tiền chuyển khoản',
                              hintStyle: const TextStyle(color: Colors.grey),
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              suffixIcon: _controller.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                      ),
                                      onPressed: () {
                                        amount.clear();
                                        // _updateButtonState();
                                      },
                                    )
                                  : null,
                            ),
                            onChanged: (text) {
                              updateState();

                              // _updateButtonState();
                            },
                          ),
                        ),
                        const Text(
                          'VND',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Nội dung chuyển khoản ($_charCount/50)',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
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
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: contentController,
                            maxLength: 50,
                            decoration: InputDecoration(
                              hintText: 'Nhập nội dung chuyển khoản',
                              hintStyle: const TextStyle(color: Colors.grey),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              suffixIcon: contentController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                      ),
                                      onPressed: () {
                                        contentController.clear();
                                        updateState();
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              counterText: '',
                            ),
                            onChanged: _updateCharCount,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Nội dung không chứa dấu Tiếng Việt, không ký tự đặc biệt.',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void onSelectBankType(List<BankTypeDTO> list) async {
    final data = await DialogWidget.instance.showModelBottomSheet(
      context: context,
      padding: EdgeInsets.zero,
      widget: ModelBottomSheetView(
        tvTitle: 'Chọn ngân hàng thụ hưởng\nđể tạo mã VietQR',
        ctx: context,
        list: list ?? [],
        isSearch: true,
        data: selectedBank,
      ),
      height: MediaQuery.of(context).size.height * 0.6,
    );
    if (data is int) {
      selectedBank = list[data];
      updateState();
    }
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
        CustomTextField(
          onChanged: (value) {
            updateState();
          },
          onClear: () {
            _controller.clear();
            updateState();
          },
          labelText: _qrType == TypeQr.QR_LINK ? 'URL*' : 'Thông tin mã QR*',
          controller: _controller,
          hintText: _qrType == TypeQr.QR_LINK
              ? 'Nhập thông tin đường dẫn tại đây'
              : 'Nhập thông tin mã QR tại đây',
        ),
        _clipboardContent.isNotEmpty
            ? GestureDetector(
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
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _bottomButton(bool isEnable) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: isEnable
            ? () {
                switch (_qrType) {
                  case TypeQr.QR_LINK:
                    QrLink qrLink = QrLink(
                      userId: userId,
                      qrName: '',
                      qrDescription: '',
                      value: _controller.text,
                      pin: '',
                      isPublic: '',
                      style: '',
                      theme: '',
                    );

                    NavigatorUtils.navigatePage(
                        context,
                        QrStyle(
                          type: 0,
                          json: qrLink.toJson(),
                        ),
                        routeName: Routes.QR_STYLE);
                    break;
                  case TypeQr.OTHER:
                    QrOther other = QrOther(
                      userId: userId,
                      qrName: '',
                      qrDescription: '',
                      value: _controller.text,
                      pin: '',
                      isPublic: '',
                      style: '',
                      theme: '',
                    );

                    NavigatorUtils.navigatePage(
                        context,
                        QrStyle(
                          type: 1,
                          json: other.toJson(),
                        ),
                        routeName: Routes.QR_STYLE);
                    break;
                  case TypeQr.VCARD:
                    QrVCard vCard = QrVCard(
                        qrName: '',
                        qrDescription: '',
                        fullname: contactController.text,
                        phoneNo: sdtController.text,
                        email: emailController.text,
                        companyName: ctyController.text,
                        website: webController.text,
                        address: addressController.text,
                        userId: userId,
                        additionalData: '',
                        style: '',
                        theme: '',
                        isPublic: '');
                    NavigatorUtils.navigatePage(
                        context,
                        QrStyle(
                          type: 2,
                          json: vCard.toJson(),
                        ),
                        routeName: Routes.QR_STYLE);
                    break;
                  case TypeQr.VIETQR:
                    VietQr vietQr = VietQr(
                        userId: userId,
                        qrName: '',
                        qrDescription: '',
                        bankAccount: stk.text,
                        bankCode: selectedBank!.bankCode,
                        userBankName: userBankName.text,
                        amount: amount.text.replaceAll(',', ''),
                        content: contentController.text,
                        isPublic: '',
                        style: '',
                        theme: '');
                    NavigatorUtils.navigatePage(
                        context,
                        QrStyle(
                          type: 3,
                          json: vietQr.toJson(),
                        ),
                        routeName: Routes.QR_STYLE);
                    break;
                  default:
                }
              }
            : null,
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
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
                  size: 20,
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
                  size: 20,
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
