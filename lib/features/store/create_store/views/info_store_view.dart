import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/store/create_store/bloc/create_store_bloc.dart';
import 'package:vierqr/features/store/create_store/events/create_store_event.dart';
import 'package:vierqr/features/store/create_store/states/create_store_state.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/bank_account_terminal.dart';
import 'package:vierqr/models/detail_group_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class InfoStoreView extends StatefulWidget {
  final String storeName;
  final String storeCode;
  final String storeAddress;
  final BankAccountTerminal dto;
  final List<AccountMemberDTO> members;

  const InfoStoreView(
      {super.key,
      required this.storeName,
      required this.storeCode,
      required this.storeAddress,
      required this.dto,
      required this.members});

  @override
  State<InfoStoreView> createState() => _InfoStoreViewState();
}

class _InfoStoreViewState extends State<InfoStoreView> {
  late CreateStoreBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = CreateStoreBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateStoreBloc>(
      create: (context) => bloc,
      child: BlocConsumer<CreateStoreBloc, CreateStoreState>(
        listener: (context, state) {
          if (state.status == BlocStatus.LOADING_PAGE) {
            DialogWidget.instance.openLoadingDialog();
          }

          if (state.status == BlocStatus.UNLOADING) {
            Navigator.pop(context);
          }
          if (state.request == StoreType.CREATE_SUCCESS) {
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: 'Tạo group thành công',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
            );
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
          if (state.status == BlocStatus.ERROR) {
            Navigator.pop(context);
            DialogWidget.instance.openMsgDialog(
                title: 'Không thể tạo',
                msg: ErrorUtils.instance.getErrorMessage(state.msg ?? ''));
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Thông tin cửa hàng của bạn\nđã chính xác chứ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Column(
                  children: [
                    _buildItem('Cửa hàng:', widget.storeName),
                    _buildItem('Tài khoản nhận tiền:',
                        '${widget.dto.bankShortName} - ${widget.dto.bankAccount}'),
                    _buildItem('Mã cửa hàng:', widget.storeCode),
                    _buildItem('Địa chỉ cửa hàng:', widget.storeAddress),
                    _buildItem(
                        'Nhân viên:', '${widget.members.length} nhân viên',
                        isUnBorder: true),
                  ],
                ),
              ),
              MButtonWidget(
                title: 'Tạo cửa hàng',
                isEnable: true,
                margin: EdgeInsets.zero,
                onTap: _onCreateStore,
              ),
            ],
          );
        },
      ),
    );
  }

  void _onCreateStore() {
    Map<String, dynamic> param = {};
    List<String> userIds = [];
    for (var e in widget.members) {
      userIds.add(e.id);
    }

    param['address'] = widget.storeAddress;
    param['name'] = widget.storeName;
    param['code'] = widget.storeCode;
    param['bankIds'] = [widget.dto.bankId];
    param['userIds'] = userIds;
    param['userId'] = SharePrefUtils.getProfile().userId;

    bloc.add(CreateNewStoreEvent(param));
  }

  Widget _buildItem(String title, String content, {bool isUnBorder = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        border: isUnBorder
            ? null
            : Border(
                bottom: BorderSide(
                    color: AppColor.grey979797.withOpacity(0.3), width: 2),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, maxLines: 1),
          const SizedBox(height: 4),
          Text(
            content,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
