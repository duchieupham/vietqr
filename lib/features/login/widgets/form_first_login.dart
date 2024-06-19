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
  final phoneNoController = TextEditingController();
  final ValueNotifier<bool> isEnableButton = ValueNotifier(false);
  final ValueNotifier<String?> errorPhone = ValueNotifier(null);

  String get getPhone => phoneNoController.text.trim();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      phoneNoController.text = '0373568944';
      isEnableButton.value = true;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const BackgroundAppBarLogin(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 30),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          width: double.infinity,
                          child: const Text(
                            'Xin chào,\nvui lòng nhập số điện thoại',
                            style: TextStyle(
                              color: AppColor.BLACK,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: MButtonWidget(
                              height: 50,
                              title: '',
                              isEnable: true,
                              colorEnableBgr: AppColor.BLUE_E1EFFF,
                              margin: EdgeInsets.zero,
                              onTap: widget.onLoginCard,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const XImage(
                                    imagePath: ImageConstant.icCard,
                                    height: 40,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'VQR ID Card',
                                    style: height < 800
                                        ? const TextStyle(fontSize: 12)
                                        : const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
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
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: ValueListenableBuilder<bool>(
                valueListenable: isEnableButton,
                builder: (context, value, _) {
                  return MButtonWidget(
                    title: 'Tiếp tục',
                    // width: 350,
                    height: 50,
                    isEnable: value,
                    colorDisableBgr: AppColor.GREY_BUTTON,
                    margin: const EdgeInsets.only(bottom: 0),
                    colorEnableText:
                        value ? AppColor.WHITE : AppColor.GREY_TEXT,
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      String phone = getPhone.replaceAll(' ', '');
                      widget.bloc.add(CheckExitsPhoneEvent(phone: phone));
                    },
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
    const pattern = r'(^(?:[+0]9)?[0-9]{10,11}$)';
    final regExp = RegExp(pattern);
    if (phone.isEmpty) {
      return false;
    } else if (!(phone.startsWith('0') && regExp.hasMatch(phone))) {
      return false;
    }

    return true;
  }

  setIsEnableButton(bool value) {
    isEnableButton.value = value;
  }
}
