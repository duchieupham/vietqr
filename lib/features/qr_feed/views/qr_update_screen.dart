import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/input_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/add_bank/views/bank_input_widget.dart';
import 'package:vierqr/features/qr_feed/widgets/custom_textfield.dart';
import 'package:vierqr/features/qr_feed/widgets/default_appbar_widget.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class QrUpdateScreen extends StatefulWidget {
  const QrUpdateScreen({super.key});

  @override
  State<QrUpdateScreen> createState() => _QrUpdateScreenState();
}

class _QrUpdateScreenState extends State<QrUpdateScreen> {
  final TextEditingController phoneNum = TextEditingController();
  final TextEditingController contactName = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController webController = TextEditingController();
  final TextEditingController ctyController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController userBankName = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController stk = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  bool _showAdditionalOptions = false;
  bool _showAdditional = false;
  BankTypeDTO? selectedBank;
  int _charCount = 0;

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

  void _toggleAdditional() {
    setState(() {
      _showAdditional = !_showAdditional;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: _bottomButton(true),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const DefaultAppbarWidget(),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: _buildBankQr(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBankQr() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cập nhật thông tin\nmã VietQR',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        const Text(
          'Ngân hàng*',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        InkWell(
          onTap: () {
            // if (state.listBanks != null) {
            //   onSelectBankType(state.listBanks!);
            // }
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
                            fontSize: 15, color: AppColor.BLACK),
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
          // focusNode: focusAccount,
          textInputType: TextInputType.number,
          inputFormatter: [FilteringTextInputFormatter.digitsOnly],
          isActive: selectedBank != null,
          controller: stk,
          hintText: selectedBank != null
              ? 'Nhập số tài khoản ngân hàng'
              : 'Vui lòng chọn ngân hàng',
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
          textInputType: TextInputType.name,
          inputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            UpperCaseTextFormatter()
          ],
          isActive: selectedBank != null,
          controller: userBankName,
          hintText: selectedBank != null
              ? 'Nhập tên chủ tài khoản ngân hàng'
              : 'Vui lòng chọn ngân hàng',
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
        // if (selectedBank != null)

        GestureDetector(
          onTap: _toggleAdditional,
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
                  _showAdditional
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColor.BLUE_TEXT,
                  size: 15,
                ),
                const SizedBox(width: 10),
                Text(
                  _showAdditional ? 'Đóng tuỳ chọn' : 'Tuỳ chọn thêm',
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
          visible: _showAdditional,
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\s]')),
                        ],
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
                                    _updateCharCount(contentController.text);
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
  }

  Widget _buildVCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cập nhật thông tin\nmã QR VCard',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        CustomTextField(
          // focusNode: focusAccount,
          textInputType: TextInputType.number,
          inputFormatter: [FilteringTextInputFormatter.digitsOnly],
          isActive: true,
          controller: phoneNum,
          hintText: 'Vui lòng nhập số điện thoại',
          labelText: 'Số điện thoại*',
          onClear: () {
            phoneNum.clear();
            updateState();
          },
          onChanged: (text) {
            updateState();
          },
        ),
        const SizedBox(height: 30),
        CustomTextField(
          // focusNode: focusAccount,
          textInputType: TextInputType.name,
          // inputFormatter: [FilteringTextInputFormatter.digitsOnly],
          isActive: true,
          controller: contactName,
          hintText: 'Vui lòng nhập tên danh bạ',
          labelText: 'Tên danh bạ*',
          onClear: () {
            contactName.clear();
            updateState();
          },
          onChanged: (text) {
            updateState();
          },
        ),
        const SizedBox(height: 30),
        GestureDetector(
          onTap: _toggleAdditionalOptions,
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
                  _showAdditionalOptions
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColor.BLUE_TEXT,
                  size: 15,
                ),
                const SizedBox(width: 10),
                Text(
                  _showAdditionalOptions ? 'Đóng tuỳ chọn' : 'Tuỳ chọn thêm',
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
          visible: _showAdditionalOptions,
          child: Column(
            children: [
              const SizedBox(height: 30),
              CustomTextField(
                textInputType: TextInputType.emailAddress,
                inputFormatter: [
                  EmailInputFormatter(),
                ],
                isActive: true,
                controller: emailController,
                hintText: 'Nhập thông tin email',
                labelText: 'Email',
                onClear: () {
                  emailController.clear();
                  updateState();
                },
                onChanged: (text) {},
              ),
              const SizedBox(height: 30),
              CustomTextField(
                isActive: true,
                controller: webController,
                textInputType: TextInputType.url,
                inputFormatter: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z\s0-9:/?&.=_-]'))
                ],
                hintText: 'Nhập thông tin website',
                labelText: 'Website',
                onClear: () {
                  webController.clear();
                  updateState();
                },
                onChanged: (text) {
                  // onChange(text);
                },
              ),
              const SizedBox(height: 30),
              CustomTextField(
                isActive: true,
                controller: ctyController,
                textInputType: TextInputType.name,
                inputFormatter: [VietnameseNameInputFormatter()],
                hintText: 'Nhập tên công ty',
                labelText: 'Tên công ty',
                onClear: () {
                  // onClear(5);
                  ctyController.clear();
                  updateState();
                },
                onChanged: (text) {
                  // onChange(text);
                },
              ),
              const SizedBox(height: 30),
              CustomTextField(
                isActive: true,
                textInputType: TextInputType.streetAddress,
                inputFormatter: [VietnameseNameInputFormatter()],
                controller: addressController,
                hintText: 'Nhập thông tin địa chỉ',
                labelText: 'Địa chỉ',
                onClear: () {
                  addressController.clear();
                  updateState();
                },
                onChanged: (text) {
                  // onChange(text);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildQr() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             _qrType == TypeQr.QR_LINK
  //                 ? 'Nhập thông tin\ntạo mã QR Đường dẫn'
  //                 : 'Nhập thông tin\ntạo mã QR để lưu trữ',
  //             style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //           ),
  //           Row(
  //             children: [
  //               InkWell(
  //                 onTap: () {},
  //                 child: Container(
  //                   padding: const EdgeInsets.all(4),
  //                   height: 42,
  //                   width: 42,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(100),
  //                     color: AppColor.BLUE_TEXT.withOpacity(0.2),
  //                   ),
  //                   child: const XImage(
  //                       imagePath: 'assets/images/ic-scan-content.png'),
  //                 ),
  //               ),
  //               const SizedBox(width: 4),
  //               InkWell(
  //                 onTap: () {},
  //                 child: Container(
  //                   padding: const EdgeInsets.all(13),
  //                   height: 42,
  //                   width: 42,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(100),
  //                     color: AppColor.GREEN.withOpacity(0.2),
  //                   ),
  //                   child: const XImage(
  //                     fit: BoxFit.fitWidth,
  //                     width: 42,
  //                     height: 42,
  //                     imagePath: 'assets/images/ic-img-picker.png',
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 30),
  //       CustomTextField(
  //         isActive: true,
  //         textInputType: _qrType == TypeQr.QR_LINK
  //             ? TextInputType.url
  //             : TextInputType.text,
  //         inputFormatter: [
  //           if (_qrType == TypeQr.QR_LINK)
  //             FilteringTextInputFormatter.allow(
  //                 RegExp(r'[a-zA-Z\s0-9:/?&.=_-]'))
  //           else
  //             FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s0-9]')),
  //         ],
  //         onChanged: (value) {
  //           if (value.contains('http') || value.contains('https')) {
  //             _qrType = TypeQr.QR_LINK;
  //           } else {
  //             _qrType = TypeQr.OTHER;
  //           }
  //           updateState();
  //         },
  //         onClear: () {
  //           _controller.clear();
  //           updateState();
  //         },
  //         labelText: _qrType == TypeQr.QR_LINK ? 'URL*' : 'Thông tin mã QR*',
  //         controller: _controller,
  //         hintText: _qrType == TypeQr.QR_LINK
  //             ? 'Nhập thông tin đường dẫn tại đây'
  //             : 'Nhập thông tin mã QR tại đây',
  //       ),
  //       _clipboardContent.isNotEmpty
  //           ? InkWell(
  //               onTap: () {
  //                 // final RegExp regExp =
  //                 //     RegExp(r'[ ()_\-=\[\];’:"{}<>?,./!@#$%^&*\\]');
  //                 // String replaceText = _clipboardContent.replaceAll(regExp, '');

  //                 _controller.text = _clipboardContent;
  //                 // const urlPattern = r'^(https?|ftp)://[^\s/$.?#].[^\s]*S';
  //                 // final regex = RegExp(urlPattern);
  //                 if (_clipboardContent.contains('http') ||
  //                     _clipboardContent.contains('https')) {
  //                   _qrType = TypeQr.QR_LINK;
  //                 } else {
  //                   _qrType = TypeQr.OTHER;
  //                 }
  //                 updateState();
  //               },
  //               child: Container(
  //                 width: 250,
  //                 margin: const EdgeInsets.only(top: 10),
  //                 padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(20),
  //                     gradient: const LinearGradient(colors: [
  //                       AppColor.D8ECF8,
  //                       AppColor.FFEAD9,
  //                       AppColor.F5C9D1,
  //                     ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
  //                 child: Row(
  //                   children: [
  //                     const Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 8),
  //                       child: XImage(
  //                         imagePath: 'assets/images/ic-suggest.png',
  //                         width: 30,
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: Text(
  //                         _clipboardContent,
  //                         maxLines: 1,
  //                         overflow: TextOverflow.ellipsis,
  //                         style: const TextStyle(
  //                           color: AppColor.BLACK,
  //                           fontSize: 12,
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             )
  //           : const SizedBox.shrink(),
  //     ],
  //   );
  // }

  Widget _bottomButton(bool isEnable) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: () {},
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
                    'Cập nhật',
                    style: TextStyle(
                      color: isEnable ? AppColor.WHITE : AppColor.BLACK,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.arrow_forward,
                  size: 20,
                  color: AppColor.TRANSPARENT,
                ),
              ),
            ],
          ),
        ),
      ),
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

  void updateState() {
    setState(() {});
  }
}
