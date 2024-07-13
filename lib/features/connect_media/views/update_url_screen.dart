import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/features/connect_media/blocs/connect_media_bloc.dart';
import 'package:vierqr/features/connect_media/connect_media_screen.dart';
import 'package:vierqr/features/connect_media/events/connect_media_evens.dart';
import 'package:vierqr/features/connect_media/states/connect_media_states.dart';

class UpdateUrlScreen extends StatefulWidget {
  final TypeConnect type;
  final String id;
  const UpdateUrlScreen({
    super.key,
    required this.id,
    required this.type,
  });

  @override
  State<UpdateUrlScreen> createState() => _UpdateUrlScreenState();
}

class _UpdateUrlScreenState extends State<UpdateUrlScreen> {
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();

  final _bloc = getIt.get<ConnectMediaBloc>();

  bool isValidUrl = true;

  @override
  void initState() {
    super.initState();
    // iniData();
  }

  @override
  Widget build(BuildContext context) {
    String webhook = '';

    String text = '';
    switch (widget.type) {
      case TypeConnect.GG_CHAT:
        text = 'Google Chat';
        webhook = 'Webhook Google Chat';
        break;
      case TypeConnect.TELE:
        text = 'Telegram';
        webhook = 'Chat Id';
        break;
      case TypeConnect.LARK:
        text = 'Lark';
        webhook = 'Webhook Lark';
        break;
      case TypeConnect.SLACK:
        text = 'Slack';
        webhook = 'Webhook Slack';
        break;
      case TypeConnect.DISCORD:
        text = 'Discord';
        webhook = 'Webhook Discord';
        break;
      case TypeConnect.GG_SHEET:
        text = 'Google Sheet';
        webhook = 'Webhook Google Sheet';
        break;
      default:
    }
    return BlocConsumer<ConnectMediaBloc, ConnectMediaStates>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.request == ConnectMedia.CHECK_URL &&
            state.status == BlocStatus.SUCCESS) {
          isValidUrl = state.isValidUrl!;
          if (isValidUrl) {
            _bloc.add(UpdateUrlEvent(
                type: widget.type, id: widget.id, url: controller.text));
          }
          setState(() {});
        }

        if (state.request == ConnectMedia.UPDATE_URL &&
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
          resizeToAvoidBottomInset: true,
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
                  SizedBox(
                    width: double.infinity,
                    height: 20,
                    child: Text(
                      webhook,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    // margin: EdgeInsets.only(right: 40),
                    height: 50,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom:
                              BorderSide(color: AppColor.GREY_TEXT, width: 0.5),
                        )),
                    child: TextField(
                      focusNode: focusNode,
                      controller: controller,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      onSubmitted: (value) {},
                      onChanged: (value) {
                        isValidUrl = true;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: 'Nhập đường dẫn $webhook tại đây',
                        hintStyle: const TextStyle(
                            fontSize: 15, color: AppColor.GREY_TEXT),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15),
                      ),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  Visibility(
                    visible: controller.text.isNotEmpty
                        ? (!isValidUrl ? true : false)
                        : false,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: const Text(
                        'Webhook không hợp lệ. Vui lòng kiểm tra lại thông tin.',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bottom() {
    return InkWell(
      onTap: () {
        _bloc
            .add(CheckWebhookUrlEvent(url: controller.text, type: widget.type));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.bounceInOut,
        margin: EdgeInsets.fromLTRB(
            20, 10, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF00C6FF),
              Color(0xFF0072FF),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          color: const Color(0xFFF0F4FA),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
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
                    color: AppColor.WHITE,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Padding(
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
