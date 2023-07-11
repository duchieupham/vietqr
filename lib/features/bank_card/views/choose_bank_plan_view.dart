import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
// import 'package:vierqr/commons/widgets/dialog_widget.dart';
// import 'package:vierqr/features/bank_card/widgets/check_existed_business_widget.dart';
import 'package:vierqr/services/providers/add_bank_provider.dart';

class ChooseBankPlanView extends StatelessWidget {
  final PageController pageController;

  const ChooseBankPlanView({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        UnconstrainedBox(
          child: Image.asset(
            'assets/images/ic-card.png',
            width: width * 0.6,
          ),
        ),
        _buildTitle('Thêm tài khoản ngân hàng'),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        const Text(
          '-   Tạo mã VietQR',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        ButtonIconWidget(
          width: width,
          height: 40,
          borderRadius: 5,
          icon: Icons.credit_card_rounded,
          title: 'Thêm TK ngân hàng',
          textColor: AppColor.WHITE,
          bgColor: AppColor.GREEN,
          function: () {
            Provider.of<AddBankProvider>(context, listen: false)
                .updateSelect(1);
            Provider.of<AddBankProvider>(context, listen: false)
                .updateRegisterAuthentication(false);
            _animatedToPage(1);
          },
        ),
        // const Padding(
        //   padding: EdgeInsets.only(top: 30),
        // ),
        // _buildTitle('Liên kết tài khoản ngân hàng'),
        // const Padding(
        //   padding: EdgeInsets.only(top: 10),
        // ),
        // const Text(
        //   '-   Quản lý đối soát thanh toán\n(Hiện tại hệ thống chỉ hỗ trợ ngân hàng MB Bank).',
        //   style: TextStyle(
        //     fontSize: 15,
        //   ),
        // ),
        // const Padding(
        //   padding: EdgeInsets.only(top: 10),
        // ),
        // ButtonIconWidget(
        //   width: width,
        //   height: 40,
        //   borderRadius: 5,
        //   icon: Icons.link_rounded,
        //   bgColor: DefaultTheme.PURPLE_NEON,
        //   title: 'Liên kết TK ngân hàng',
        //   textColor: DefaultTheme.WHITE,
        //   function: () async {
        //     await DialogWidget.instance
        //         .showModalBottomContent(
        //       widget: const ChooseBankTypeWidget(),
        //       height: height * 0.3,
        //     )
        //         .then(
        //       (value) async {
        //         if (value != null) {
        //           if (value == 0) {
        //             Provider.of<AddBankProvider>(context, listen: false)
        //                 .updateType(0);
        //             _animatedToPage(1);
        //           } else if (value == 1) {
        //             await DialogWidget.instance
        //                 .showModalBottomContent(
        //               widget: const CheckExistedBusinessWidget(),
        //               height: height * 0.6,
        //             )
        //                 .then(
        //               (value) {
        //                 if (value != null) {
        //                   if (value == true) {
        //                     _animatedToPage(2);
        //                   }
        //                 }
        //               },
        //             );
        //           }
        //         }
        //       },
        //     );
        //   },
        // ),
        // const Padding(
        //   padding: EdgeInsets.only(top: 30),
        // ),
        // _buildTitle('Mở tài khoản ngân hàng MB Bank'),
        // const Padding(
        //   padding: EdgeInsets.only(top: 10),
        // ),
        // const Text(
        //   '-   Hệ thống hỗ trợ mở tài khoản MB Bank trực tiếp.',
        //   style: TextStyle(
        //     fontSize: 15,
        //   ),
        // ),
        // const Padding(
        //   padding: EdgeInsets.only(top: 10),
        // ),
        // ButtonIconWidget(
        //   width: width,
        //   height: 40,
        //   borderRadius: 5,
        //   icon: Icons.account_balance_rounded,
        //   title: 'Mở TK MB Bank',
        //   textColor: DefaultTheme.WHITE,
        //   bgColor: DefaultTheme.BLUE_DARK,
        //   function: () {
        //     // Provider.of<AddBankProvider>(context, listen: false).updateType(0);
        //     // _animatedToPage(1);
        //     DialogWidget.instance.openMsgDialog(
        //       title: 'Đang phát triển',
        //       msg: 'Tính năng đang được phát triển',
        //     );
        //   },
        // ),
      ],
    );
  }

  //type = 0 => personal card
  //type = 1 => business card
  //navigate to page
  void _animatedToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutQuart,
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
