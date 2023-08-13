import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/step_progress.dart';
import 'package:vierqr/features/connect_lark/blocs/connect_lark_bloc.dart';
import 'package:vierqr/features/connect_lark/page/choose_bank_page.dart';
import 'package:vierqr/features/connect_lark/page/create_webhook.dart';
import 'package:vierqr/features/connect_lark/page/setting_lark_page.dart';
import 'package:vierqr/features/connect_lark/widget/success_screen.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import '../../../services/providers/connect_lark_provider.dart';
import '../events/connect_lark_event.dart';
import '../states/conect_lark_state.dart';

class ConnectLarkStepScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ConnectLarkProvider(),
        child: _ConnectLarkStepScreen());
  }
}

class _ConnectLarkStepScreen extends StatefulWidget {
  const _ConnectLarkStepScreen({super.key});

  @override
  State<_ConnectLarkStepScreen> createState() => _ConnectLarkStepScreenState();
}

class _ConnectLarkStepScreenState extends State<_ConnectLarkStepScreen> {
  final PageController pageController = PageController();
  void handleBackButton(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (pageController.page! > 0.0) {
      Provider.of<ConnectLarkProvider>(context, listen: false)
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
          title: 'Kết nối Lark',
          onPressed: () {
            handleBackButton(context);
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocProvider<ConnectLarkBloc>(
            create: (context) => ConnectLarkBloc(),
            child: BlocConsumer<ConnectLarkBloc, ConnectLarkState>(
              listener: (context, state) {
                if (state is ConnectLarkLoadingState) {
                  DialogWidget.instance.openLoadingDialog();
                }
                if (state is InsertLarkSuccessState) {
                  Navigator.pop(context);
                  String webhook =
                      Provider.of<ConnectLarkProvider>(context, listen: false)
                          .webHook;
                  BlocProvider.of<ConnectLarkBloc>(context)
                      .add(SendFirstMessage(webhook: webhook));
                  Navigator.pop(context);

                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ConnectLarkSuccess();
                  }));
                }
                if (state is InsertLarkFailedState) {
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
                        const CreateWebhookPage(),
                        const SettingLarkPage(),
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
    return Consumer<ConnectLarkProvider>(builder: (context, provider, child) {
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
    return Consumer<ConnectLarkProvider>(builder: (context, provider, child) {
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
          Map<String, dynamic> data = {};
          data['webhook'] = provider.webHook;
          data['userId'] = UserInformationHelper.instance.getUserId();
          data['bankIds'] = provider.bankIds;
          BlocProvider.of<ConnectLarkBloc>(context).add(InsertLark(data: data));
        },
      );
    });
  }
}
