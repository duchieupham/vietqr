import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/features/top_up/blocs/top_up_bloc.dart';
import 'package:vierqr/features/top_up/events/scan_qr_event.dart';
import 'package:vierqr/features/top_up/states/top_up_state.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/account_information_dto.dart';
import 'package:vierqr/services/providers/top_up_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class TopUpScreen extends StatelessWidget {
  const TopUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => TopUpProvider(),
        child: BlocProvider<TopUpBloc>(
          create: (context) => TopUpBloc(),
          child:
              BlocConsumer<TopUpBloc, TopUpState>(listener: (context, state) {
            if (state is TopUpLoadingState) {
              DialogWidget.instance.openLoadingDialog();
            }
            if (state is TopUpCreateQrSuccessState) {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.QR_TOP_UP,
                  arguments: state.dto);
            }
            if (state is TopUpCreateQrFailedState) {
              Navigator.pop(context);
              DialogWidget.instance.openMsgDialog(
                  title: 'Đã có lỗi xảy ra', msg: 'Vui lòng thử lại sau');
            }
          }, builder: (context, state) {
            return Column(
              children: [
                SubHeader(
                  title: 'Nạp tiền',
                  function: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Future.delayed(const Duration(milliseconds: 200), () {
                      Navigator.of(context).pop();
                    });
                  },
                  callBackHome: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      _buildTemplateSection('Tài khoản',
                          child: _buildAccountInfo(context,
                              accountInformationDTO: UserInformationHelper
                                  .instance
                                  .getAccountInformation(),
                              phoneNumber:
                                  UserInformationHelper.instance.getPhoneNo())),
                      const SizedBox(
                        height: 28,
                      ),
                      _buildTemplateSection('Số tiền cần nạp',
                          child: _buildTopUp())
                    ],
                  ),
                ),
                Consumer<TopUpProvider>(builder: (context, provider, child) {
                  return MButtonWidget(
                    title: 'Thanh toán',
                    isEnable: provider.errorMoney.isEmpty,
                    colorEnableText: provider.errorMoney.isEmpty
                        ? AppColor.WHITE
                        : AppColor.GREY_TEXT,
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Map<String, dynamic> data = {};
                      data['phoneNo'] =
                          UserInformationHelper.instance.getPhoneNo();
                      data['amount'] = provider.money.replaceAll('.', '');
                      data['transType'] = 'C';
                      BlocProvider.of<TopUpBloc>(context)
                          .add(TopUpEventCreateQR(data: data));
                    },
                  );
                }),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAccountInfo(BuildContext context,
      {required AccountInformationDTO accountInformationDTO,
      required String phoneNumber}) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                const Text('Tài khoản nạp tiền:'),
                const Spacer(),
                Text(
                  phoneNumber,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 0.2,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Row(
              children: [
                (accountInformationDTO.imgId.isNotEmpty)
                    ? Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: ImageUtils.instance
                                .getImageNetWork(accountInformationDTO.imgId),
                          ),
                        ),
                      )
                    : ClipOval(
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Image.asset('assets/images/ic-avatar.png'),
                        ),
                      ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${accountInformationDTO.lastName} ${accountInformationDTO.middleName} ${accountInformationDTO.firstName}'
                            .trim(),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        phoneNumber,
                        style: const TextStyle(
                            fontSize: 13, color: AppColor.GREY_TEXT),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopUp() {
    return Consumer<TopUpProvider>(builder: (context, provider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MTextFieldCustom(
            isObscureText: false,
            maxLines: 1,
            value: provider.money,
            fillColor: AppColor.WHITE,
            autoFocus: true,
            hintText: 'Nhập số tiền muốn nạp',
            inputType: TextInputType.number,
            keyboardAction: TextInputAction.next,
            onChange: provider.updateMoney,
            suffixIcon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'VND',
                  style: TextStyle(fontSize: 14, color: AppColor.gray),
                ),
              ],
            ),
            inputFormatter: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          if (provider.errorMoney.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                provider.errorMoney,
                style: const TextStyle(fontSize: 13, color: AppColor.RED_TEXT),
              ),
            ),
          const SizedBox(
            height: 16,
          ),
          _buildSuggestMoney(provider),
          const SizedBox(
            height: 28,
          ),
          _buildTemplateSection('Phương thức thanh toán',
              child: _buildPaymentMethods())
        ],
      );
    });
  }

  Widget _buildSuggestMoney(TopUpProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildItemSuggest(
                  onChange: (value) {
                    provider.updateMoney(value);
                  },
                  text: '10.000'),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: _buildItemSuggest(
                  onChange: (value) {
                    provider.updateMoney(value);
                  },
                  text: '20.000'),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: _buildItemSuggest(
                  onChange: (value) {
                    provider.updateMoney(value);
                  },
                  text: '50.000'),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Expanded(
              child: _buildItemSuggest(
                  onChange: (value) {
                    provider.updateMoney(value);
                  },
                  text: '100.000'),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: _buildItemSuggest(
                  onChange: (value) {
                    provider.updateMoney(value);
                  },
                  text: '200.000'),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: _buildItemSuggest(
                  onChange: (value) {
                    provider.updateMoney(value);
                  },
                  text: '500.000'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.WHITE,
        border: Border.all(color: AppColor.BLUE_TEXT, width: 0.5),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/ic-viet-qr.png',
            height: 20,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Mã VietQR VN',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                'Quét mã VietQR để thực hiện thanh toán',
                style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
              ),
            ],
          )),
          Container(
            height: 10,
            width: 10,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppColor.BLUE_TEXT,
                borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: 5,
              width: 5,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemSuggest({
    ValueChanged<String>? onChange,
    required String text,
  }) {
    return GestureDetector(
      onTap: () {
        onChange!(text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColor.BLUE_TEXT, width: 0.4),
          color: AppColor.BLUE_TEXT.withOpacity(0.3),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateSection(String title, {required Widget child}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(
          height: 8,
        ),
        child,
      ],
    );
  }
}
