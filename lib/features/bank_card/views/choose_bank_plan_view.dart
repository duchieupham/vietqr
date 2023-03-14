import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_card/widgets/check_existed_business_widget.dart';
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
    final double height = MediaQuery.of(context).size.height;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        _buildTitle('Liên kết tài khoản ngân hàng doanh nghiệp'),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        UnconstrainedBox(
          child: Image.asset(
            'assets/images/ic-business-card.png',
            width: width * 0.6,
          ),
        ),
        const Text(
          '-   Tạo mã VietQR thanh toán',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 5),
        ),
        const Text(
          '-   Đối soát giao dịch',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 5),
        ),
        const Text(
          '-   Quản lý doanh nghiệp, chi nhánh',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 5),
        ),
        const Text(
          '-   Nhận thông báo các giao dịch',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 5),
        ),
        const Text(
          '-   Liên kết với Telegram',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        ButtonWidget(
          width: width,
          height: 40,
          borderRadius: 5,
          text: 'Liên kết TK ngân hàng doanh nghiệp',
          textColor: DefaultTheme.WHITE,
          bgColor: DefaultTheme.GREEN,
          function: () async {
            await DialogWidget.instance
                .showModalBottomContent(
              widget: const CheckExistedBusinessWidget(),
              height: height * 0.6,
            )
                .then(
              (value) {
                if (value != null) {
                  if (value == true) {
                    _animatedToPage(1);
                  }
                }
              },
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        _buildTitle('Liên kết tài khoản ngân hàng cá nhân'),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        UnconstrainedBox(
          child: Image.asset(
            'assets/images/ic-personal-card.png',
            width: width * 0.6,
          ),
        ),
        const Text(
          '-   Tạo mã VietQR thanh toán',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        ButtonWidget(
          width: width,
          height: 40,
          borderRadius: 5,
          text: 'Liên kết TK ngân hàng cá nhân',
          textColor: DefaultTheme.WHITE,
          bgColor: DefaultTheme.GREEN,
          function: () {
            Provider.of<AddBankProvider>(context, listen: false).updateType(0);
            _animatedToPage(1);
          },
        ),
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
