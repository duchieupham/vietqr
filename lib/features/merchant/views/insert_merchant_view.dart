import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/merchant/merchant.dart';
import 'package:vierqr/features/store/create_store/states/create_store_state.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class InsertMerchantView extends StatefulWidget {
  final Map<String, dynamic> param;

  const InsertMerchantView({super.key, required this.param});

  @override
  State<InsertMerchantView> createState() => _InfoStoreViewState();
}

class _InfoStoreViewState extends State<InsertMerchantView> {
  late MerchantBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = MerchantBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MerchantBloc>(
      create: (context) => bloc,
      child: BlocConsumer<MerchantBloc, MerchantState>(
        listener: (context, state) {
          if (state.status == BlocStatus.LOADING_PAGE) {
            DialogWidget.instance.openLoadingDialog();
          }

          if (state.status == BlocStatus.UNLOADING) {
            Navigator.pop(context);
          }
          if (state.request == MerchantType.INSERT_MERCHANT) {
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: 'Tạo thành công',
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
          if (state.status == MerchantType.ERROR) {
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
                'Thông tin đại lý của bạn\nđã chính xác chứ?',
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
                    _buildItem('Đại lý:', widget.param['merchantName']),
                    _buildItem('Tài khoản ngân hàng:',
                        '${widget.param['bankShortName']} - ${widget.param['bankAccount']}'),
                    _buildItem('CCCD/MST:', widget.param['nationalId']),
                    _buildItem('Số điện thoại xác thực:',
                        widget.param['phoneAuthenticated']),
                  ],
                ),
              ),
              MButtonWidget(
                title: 'Xác thực',
                isEnable: true,
                margin: EdgeInsets.zero,
                onTap: _onInsertMerchant,
              ),
            ],
          );
        },
      ),
    );
  }

  void _onInsertMerchant() {
    if (widget.param.containsKey('bankShortName')) {
      widget.param.remove('bankShortName');
    }

    bloc.add(InsertMerchantEvent(widget.param));
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
