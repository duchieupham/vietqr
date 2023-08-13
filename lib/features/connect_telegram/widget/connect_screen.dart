import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/step_progress.dart';
import 'package:vierqr/features/connect_telegram/blocs/connect_telegram_bloc.dart';
import 'package:vierqr/features/connect_telegram/events/connect_telegram_event.dart';
import 'package:vierqr/features/connect_telegram/page/add_vietQr_bot.dart';
import 'package:vierqr/features/connect_telegram/page/choose_bank_page.dart';
import 'package:vierqr/features/connect_telegram/page/setting_telegram_page.dart';
import 'package:vierqr/features/connect_telegram/states/conect_telegram_state.dart';
import 'package:vierqr/features/connect_telegram/widget/success_screen.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/services/providers/connect_telegram_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class ConnectTeleStepScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ConnectTelegramProvider(),
        child: _ConnectTeleStepScreen());
  }
}

class _ConnectTeleStepScreen extends StatefulWidget {
  const _ConnectTeleStepScreen({super.key});

  @override
  State<_ConnectTeleStepScreen> createState() => _ConnectTeleStepScreenState();
}

class _ConnectTeleStepScreenState extends State<_ConnectTeleStepScreen> {
  final PageController pageController = PageController();

  void handleBackButton(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (pageController.page! > 0.0) {
      Provider.of<ConnectTelegramProvider>(context, listen: false)
          .updateStep(pageController.page!.toInt());
      pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        handleBackButton(context);
        return false;
      },
      child: Scaffold(
        appBar: MAppBar(
          title: 'Kết nối Telegram',
          onPressed: () {
            handleBackButton(context);
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocProvider<ConnectTelegramBloc>(
            create: (context) => ConnectTelegramBloc(),
            child: BlocConsumer<ConnectTelegramBloc, ConnectTelegramState>(
              listener: (context, state) {
                if (state is ConnectTelegramLoadingState) {
                  DialogWidget.instance.openLoadingDialog();
                }
                if (state is InsertTeleSuccessState) {
                  Navigator.pop(context);
                  String chatId = Provider.of<ConnectTelegramProvider>(context,
                          listen: false)
                      .chatId;
                  BlocProvider.of<ConnectTelegramBloc>(context)
                      .add(SendFirstMessage(chatId: chatId));
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConnectTelegramSuccess()));
                }
                if (state is InsertTeleFailedState) {
                  Navigator.pop(context);
                  DialogWidget.instance.openMsgDialog(
                      title: 'Kết nối thất bại',
                      msg: ErrorUtils.instance
                          .getErrorMessage(state.dto.message));
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    _buildStepProgress(),
                    Expanded(
                        child: PageView(
                      controller: pageController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        ChooseBankPage(),
                        const AddVietQrPage(),
                        const SettingTelegramPage(),
                      ],
                    )),
                    _buildButton(),
                    const SizedBox(
                      height: 16,
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepProgress() {
    return Consumer<ConnectTelegramProvider>(
        builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: StepProgressView(
            width: MediaQuery.of(context).size.width,
            curStep: provider.curStep,
            color: AppColor.BLUE_TEXT,
            titles: provider.titles),
      );
    });
  }

  Widget _buildButton() {
    return Consumer<ConnectTelegramProvider>(
        builder: (context, provider, child) {
      if (provider.curStep < 3) {
        return MButtonWidget(
          title: 'Tiếp theo',
          isEnable: true,
          margin: EdgeInsets.zero,
          colorEnableText: AppColor.WHITE,
          onTap: () {
            int page = provider.curStep + 1;
            pageController.animateToPage(provider.curStep,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
            provider.updateStep(page);
          },
        );
      }
      return MButtonWidget(
        title: 'Xác nhận',
        isEnable: true,
        margin: EdgeInsets.zero,
        colorEnableText: AppColor.WHITE,
        onTap: () {
          if (provider.chatId.isEmpty) {
            provider.updateChatId(provider.chatId);
          } else {
            Map<String, dynamic> data = {};
            data['chatId'] = provider.chatId;
            data['userId'] = UserInformationHelper.instance.getUserId();
            data['bankIds'] = provider.bankIds;
            BlocProvider.of<ConnectTelegramBloc>(context)
                .add(InsertTelegram(data: data));
          }
        },
      );
    });
  }
}
