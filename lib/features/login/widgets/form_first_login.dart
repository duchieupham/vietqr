part of '../login_screen.dart';

class FormFirstLogin extends StatefulWidget {
  const FormFirstLogin(
      {super.key, required this.bloc, required this.onLoginCard});

  final LoginBloc bloc;
  final Function() onLoginCard;

  @override
  State<FormFirstLogin> createState() => _FormFirstLoginState();
}

class _FormFirstLoginState extends State<FormFirstLogin> {
  bool isVNSelected = true;
  final phoneNoController = TextEditingController();
  final ValueNotifier<bool> isEnableButton = ValueNotifier(false);
  final ValueNotifier<String?> errorPhone = ValueNotifier(null);

  String get getPhone => phoneNoController.text.trim();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      // phoneNoController.text = '0373568944';
    }
  }

  @override
  void dispose() {
    phoneNoController.clear();
    isEnableButton.dispose();
    errorPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      appBar: AppBar(
        leadingWidth: 100,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: XImage(
            imagePath: 'assets/images/ic-viet-qr.png',
            height: 40,
          ),
        ),
        actions: [
          Row(
            children: [
              VietQRButton.solid(
                borderRadius: 50,
                onPressed: () {},
                isDisabled: false,
                width: 40,
                size: VietQRButtonSize.medium,
                child: const XImage(
                  imagePath: 'assets/images/ic-headphone-black.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12, left: 8),
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFE1EFFF),
                        Color(0xFFE5F9FF),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isVNSelected = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: isVNSelected
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF00C6FF),
                                      Color(0xFF0072FF),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                : null,
                            color: isVNSelected ? null : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: isVNSelected
                              ? const Text(
                                  'VN',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                    colors: [
                                      Color(0xFF00C6FF),
                                      Color(0xFF0072FF),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ).createShader(bounds),
                                  child: const Text(
                                    'VN',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 0),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isVNSelected = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: !isVNSelected
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF00C6FF),
                                      Color(0xFF0072FF),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                : null,
                            color: !isVNSelected ? null : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: !isVNSelected
                              ? const Text(
                                  'EN',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                    colors: [
                                      Color(0xFF00C6FF),
                                      Color(0xFF0072FF),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ).createShader(bounds),
                                  child: const Text(
                                    'EN',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // const BackgroundAppBarLogin(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Nhập ',
                                style: TextStyle(
                                  color: AppColor.BLACK,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: 'số điện thoại ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader = LinearGradient(
                                      colors: [
                                        Color(0xFF00C6FF),
                                        Color(0xFF0072FF)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ).createShader(
                                      Rect.fromLTWH(0, 0, 200,
                                          40), // Adjust size as needed
                                    ),
                                ),
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: AppColor.BLACK,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PhoneWidget(
                          phoneController: phoneNoController,
                          onChanged: onChangePhoneNumber,
                          autoFocus: false,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          height: 1,
                          color: AppColor.GREY_LIGHT,
                          width: double.infinity,
                        ),
                        ValueListenableBuilder<String?>(
                          valueListenable: errorPhone,
                          builder: (context, value, child) {
                            return Visibility(
                              visible: value != null,
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  value ?? '',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: AppColor.RED_TEXT, fontSize: 13),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 40, right: 40),
                  //   child: SizedBox(
                  //     width: double.infinity,
                  //     child: Row(
                  //       children: [
                  //         Expanded(
                  //           child: MButtonWidget(
                  //             height: 50,
                  //             title: '',
                  //             isEnable: true,
                  //             colorEnableBgr: AppColor.BLUE_E1EFFF,
                  //             margin: EdgeInsets.zero,
                  //             onTap: widget.onLoginCard,
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 const XImage(
                  //                   imagePath: ImageConstant.icCard,
                  //                   height: 40,
                  //                 ),
                  //                 const SizedBox(width: 8),
                  //                 Text(
                  //                   'VQR ID Card',
                  //                   style: height < 800
                  //                       ? const TextStyle(fontSize: 12)
                  //                       : const TextStyle(fontSize: 14),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.symmetric(horizontal: 20),
          //   child: ValueListenableBuilder<bool>(
          //       valueListenable: isEnableButton,
          //       builder: (context, value, _) {
          //         return MButtonWidget(
          //           title: 'Tiếp tục',
          //           // width: 350,
          //           height: 50,
          //           isEnable: value && phoneNoController.text.isNotEmpty,
          //           colorDisableBgr: AppColor.GREY_BUTTON,
          //           margin: const EdgeInsets.only(bottom: 10),
          //           colorEnableText:
          //               value ? AppColor.WHITE : AppColor.GREY_TEXT,
          //           onTap: () {
          // FocusManager.instance.primaryFocus?.unfocus();
          // String phone = getPhone.replaceAll(' ', '');
          // widget.bloc.add(CheckExitsPhoneEvent(phone: phone));
          //           },
          //         );
          //       }),
          // ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ValueListenableBuilder<bool>(
                valueListenable: isEnableButton,
                builder: (context, value, _) {
                  return VietQRButton.gradient(
                    onPressed: () {
                      if (value) {
                        isEnableButton.value = false;
                        FocusManager.instance.primaryFocus?.unfocus();
                        String phone = getPhone.replaceAll(' ', '');
                        widget.bloc.add(CheckExitsPhoneEvent(phone: phone));
                      }
                    },
                    isDisabled: !value,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.abc,
                            size: 18,
                            color: AppColor.TRANSPARENT,
                          ),
                          Text(
                            'Tiếp tục',
                            style: TextStyle(
                              color: value ? AppColor.WHITE : AppColor.BLACK,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_outlined,
                            size: 18,
                            color: value ? AppColor.WHITE : AppColor.BLACK,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(height: height < 800 ? 0 : 16),
        ],
      ),
    );
  }

  onChangePhoneNumber(String? value) {
    setIsEnableButton(isValidatePhoneNumber(value!));
  }

  bool isValidatePhoneNumber(String phoneNumber) {
    String phone = phoneNumber.replaceAll(' ', '');
    // const pattern = r'(^(?:[+0]9)?[0-9]{10,11}$)';
    // final regExp = RegExp(pattern);
    var isValid = StringUtils.instance.isValidatePhone(phone);
    if (phone.isEmpty) {
      return false;
    }

    return isValid;
  }

  setIsEnableButton(bool value) {
    isEnableButton.value = value;
  }
}
