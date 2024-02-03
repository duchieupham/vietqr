import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_detail/blocs/share_bdsd_bloc.dart';
import 'package:vierqr/features/bank_detail/provider/share_bdsd_invite_provider.dart';
import 'package:vierqr/features/bank_detail/states/share_bdsd_state.dart';
import 'package:vierqr/features/bank_detail/views/bottom_sheet_add_bank_bdsd.dart';
import 'package:vierqr/features/bank_detail/views/bottom_sheet_add_user_bdsd.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/member_branch_model.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import '../../../commons/widgets/button_icon_widget.dart';

class ShareBDSDInviteScreen extends StatelessWidget {
  final String bankId;
  final AccountBankDetailDTO dto;

  const ShareBDSDInviteScreen(
      {super.key, required this.bankId, required this.dto});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShareBDSDBloc>(
      create: (BuildContext context) => ShareBDSDBloc(context),
      child: _ShareBDSDScreen(
        bankId: bankId,
        dto: dto,
      ),
    );
  }
}

class _ShareBDSDScreen extends StatefulWidget {
  final String bankId;
  final AccountBankDetailDTO dto;

  const _ShareBDSDScreen({required this.bankId, required this.dto});

  @override
  State<_ShareBDSDScreen> createState() => _ShareBDSDInviteState();
}

class _ShareBDSDInviteState extends State<_ShareBDSDScreen> {
  late ShareBDSDBloc _bloc;

  String get userId => UserInformationHelper.instance.getUserId();

  List<MemberBranchModel> listMemberData = [];
  List<MemberBranchModel> listMember = [];

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  initData() {
    // _bloc.add(GetInfoTelegramEvent(bankId: widget.bankId, isLoading: true));
    // _bloc.add(GetInfoLarkEvent(bankId: widget.bankId));
    // _bloc.add(GetMemberEvent(bankId: widget.bankId));
  }

  Future<void> onRefresh() async {
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(title: 'Chia sẻ BDSD'),
      body: ChangeNotifierProvider<ShareBDSDInviteProvider>(
        create: (context) => ShareBDSDInviteProvider(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocConsumer<ShareBDSDBloc, ShareBDSDState>(
            listener: (context, state) {
              if (state.status == BlocStatus.LOADING) {
                DialogWidget.instance.openLoadingDialog();
              }

              if (state.status == BlocStatus.UNLOADING) {
                Navigator.pop(context);
              }

              if (state.request == ShareBDSDType.MEMBER) {
                if (state.listMember.length >= 1) {
                  listMember = state.listMember;
                  listMember.removeWhere((member) => member.isOwner);
                  listMemberData = listMember;
                }
              }
            },
            builder: (context, state) {
              return ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Thông tin nhóm',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'Tên nhóm*',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text('Tên nhóm tối đa 50 ký tự',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.GREY_TEXT,
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    padding: EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                        color: AppColor.WHITE,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Nhập tên nhóm',
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          hintStyle: TextStyle(
                              color: AppColor.GREY_TEXT, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Mã nhóm',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                      'Mã nhóm tối đa 10 ký tự. Có thể tự nhập hoặc gắn giá trị ngẫu nhiên.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.GREY_TEXT,
                      )),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 12),
                          padding: EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                              color: AppColor.WHITE,
                              borderRadius: BorderRadius.circular(5)),
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: 'Nhập mã nhóm',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                hintStyle: TextStyle(
                                    color: AppColor.GREY_TEXT, fontSize: 13)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: ButtonWidget(
                            height: 46,
                            borderRadius: 5,
                            fontSize: 12,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            text: 'Tạo ngẫu nhiên',
                            textColor: AppColor.BLUE_TEXT,
                            bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
                            function: () {}),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Địa chỉ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    padding: EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                        color: AppColor.WHITE,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Nhập địa chỉ',
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                          hintStyle: TextStyle(
                              color: AppColor.GREY_TEXT, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _addBankAccount(),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thành viên*',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Thêm thành viên để nhận chia sẻ biến động số dư.',
                            style: TextStyle(
                                fontSize: 11, color: AppColor.GREY_TEXT),
                          )
                        ],
                      )),
                      ButtonIconWidget(
                        borderRadius: 5,
                        height: 36,
                        title: 'Thành viên mới',
                        function: () async {
                          await DialogWidget.instance.showModelBottomSheet(
                            isDismissible: true,
                            height: MediaQuery.of(context).size.height * 0.7,
                            margin: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10, top: 200),
                            borderRadius: BorderRadius.circular(16),
                            widget: BottomSheetAddUserBDSD(
                              bankId: widget.bankId,
                              onSelect: (dto){

                              },
                            ),
                          );
                          // _bloc.add(GetMemberEvent(bankId: widget.bankId));
                        },
                        textSize: 11,
                        contentPadding: EdgeInsets.only(left: 4, right: 12),
                        bgColor: AppColor.BLUE_TEXT,
                        textColor: AppColor.WHITE,
                        pathIcon: 'assets/images/ic-add-member-bdsd-white.png',
                      )
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _addBankAccount() {
    return Consumer<ShareBDSDInviteProvider>(builder: (context, provider, _) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tài khoản chia sẻ BĐSD*',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Thêm tài khoản để chia sẻ biến động số dư.',
                    style: TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
                  )
                ],
              )),
              ButtonIconWidget(
                borderRadius: 5,
                height: 36,
                title: 'Thêm TK',
                function: () async {
                  await DialogWidget.instance.showModelBottomSheet(
                    isDismissible: true,
                    padding: EdgeInsets.only(left: 12, right: 12, bottom: 32),
                    height: MediaQuery.of(context).size.height * 0.8,
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    borderRadius: BorderRadius.circular(16),
                    widget: BottomSheetAddBankBDSD(
                      onSelect: (bankAccount) async {
                        if (provider.bankAccounts.isNotEmpty) {
                          bool existed = false;
                          await Future.forEach(provider.bankAccounts,
                              (BankAccountDTO bank) async {
                            if (bank.id == bankAccount.id) {
                              existed = true;
                              DialogWidget.instance.openMsgDialog(
                                  title: 'Thêm tài khoản',
                                  msg: 'Tài khoản ngân hàng này đã được thêm');
                            }
                          });
                          if (!existed) {
                            provider.addListBankAccount(bankAccount);
                            // final Map<String, dynamic> body = {
                            //   'id': dto.id,
                            //   'userId': UserInformationHelper.instance.getUserId(),
                            //   'bankId': bankAccount.id,
                            // };
                            //
                            // BlocProvider.of<ConnectLarkBloc>(context)
                            //     .add(AddBankLarkEvent(body));
                          }
                        } else {
                          provider.addListBankAccount(bankAccount);
                        }
                      },
                    ),
                  );
                },
                textSize: 11,
                contentPadding: EdgeInsets.only(left: 8, right: 12),
                bgColor: AppColor.BLUE_TEXT,
                textColor: AppColor.WHITE,
                pathIcon: 'assets/images/ic-add-new-qr-wallet.png',
              )
            ],
          ),
          if (provider.bankAccounts.isNotEmpty)
            ...provider.bankAccounts.map((e) {
              return _buildItemBank(e);
            }).toList(),
        ],
      );
    });
  }

  Widget _buildItemBank(BankAccountDTO dto) {
    return Row(
      children: [Text(dto.bankAccount)],
    );
  }
}
