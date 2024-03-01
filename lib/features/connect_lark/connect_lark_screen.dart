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
import 'package:vierqr/features/connect_lark/states/conect_lark_state.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/connect_lark_provider.dart';

import '../../commons/utils/error_utils.dart';
import '../../models/info_tele_dto.dart';
import 'blocs/connect_lark_bloc.dart';
import 'events/connect_lark_event.dart';

class ConnectLarkScreen extends StatelessWidget {
  const ConnectLarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<InfoLarkDTO> list = [];
    return Scaffold(
      appBar: const MAppBar(title: 'Kết nối Lark'),
      body: ChangeNotifierProvider(
        create: (context) => ConnectLarkProvider(),
        child: BlocProvider<ConnectLarkBloc>(
          create: (context) => ConnectLarkBloc()
            ..add(GetInformationLarkConnect(
                userId: SharePrefUtils.getProfile().userId)),
          child: BlocConsumer<ConnectLarkBloc, ConnectLarkState>(
            listener: (context, state) {
              if (state is RemoveLarkConnectLoadingState) {
                DialogWidget.instance.openLoadingDialog();
              }
              if (state is RemoveLarkSuccessState) {
                Navigator.pop(context);
                BlocProvider.of<ConnectLarkBloc>(context).add(
                    GetInformationLarkConnect(
                        userId: SharePrefUtils.getProfile().userId));
              }
              if (state is RemoveBankLarkSuccessState) {
                Navigator.pop(context);
                BlocProvider.of<ConnectLarkBloc>(context).add(
                    GetInformationLarkConnect(
                        userId: SharePrefUtils.getProfile().userId));
              }
              if (state is AddBankLarkSuccessState) {
                Navigator.pop(context);
                BlocProvider.of<ConnectLarkBloc>(context).add(
                    GetInformationLarkConnect(
                        userId: SharePrefUtils.getProfile().userId));
              }
              if (state is RemoveLarkFailedState) {
                Navigator.pop(context);
                DialogWidget.instance.openMsgDialog(
                    title: 'Kết nối thất bại',
                    msg:
                        ErrorUtils.instance.getErrorMessage(state.dto.message));
              }
              if (state is AddBankLarkFailedState) {
                Navigator.pop(context);
                DialogWidget.instance.openMsgDialog(
                    title: 'Kết nối thất bại',
                    msg:
                        ErrorUtils.instance.getErrorMessage(state.dto.message));
              }
              if (state is GetInfoLarkConnectedSuccessState) {
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
              return Column(
                children: [
                  Expanded(child: _buildListConnectLark(list)),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      DialogWidget.instance.openMsgDialog(
                        title: 'Huỷ kết nối Lark',
                        msg: 'Bạn có chắc chắn muốn huỷ liên kết?',
                        isSecondBT: true,
                        functionConfirm: () {
                          Navigator.of(context).pop();
                          BlocProvider.of<ConnectLarkBloc>(context).add(
                              RemoveLarkConnect(larkConnectId: list.first.id));
                        },
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
                      decoration: BoxDecoration(
                          color: AppColor.RED_TEXT.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: AppColor.RED_TEXT),
                                borderRadius: BorderRadius.circular(20)),
                            child: Icon(
                              Icons.delete,
                              color: AppColor.RED_TEXT,
                              size: 14,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Huỷ kết nối Lark',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.RED_TEXT,
                            ),
                          )
                        ],
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

  Widget _buildListConnectLark(List<InfoLarkDTO> list) {
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

  Widget _buildItemChatTele(InfoLarkDTO dto, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
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
                    Text(
                      'Nền tảng kết nối:',
                      style: TextStyle(color: AppColor.GREY_TEXT),
                    ),
                    const Spacer(),
                    Text(
                      'Lark',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Image.asset(
                      'assets/images/logo-lark.png',
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
                    Text(
                      'Thông tin kết nối:',
                      style: TextStyle(color: AppColor.GREY_TEXT),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text(
                        dto.webhook,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
              FlutterClipboard.copy(dto.webhook).then(
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
              padding: EdgeInsets.only(left: 12, right: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColor.WHITE),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/ic_copy.png',
                    height: 24,
                  ),
                  Text(
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
        Text(
          'Danh sách TK ngân hàng',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
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
                padding: EdgeInsets.only(left: 12, right: 12, bottom: 32),
                height: MediaQuery.of(context).size.height * 0.8,
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
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

                      BlocProvider.of<ConnectLarkBloc>(context)
                          .add(AddBankLarkEvent(body));
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
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    border: Border.all(width: 0.5, color: AppColor.GREY_TEXT),
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
                        title: 'Huỷ kết nối Lark',
                        msg: 'Bạn có chắc chắn muốn huỷ liên kết?',
                        isSecondBT: true,
                        functionConfirm: () {
                          Navigator.of(context).pop();
                          final Map<String, dynamic> body = {
                            'id': dto.id,
                            'userId': SharePrefUtils.getProfile().userId,
                            'bankId': bank.bankId,
                          };

                          BlocProvider.of<ConnectLarkBloc>(context)
                              .add(RemoveBankLarkEvent(body));
                        },
                      );
                    },
                    child: Icon(
                      Icons.remove_circle_outline,
                      color: AppColor.RED_TEXT,
                      size: 18,
                    ))
              ],
            ),
          );
        }).toList(),
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
            'assets/images/logo-lark.png',
            width: 80,
            height: 80,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            'Lark',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Nhận thông tin Biến động số dư qua Lark khi quý khách thực hiện kết nối chỉ với một vài thao tác đơn giản.',
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          MButtonWidget(
            title: 'Bắt đầu kết nối',
            isEnable: true,
            margin: EdgeInsets.zero,
            colorEnableText: AppColor.WHITE,
            onTap: () async {
              await Navigator.pushNamed(
                  context, Routes.CONNECT_STEP_LARK_SCREEN);
              BlocProvider.of<ConnectLarkBloc>(context).add(
                  GetInformationLarkConnect(
                      userId: SharePrefUtils.getProfile().userId));
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
