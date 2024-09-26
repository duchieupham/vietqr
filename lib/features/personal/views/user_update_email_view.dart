import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/input_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/ambient_avatar_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/personal/blocs/user_edit_bloc.dart';
import 'package:vierqr/features/personal/events/user_edit_event.dart';
import 'package:vierqr/features/personal/states/user_edit_state.dart';
import 'package:vierqr/features/verify_email/verify_email_screen.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class UserUpdateEmailWidget extends StatefulWidget {
  final String phoneNum;
  const UserUpdateEmailWidget({super.key, required this.phoneNum});

  @override
  State<UserUpdateEmailWidget> createState() => _UserUpdateEmailWidgetState();
}

class _UserUpdateEmailWidgetState extends State<UserUpdateEmailWidget> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;
  final UserEditBloc _bloc = getIt.get<UserEditBloc>();
  ScrollController controllerAppbar = ScrollController();
  ValueNotifier<bool> appbarNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controllerAppbar.addListener(
        () {
          appbarNotifier.value = controllerAppbar.offset == 0;
        },
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return emailRegex.hasMatch(email);
  }

  void validateEmail(String email) {
    if (email.isEmpty || !isValidEmail(email)) {
      setState(() {
        _emailError =
            'Email không hợp lệ. Vui lòng kiểm tra lại thông tin của bạn.';
      });
    } else {
      setState(() {
        _emailError = null;
      });
    }
  }

  String get userId => SharePrefUtils.getProfile().userId.trim();
  // bool _onHomeCalled = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserEditBloc, UserEditState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is UserEditEmailSuccessState) {
          Fluttertoast.showToast(
            msg: 'Cập nhật email thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
          NavigatorUtils.navigateToRoot(context);
        }
        if (state is UserEditLoadingState) {
          DialogWidget.instance.openLoadingDialog();
        }

        if (state is UserEditEmailFailedState) {
          Fluttertoast.showToast(
            msg: 'Cập nhật email thất bại',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
          NavigatorUtils.navigateToRoot(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.WHITE,
          appBar: AppBar(
            leadingWidth: 250,
            elevation: 0,
            backgroundColor: Colors.white,
            forceMaterialTransparency: true,
            leading: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: appbarNotifier,
                  builder: (BuildContext context, value, Widget? child) {
                    return value
                        ? InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Trở về'))
                        : SizedBox(
                            width: 200,
                            child: Row(
                              children: [
                                _buildAvatarWidget(context, 40),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    SharePrefUtils.getProfile().fullName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          );
                  },
                ),
              ],
            ),
          ),
          resizeToAvoidBottomInset:
              true, // Allow the screen to resize when the keyboard is visible
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Cập nhật thông tin ',
                          style: TextStyle(
                            color: AppColor.BLACK,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Email',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(
                                  const Rect.fromLTWH(0, 0, 200, 40)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'cho tài khoản ${widget.phoneNum}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  MTextFieldCustom(
                    controller: _emailController,
                    isObscureText: false,
                    maxLines: 1,
                    showBorder: false,
                    enable: true,
                    fillColor: AppColor.WHITE,
                    autoFocus: true,
                    textFieldType: TextfieldType.DEFAULT,
                    title: '',
                    hintText: '',
                    inputType: TextInputType.emailAddress,
                    keyboardAction: TextInputAction.next,
                    inputFormatter: [EmailInputFormatter()],
                    onSubmitted: (value) {
                      validateEmail(_emailController.text);
                      bool isValidEmail = _emailError == null &&
                          _emailController.text.isNotEmpty;
                      if (isValidEmail) {
                        NavigatorUtils.navigatePage(
                            context,
                            VerifyEmailScreen(
                              email: _emailController.text,
                              isUpdate: true,
                            ),
                            routeName: VerifyEmailScreen.routeName);
                      }
                    },
                    onChange: (value) {
                      validateEmail(value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Nhập email tại đây',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: AppColor.GREY_TEXT,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.GREY_DADADA),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.GREY_DADADA),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.GREY_DADADA),
                      ),
                    ),
                  ),
                  if (_emailError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        _emailError!,
                        style: const TextStyle(color: Colors.red, fontSize: 11),
                      ),
                    ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.fromLTRB(
                20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VietQRButton.gradient(
                  onPressed: () {
                    validateEmail(_emailController.text);
                    bool isValidEmail =
                        _emailError == null && _emailController.text.isNotEmpty;
                    if (isValidEmail) {
                      NavigatorUtils.navigatePage(
                          context,
                          VerifyEmailScreen(
                            email: _emailController.text,
                            isUpdate: true,
                          ),
                          routeName: VerifyEmailScreen.routeName);
                    }
                  },
                  isDisabled: !(_emailError == null &&
                      _emailController.text.isNotEmpty),
                  size: VietQRButtonSize.large,
                  child: Center(
                    child: Text(
                      'Xác thực Email',
                      style: TextStyle(
                        color: (_emailError == null &&
                                _emailController.text.isNotEmpty)
                            ? AppColor.WHITE
                            : AppColor.BLACK,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    validateEmail(_emailController.text);
                    bool isValidEmail =
                        _emailError == null && _emailController.text.isNotEmpty;
                    if (isValidEmail) {
                      _bloc.add(
                        UserEditEmailEvent(
                            email: _emailController.text,
                            userId: SharePrefUtils.getProfile().userId),
                      );
                    } else {}
                  },
                  child: _emailError == null && _emailController.text.isNotEmpty
                      ? ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: const Text(
                            'Lưu thông tin',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        )
                      : const Text(
                          'Lưu thông tin',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, color: AppColor.GREY_DADADA),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarWidget(BuildContext context, double size) {
    // double size = size;
    String imgId = SharePrefUtils.getProfile().imgId;
    return Consumer<AuthenProvider>(
      builder: (context, provider, child) {
        return (provider.avatarUser.path.isNotEmpty)
            ? AmbientAvatarWidget(
                imgId: imgId,
                size: size,
                imageFile: provider.avatarUser,
              )
            : (imgId.isEmpty)
                ? ClipOval(
                    child: SizedBox(
                      width: size,
                      height: size,
                      child: Image.asset('assets/images/ic-avatar.png'),
                    ),
                  )
                : AmbientAvatarWidget(imgId: imgId, size: size);
      },
    );
  }

  // void backToPreviousPage(
  //     BuildContext context, bool isRegisterSuccess, RegisterState state) {
  //   Navigator.pop(context, {
  //     'phone': state.phoneNumber.replaceAll(' ', ''),
  //     'password': state.password
  //   });
  // }
}
