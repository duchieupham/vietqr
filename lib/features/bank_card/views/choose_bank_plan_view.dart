import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_card/widgets/check_existed_business_widget.dart';
import 'package:vierqr/features/bank_card/widgets/choose_bank_type_widget.dart';
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
    final double height = MediaQuery.of(context).size.height;
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
          '-   Nội dung miêu tả ',
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
          // text: 'Liên kết TK ngân hàng doanh nghiệp',
          text: 'Thêm TK ngân hàng',
          textColor: DefaultTheme.WHITE,
          bgColor: DefaultTheme.GREEN,
          function: () async {
            await DialogWidget.instance
                .showModalBottomContent(
              widget: const ChooseBankTypeWidget(),
              height: height * 0.3,
            )
                .then(
              (value) async {
                if (value != null) {
                  if (value == 0) {
                    Provider.of<AddBankProvider>(context, listen: false)
                        .updateType(0);
                    _animatedToPage(1);
                  } else if (value == 1) {
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
                  }
                }
              },
            );
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
        //   '-   Nội dung miêu tả ',
        //   style: TextStyle(
        //     fontSize: 15,
        //   ),
        // ),
        // const Padding(
        //   padding: EdgeInsets.only(top: 10),
        // ),
        // ButtonWidget(
        //   width: width,
        //   height: 40,
        //   borderRadius: 5,
        //   text: 'Liên kết TK ngân hàng',
        //   textColor: DefaultTheme.WHITE,
        //   bgColor: DefaultTheme.GREEN,
        //   function: () {
        //     // Provider.of<AddBankProvider>(context, listen: false).updateType(0);
        //     // _animatedToPage(1);
        //     DialogWidget.instance.openMsgDialog(
        //       title: 'Đang phát triển',
        //       msg: 'Tính năng đang được phát triển',
        //     );
        //   },
        // ),
        const Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        _buildTitle('Mở TK ngân hàng MBBank'),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        const Text(
          '-   Nội dung miêu tả ',
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
          text: 'Mở TK MBBank',
          textColor: DefaultTheme.WHITE,
          bgColor: DefaultTheme.GREEN,
          function: () {
            // Provider.of<AddBankProvider>(context, listen: false).updateType(0);
            // _animatedToPage(1);
            DialogWidget.instance.openMsgDialog(
              title: 'Đang phát triển',
              msg: 'Tính năng đang được phát triển',
            );
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
