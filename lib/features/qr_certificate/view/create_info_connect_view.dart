import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/input_utils.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/ecommerce_request_dto.dart';
import 'package:vierqr/models/store/data_filter.dart';

class CreateInfoConnectView extends StatefulWidget {
  final Function(bool) onInput;
  final Function(EcommerceRequest) onChange;
  final String qrCode;
  final bool hasInfo;
  final EcommerceRequest ecom;
  const CreateInfoConnectView(
      {super.key,
      required this.onInput,
      required this.onChange,
      required this.ecom,
      this.hasInfo = false,
      required this.qrCode});

  @override
  State<CreateInfoConnectView> createState() => _CreateInfoConnectViewState();
}

class _CreateInfoConnectViewState extends State<CreateInfoConnectView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final TextEditingController merchantController = TextEditingController();
  final TextEditingController merchantShortController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController webhookController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController careerController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();

  ValueNotifier<bool> merchantClearNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> merchantShortClearNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> websiteClearNotifiter = ValueNotifier<bool>(false);
  ValueNotifier<bool> webhookClearNotifiter = ValueNotifier<bool>(false);
  ValueNotifier<bool> nationalIdClearNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> addressClearNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> careerClearNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> emailClearNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> phoneNoClearNotifier = ValueNotifier<bool>(false);

  final FocusNode focusNode = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNodeWebsite = FocusNode();
  final FocusNode focusNodeWebhook = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();
  final FocusNode focusNode6 = FocusNode();
  final FocusNode focusNode7 = FocusNode();

  List<DataFilter> get listMerchantType => const [
        DataFilter(id: 0, name: 'Cá nhân'),
        DataFilter(id: 1, name: 'Doanh nghiệp'),
      ];

  DataFilter selectType = const DataFilter(id: 0, name: 'Cá nhân');
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    merchantController.text = widget.ecom.fullName;
    merchantShortController.text = widget.ecom.name;
    nationalIdController.text = widget.ecom.nationalId;
    addressController.text = widget.ecom.address;
    careerController.text = widget.ecom.career;
    emailController.text = widget.ecom.email;
    phoneNoController.text = widget.ecom.phoneNo;
    websiteController.text = widget.ecom.website;
    webhookController.text = widget.ecom.webhook;

    isOpen = widget.hasInfo;
    merchantClearNotifier.value = widget.hasInfo;
    merchantShortClearNotifier.value = widget.hasInfo;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const ClampingScrollPhysics(),
      children: [
        const SizedBox(height: 25),
        ShaderMask(
            shaderCallback: (bounds) =>
                VietQRTheme.gradientColor.brightBlueLinear.createShader(bounds),
            child: const Text(
              'Kết nối đại lý',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.WHITE),
            )),
        _buildItem(
            title: 'Tên đại lý',
            hintText: 'Nhập tên đại lý',
            controller: merchantController,
            notifier: merchantClearNotifier,
            focus: focusNode,
            inputFormatter: [VietnameseNameLongTextInputFormatter()]),
        _buildItem(
            title: 'Tên đại lý rút gọn',
            hintText: 'Nhập tên rút gọn',
            controller: merchantShortController,
            notifier: merchantShortClearNotifier,
            focus: focusNode2,
            inputFormatter: [VietnameseNameInputFormatter()]),
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Loại hình doanh nghiệp',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: listMerchantType
                      .map(
                        (e) => _buildButton(
                            isSelect: selectType.id == e.id, filter: e),
                      )
                      .toList(),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 35),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isOpen = !isOpen;
                });
                isOpen ? _controller.forward() : _controller.reverse();
                widget.onChange(EcommerceRequest(
                  fullName: merchantController.text,
                  name: merchantShortController.text,
                  address: isOpen ? addressController.text : '',
                  businessType: selectType.id,
                  career: isOpen ? careerController.text : '',
                  certificate: widget.qrCode,
                  email: isOpen ? emailController.text : '',
                  nationalId: isOpen ? nationalIdController.text : '',
                  website: isOpen ? websiteController.text : '',
                  webhook: isOpen ? webhookController.text : '',
                  phoneNo:
                      isOpen ? phoneNoController.text.replaceAll(' ', '') : '',
                ));
              },
              child: Container(
                height: 35,
                width: 150,
                decoration: BoxDecoration(
                  gradient: VietQRTheme.gradientColor.lilyLinear,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, anim) => RotationTransition(
                              turns: child.key == const ValueKey('icon1')
                                  ? Tween<double>(begin: 1, end: 0.5)
                                      .animate(anim)
                                  : Tween<double>(begin: 0.5, end: 1)
                                      .animate(anim),
                              child:
                                  FadeTransition(opacity: anim, child: child),
                            ),
                        child: isOpen
                            ? const Icon(Icons.keyboard_arrow_down_rounded,
                                color: AppColor.BLUE_TEXT,
                                key: ValueKey('icon1'))
                            : const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColor.BLUE_TEXT,
                                key: ValueKey('icon2'),
                              )),
                    const SizedBox(width: 4),
                    Text(
                      isOpen ? 'Đóng tùy chọn' : 'Tuỳ chọn thêm',
                      style: const TextStyle(
                          fontSize: 12, color: AppColor.BLUE_TEXT),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 35),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isOpen ? 680 : 0,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildItem(
                        title: 'Website*',
                        hintText: 'Nhập webiste',
                        controller: websiteController,
                        notifier: websiteClearNotifiter,
                        focus: focusNodeWebsite,
                        inputFormatter: [WebsiteTextInputFormatter()]),
                    _buildItem(
                        title: 'Webhook*',
                        hintText: '',
                        controller: webhookController,
                        notifier: webhookClearNotifiter,
                        focus: focusNodeWebhook,
                        inputFormatter: [WebhookTextInputFormatter()]),
                    _buildItem(
                        title: 'CCCD/CMND/ĐKKD*',
                        hintText: '',
                        controller: nationalIdController,
                        notifier: nationalIdClearNotifier,
                        focus: focusNode3,
                        inputFormatter: [NationalIdInputFormatter()]),
                    _buildItem(
                        title: 'Địa chỉ kinh doanh*',
                        hintText: '',
                        controller: addressController,
                        notifier: addressClearNotifier,
                        focus: focusNode4,
                        inputFormatter: [
                          VietnameseNameLongTextInputFormatter()
                        ]),
                    _buildItem(
                        title: 'Ngành nghề*',
                        hintText: '',
                        controller: careerController,
                        notifier: careerClearNotifier,
                        focus: focusNode5,
                        inputFormatter: [
                          VietnameseNameOnlyTextInputFormatter()
                        ]),
                    _buildItem(
                        title: 'Email*',
                        hintText: '',
                        controller: emailController,
                        notifier: emailClearNotifier,
                        focus: focusNode6,
                        inputFormatter: [EmailInputFormatter()]),
                    _buildItem(
                        title: 'SĐT liên hệ*',
                        hintText: '',
                        controller: phoneNoController,
                        notifier: phoneNoClearNotifier,
                        focus: focusNode7,
                        inputFormatter: [
                          PhoneInputFormatter(
                              allowEndlessPhone: false,
                              defaultCountryCode: 'VN',
                              shouldCorrectNumber: false)
                        ]),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildButton({
    required bool isSelect,
    required DataFilter filter,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          selectType = filter;
        });
        widget.onChange(EcommerceRequest(
          fullName: merchantController.text,
          name: merchantShortController.text,
          address: isOpen ? addressController.text : '',
          businessType: selectType.id,
          career: isOpen ? careerController.text : '',
          certificate: widget.qrCode,
          email: isOpen ? emailController.text : '',
          nationalId: isOpen ? nationalIdController.text : '',
          website: isOpen ? websiteController.text : '',
          webhook: isOpen ? webhookController.text : '',
          phoneNo: isOpen ? phoneNoController.text.replaceAll(' ', '') : '',
        ));
      },
      child: Row(
        children: [
          Container(
            height: 22,
            width: 22,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              gradient: isSelect
                  ? VietQRTheme.gradientColor.brightBlueLinear
                  : VietQRTheme.gradientColor.disableButtonLinear,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Container(
              height: 20,
              width: 20,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: isSelect
                      ? VietQRTheme.gradientColor.brightBlueLinear
                      : VietQRTheme.gradientColor.disableButtonLinear,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            filter.name,
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildItem(
      {required String title,
      required String hintText,
      required TextEditingController controller,
      required FocusNode focus,
      required ValueNotifier<bool> notifier,
      List<TextInputFormatter>? inputFormatter}) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (context, isClear, child) {
        return Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: title == 'Tên đại lý'
                    ? merchantShortClearNotifier
                    : merchantClearNotifier,
                builder: (context, hasInput, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: MTextFieldCustom(
                      focusNode: focus,
                      controller: controller,
                      contentPadding: EdgeInsets.zero,
                      enable: true,
                      hintText: hintText,
                      keyboardAction: TextInputAction.next,
                      onChange: (value) {
                        notifier.value = value.isNotEmpty;
                        widget.onInput(value.isNotEmpty && hasInput);
                        widget.onChange(EcommerceRequest(
                          fullName: merchantController.text,
                          name: merchantShortController.text,
                          businessType: selectType.id,
                          career: isOpen ? careerController.text : '',
                          certificate: widget.qrCode,
                          email: isOpen ? emailController.text : '',
                          nationalId: isOpen ? nationalIdController.text : '',
                          website: isOpen ? websiteController.text : '',
                          webhook: isOpen ? webhookController.text : '',
                          phoneNo: isOpen
                              ? phoneNoController.text.replaceAll(' ', '')
                              : '',
                        ));
                      },
                      inputFormatter: inputFormatter,
                      inputType: TextInputType.text,
                      isObscureText: false,
                      focusBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor.BLUE_TEXT.withOpacity(0.8))),
                      suffixIcon: isClear
                          ? InkWell(
                              onTap: () {
                                controller.clear();
                                notifier.value = false;
                                focus.requestFocus();
                                if (title == 'Tên đại lý' ||
                                    title == 'Tên đại lý rút gọn') {
                                  widget.onInput(false);
                                }
                                widget.onChange(EcommerceRequest(
                                  fullName: merchantController.text,
                                  name: merchantShortController.text,
                                  website:
                                      !isOpen ? websiteController.text : '',
                                  webhook:
                                      !isOpen ? webhookController.text : '',
                                  address:
                                      !isOpen ? addressController.text : '',
                                  businessType: selectType.id,
                                  career: !isOpen ? careerController.text : '',
                                  certificate: widget.qrCode,
                                  email: !isOpen ? emailController.text : '',
                                  nationalId:
                                      !isOpen ? nationalIdController.text : '',
                                  phoneNo: !isOpen
                                      ? phoneNoController.text
                                          .replaceAll(' ', '')
                                      : '',
                                ));
                              },
                              child: const Icon(
                                Icons.close,
                                color: AppColor.GREY_TEXT,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
