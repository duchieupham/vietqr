import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/connect_media/connect_media_screen.dart';
import 'package:vierqr/features/connect_media/events/connect_media_evens.dart';
import 'package:vierqr/features/connect_media/states/connect_media_states.dart';
import 'package:vierqr/features/connect_media/widgets/popup_confirm_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';

import '../blocs/connect_media_bloc.dart';

class UpdateSharingInfoScreen extends StatefulWidget {
  final List<String> notificationTypes;
  final List<String> notificationContents;
  final TypeConnect type;
  final String id;
  const UpdateSharingInfoScreen(
      {super.key,
      required this.id,
      required this.type,
      required this.notificationTypes,
      required this.notificationContents});

  @override
  State<UpdateSharingInfoScreen> createState() =>
      _UpdateSharingInfoScreenState();
}

class _UpdateSharingInfoScreenState extends State<UpdateSharingInfoScreen> {
  List<String> notificationTypes = [];
  List<String> notificationContents = [];

  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  bool isChecked5 = false;
  bool isChecked6 = false;

  final _bloc = getIt.get<ConnectMediaBloc>();

  @override
  void initState() {
    super.initState();
    iniData();
  }

  void iniData() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        notificationTypes = widget.notificationTypes;
        notificationContents = widget.notificationContents;

        for (var e in widget.notificationTypes) {
          switch (e) {
            case 'CREDIT':
              isChecked1 = true;
              break;
            case 'DEBIT':
              isChecked2 = true;
              break;
            case 'RECON':
              isChecked3 = true;
              break;
            default:
              break;
          }
        }

        for (var e in widget.notificationContents) {
          switch (e) {
            case 'AMOUNT':
              isChecked4 = true;
              break;
            case 'REFERENCE_NUMBER':
              isChecked5 = true;
              break;
            case 'CONTENT':
              isChecked6 = true;
              break;
            default:
              break;
          }
        }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String text = '';
    switch (widget.type) {
      case TypeConnect.GG_CHAT:
        text = 'Google Chat';
        break;
      case TypeConnect.TELE:
        text = 'Telegram';

        break;
      case TypeConnect.LARK:
        text = 'Lark';

        break;
      default:
    }

    return BlocConsumer<ConnectMediaBloc, ConnectMediaStates>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.request == ConnectMedia.UPDATE_SHARING &&
            state.status == BlocStatus.SUCCESS) {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: 'Cập nhật thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: _buildAppBar(),
          bottomNavigationBar: _bottom(),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cập nhật cấu hình thông tin\nchia sẻ BĐSD qua $text',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Cấu hình chia sẻ loại giao dịch',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildCheckboxRow('Giao dịch có đối soát', isChecked1,
                          (value) {
                        setState(() {
                          isChecked1 = value ?? true;
                        });
                      }),
                      InkWell(
                        onTap: () {
                          DialogWidget.instance.showModelBottomSheet(
                            borderRadius: BorderRadius.circular(16),
                            widget: const PopUpConfirm(),
                            // height: MediaQuery.of(context).size.height * 0.6,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFE1EFFF),
                                    Color(0xFFE5F9FF),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight)),
                          child: const XImage(
                              imagePath: 'assets/images/ic-i-black.png'),
                        ),
                      ),
                    ],
                  ),
                  const MySeparator(color: AppColor.GREY_DADADA),
                  buildCheckboxRow('Giao dịch nhận tiền đến (+)', isChecked2,
                      (value) {
                    setState(() {
                      isChecked2 = value ?? true;
                    });
                  }),
                  const MySeparator(color: AppColor.GREY_DADADA),
                  buildCheckboxRow('Giao dịch chuyển tiền đi (−)', isChecked3,
                      (value) {
                    setState(() {
                      isChecked3 = value ?? true;
                    });
                  }),
                  const SizedBox(height: 20),
                  const Text(
                    'Cấu hình chia sẻ thông tin giao dịch',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  buildCheckboxRow('Số tiền', isChecked4, (value) {
                    setState(() {
                      isChecked4 = value ?? true;
                    });
                  }),
                  const MySeparator(color: AppColor.GREY_DADADA),
                  buildCheckboxRow('Nội dung thanh toán', isChecked5, (value) {
                    setState(() {
                      isChecked5 = value ?? true;
                    });
                  }),
                  const MySeparator(color: AppColor.GREY_DADADA),
                  buildCheckboxRow('Mã giao dịch', isChecked6, (value) {
                    setState(() {
                      isChecked6 = value ?? true;
                    });
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildCheckboxRow(
      String text, bool isChecked, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Theme(
          data: ThemeData(
            unselectedWidgetColor: AppColor.GREY_DADADA,
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
          child: Checkbox(
            value: isChecked,
            onChanged: onChanged,
            checkColor: AppColor.WHITE,
            activeColor: AppColor.BLUE_TEXT,
          ),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Widget _bottom() {
    bool isEnable = false;
    if (isChecked1 == true || isChecked2 == true || isChecked3 == true) {
      isEnable = true;
    } else {
      isEnable = false;
    }
    if (isChecked4 == true || isChecked5 == true || isChecked6 == true) {
      isEnable = true;
    } else {
      isEnable = false;
    }
    return InkWell(
      onTap: isEnable
          ? () {
              List<String> list1 = [];
              List<String> lsit2 = [];
              if (isChecked1) list1.add('CREDIT');
              if (isChecked2) list1.add('DEBIT');
              if (isChecked3) list1.add('RECON');

              if (isChecked4) lsit2.add('AMOUNT');
              if (isChecked5) lsit2.add('REFERENCE_NUMBER');
              if (isChecked6) lsit2.add('CONTENT');

              _bloc.add(UpdateSharingEvent(
                  type: widget.type,
                  notificationTypes: list1,
                  notificationContents: lsit2,
                  id: widget.id));
            }
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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
                color: AppColor.TRANSPARENT,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      backgroundColor: AppColor.WHITE,
      leadingWidth: double.infinity,
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          padding: const EdgeInsets.only(left: 8),
          child: const Row(
            children: [
              Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
                size: 25,
              ),
              SizedBox(width: 2),
              Text(
                "Trở về",
                style: TextStyle(color: Colors.black, fontSize: 14),
              )
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Image.asset(
            AppImages.icLogoVietQr,
            width: 95,
            fit: BoxFit.fitWidth,
          ),
        )
      ],
    );
  }
}
