import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/connect_telegram/blocs/connect_telegram_bloc.dart';
import 'package:vierqr/features/connect_telegram/states/conect_telegram_state.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/services/providers/connect_telegram_provider.dart';

import '../../commons/utils/error_utils.dart';
import '../../models/info_tele_dto.dart';
import '../../services/shared_references/user_information_helper.dart';
import 'events/connect_telegram_event.dart';

class ConnectTelegramScreen extends StatelessWidget {
  const ConnectTelegramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<InfoTeleDTO> list = [];
    return Scaffold(
      appBar: const MAppBar(title: 'Kết nối Telegram'),
      body: ChangeNotifierProvider(
        create: (context) => ConnectTelegramProvider(),
        child: BlocProvider<ConnectTelegramBloc>(
          create: (context) => ConnectTelegramBloc()
            ..add(GetInformationTeleConnect(
                userId: UserInformationHelper.instance.getUserId())),
          child: BlocConsumer<ConnectTelegramBloc, ConnectTelegramState>(
            listener: (context, state) {
              if (state is RemoveTelegramLoadingState) {
                DialogWidget.instance.openLoadingDialog();
              }
              if (state is RemoveTeleSuccessState) {
                Navigator.pop(context);
                BlocProvider.of<ConnectTelegramBloc>(context).add(
                    GetInformationTeleConnect(
                        userId: UserInformationHelper.instance.getUserId()));
              }
              if (state is RemoveTeleFailedState) {
                Navigator.pop(context);
                DialogWidget.instance.openMsgDialog(
                    title: 'Kết nối thất bại',
                    msg:
                        ErrorUtils.instance.getErrorMessage(state.dto.message));
              }
              if (state is GetInfoTeleConnectedSuccessState) {
                list = state.list;
              }
            },
            builder: (context, state) {
              if (state is GetInfoLoadingState) {
                return Center(child: CircularProgressIndicator());
              }
              if (list.isEmpty) {
                return _buildBlankWidget(context);
              }
              return _buildListChatTele(list);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildListChatTele(List<InfoTeleDTO> list) {
    return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemBuilder: (context, index) {
          return _buildItemChatTele(list[index], context);
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 20,
          );
        },
        itemCount: list.length);
  }

  Widget _buildItemChatTele(InfoTeleDTO dto, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.WHITE,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo-telegram.png',
                      height: 28,
                      width: 28,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Chat ID',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      dto.chatId,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              const Divider(
                color: Colors.black,
                thickness: 0.2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, right: 12),
                child: Column(
                  children: dto.banks.map((bank) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: AppColor.WHITE,
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                  width: 0.5, color: AppColor.GREY_TEXT),
                              image: DecorationImage(
                                image: ImageUtils.instance.getImageNetWork(
                                  bank.imageId,
                                ),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${bank.bankCode} - ${bank.bankAccount}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: AppColor.BLACK,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                bank.userBankName.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColor.BLACK,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        InkWell(
          onTap: () {
            DialogWidget.instance.openMsgDialog(
              title: 'Huỷ kết nối Telegram',
              msg: 'Bạn có chắc chắn muốn huỷ liên kết?',
              isSecondBT: true,
              functionConfirm: () {
                Navigator.of(context).pop();
                BlocProvider.of<ConnectTelegramBloc>(context)
                    .add(RemoveTeleConnect(teleConnectId: dto.id));
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
                color: AppColor.WHITE, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: AppColor.RED_TEXT),
                      borderRadius: BorderRadius.circular(20)),
                  child: Image.asset(
                    'assets/images/ic-trash.png',
                    height: 18,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  'Huỷ kết nối Telegram',
                  style: TextStyle(fontSize: 11, color: AppColor.RED_TEXT),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBlankWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Spacer(),
          Image.asset(
            'assets/images/logo-telegram.png',
            width: 80,
            height: 80,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            'Telegram',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Nhận thông tin Biến động số dư qua Telegram khi quý khách thực hiện kết nối. An tâm về vấn đề an toàn thông tin - dữ liệu của Telegram mang lại.',
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          MButtonWidget(
            title: 'Bắt đầu kết nối',
            isEnable: true,
            margin: EdgeInsets.zero,
            colorEnableText: AppColor.WHITE,
            onTap: () async {
              Navigator.pushNamed(context, Routes.CONNECT_STEP_TELE_SCREEN);
            },
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
