import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/bottom_sheet_add_bankaccount.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/connect_telegram_old/blocs/connect_telegram_bloc.dart';
import 'package:vierqr/features/connect_telegram_old/states/conect_telegram_state.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/connect_telegram_provider.dart';

import '../../commons/utils/error_utils.dart';
import '../../models/info_tele_dto.dart';
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
                userId: SharePrefUtils.getProfile().userId)),
          child: BlocConsumer<ConnectTelegramBloc, ConnectTelegramState>(
            listener: (context, state) {
              if (state is RemoveTelegramLoadingState) {
                DialogWidget.instance.openLoadingDialog();
              }
              if (state is RemoveTeleSuccessState ||
                  state is RemoveBankTeleSuccessState ||
                  state is AddBankTeleSuccessState) {
                Navigator.pop(context);
                BlocProvider.of<ConnectTelegramBloc>(context).add(
                    GetInformationTeleConnect(
                        userId: SharePrefUtils.getProfile().userId));
              }
              if (state is RemoveTeleFailedState) {
                Navigator.pop(context);
                DialogWidget.instance.openMsgDialog(
                    title: 'Kết nối thất bại',
                    msg:
                        ErrorUtils.instance.getErrorMessage(state.dto.message));
              }
              if (state is AddBankTeleFailedState) {
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
                return const Center(child: CircularProgressIndicator());
              }
              if (list.isEmpty) {
                return _buildBlankWidget(context);
              }
              return Column(
                children: [
                  Expanded(child: _buildListChatTele(list)),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                    child: InkWell(
                      onTap: () {
                        DialogWidget.instance.openMsgDialog(
                          title: 'Huỷ kết nối Telegram',
                          msg: 'Bạn có chắc chắn muốn huỷ liên kết?',
                          isSecondBT: true,
                          functionConfirm: () {
                            Navigator.of(context).pop();
                            BlocProvider.of<ConnectTelegramBloc>(context).add(
                                RemoveTeleConnect(
                                    teleConnectId: list.first.id));
                          },
                        );
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                            color: AppColor.RED_TEXT.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: AppColor.RED_TEXT),
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Icon(
                                Icons.delete,
                                color: AppColor.RED_TEXT,
                                size: 14,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text(
                              'Huỷ kết nối Telegram',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.RED_TEXT,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildListChatTele(List<InfoTeleDTO> list) {
    return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemBuilder: (context, index) {
          return _buildItemChatTele(list[index], context);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 20,
          );
        },
        itemCount: list.length);
  }

  Widget _buildItemChatTele(InfoTeleDTO dto, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin kết nối',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 12,
        ),
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
                    const Text(
                      'Nền tảng kết nối:',
                      style: TextStyle(color: AppColor.GREY_TEXT),
                    ),
                    const Spacer(),
                    const Text(
                      'Telegram',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Image.asset(
                      'assets/images/logo-telegram.png',
                      height: 28,
                      width: 28,
                    ),
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
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text(
                      'Thông tin kết nối:',
                      style: TextStyle(color: AppColor.GREY_TEXT),
                    ),
                    const Spacer(),
                    Text(
                      dto.chatId,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
              FlutterClipboard.copy(dto.chatId).then(
                (value) => Fluttertoast.showToast(
                  msg: 'Đã sao chép',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).hintColor,
                  fontSize: 15,
                  webBgColor: 'rgba(255, 255, 255, 0.5)',
                  webPosition: 'center',
                ),
              );
            },
            child: Container(
              width: 100,
              height: 30,
              padding: const EdgeInsets.only(left: 12, right: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColor.WHITE),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/ic_copy.png',
                    height: 24,
                  ),
                  const Text(
                    'Sao chép',
                    style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Danh sách TK ngân hàng',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 4,
        ),
        const Text(
            'Tài khoản ngân hàng được chia sẻ thông tin biến động số dư qua Telegram',
            style: TextStyle(
              fontSize: 12,
            )),
        const SizedBox(
          height: 12,
        ),
        ButtonWidget(
            borderRadius: 5,
            height: 40,
            text: 'Thêm tài khoản',
            textColor: AppColor.WHITE,
            bgColor: AppColor.BLUE_TEXT,
            function: () async {
              await DialogWidget.instance.showModelBottomSheet(
                isDismissible: true,
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 32),
                height: MediaQuery.of(context).size.height * 0.8,
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                borderRadius: BorderRadius.circular(16),
                widget: BottomSheetAddBankAccount(
                  onSelect: (bankAccount) async {
                    bool existed = false;
                    await Future.forEach(dto.banks,
                        (BankConnectedDTO bank) async {
                      if (bank.bankId == bankAccount.id) {
                        existed = true;
                        DialogWidget.instance.openMsgDialog(
                            title: 'Thêm tài khoản',
                            msg: 'Tài khoản ngân hàng này đã được thêm');
                      }
                    });

                    if (!existed) {
                      final Map<String, dynamic> body = {
                        'id': dto.id,
                        'userId': SharePrefUtils.getProfile().userId,
                        'bankId': bankAccount.id,
                      };

                      BlocProvider.of<ConnectTelegramBloc>(context)
                          .add(AddBankTelegramEvent(body));
                    }
                  },
                ),
              );
            }),
        const SizedBox(
          height: 12,
        ),
        ...dto.banks.map((bank) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: AppColor.WHITE),
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(width: 0.5, color: AppColor.GREY_BORDER),
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
                          color: AppColor.BLACK, fontWeight: FontWeight.w600),
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
                GestureDetector(
                    onTap: () {
                      DialogWidget.instance.openMsgDialog(
                        title: 'Huỷ kết nối Telegram',
                        msg: 'Bạn có chắc chắn muốn huỷ liên kết?',
                        isSecondBT: true,
                        functionConfirm: () {
                          Navigator.of(context).pop();
                          final Map<String, dynamic> body = {
                            'id': dto.id,
                            'userId': SharePrefUtils.getProfile().userId,
                            'bankId': bank.bankId,
                          };
                          BlocProvider.of<ConnectTelegramBloc>(context)
                              .add(RemoveBankTelegramEvent(body));
                        },
                      );
                    },
                    child: const Icon(
                      Icons.remove_circle_outline,
                      color: AppColor.RED_TEXT,
                      size: 18,
                    ))
              ],
            ),
          );
        }),
        const SizedBox(
          height: 8,
        ),
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
          const Text(
            'Telegram',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
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
