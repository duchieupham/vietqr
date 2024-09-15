import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/helper/dialog_helper.dart';
import 'package:vierqr/commons/utils/format_date.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/button_gradient_border_widget.dart';
import 'package:vierqr/features/add_bank/add_bank_screen.dart';
import 'package:vierqr/features/bank_detail_new/bank_card_detail_new_screen.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';

class BankInfroV2Widget extends StatefulWidget {
  final BankAccountDTO dto;
  final bool isLoading;
  const BankInfroV2Widget(
      {super.key, required this.dto, required this.isLoading});

  @override
  State<BankInfroV2Widget> createState() => _BankInfroV2WidgetState();
}

List<String> contents = [
  'Trải nghiệm sự tiện lợi của VietQR ngay hôm nay! Đăng ký để tận hưởng thanh toán không chạm, quản lý tài chính thông minh và nhiều tính năng hữu ích khác đang chờ đón bạn!',
  'Gia hạn ngay, trải nghiệm trọn vẹn! Đừng để mất đi những tiện ích tuyện vời của VietQR. Gia hạn ngay để tiếp tục thanh toán không chạm, quản lý tài chính thông minh và nhiều hơn nữa.',
  'Dịch vụ của bạn đã quá hạn. Đừng bỏ lỡ những trải nghiệm tuyệt vời mà chúng tôi mang lại! Hãy gia hạn ngay hôm nay để khám phá lại những tính năng mới và nhiều lợi ích hấp dẫn đang chờ đón bạn!'
];

class _BankInfroV2WidgetState extends State<BankInfroV2Widget>
    with DialogHelper {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: const Color(
                        0xFFE1EFFF), // Change this to your desired color
                    width: 2.0, // Adjust the border width as needed
                  ),
                ),
                child: Image(
                  image: ImageUtils.instance.getImageNetWork(widget.dto.imgId),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  widget.dto.bankAccount,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  widget.dto.isAuthenticated
                      ? ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF9CD740),
                              Color(0xFF2BACE6),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: const Text(
                            'Đã liên kết',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () async {
                            await NavigatorUtils.navigatePage(
                                context, const AddBankScreen(),
                                routeName: AddBankScreen.routeName);
                          },
                          child: const Text(
                            'Liên kết ngay',
                            style: TextStyle(
                              color: AppColor.ORANGE_DARK,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColor.ORANGE_DARK,
                              decorationThickness: 2,
                              fontSize: 12,
                            ),
                          ),
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      if (widget.dto.isAuthenticated) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BankCardDetailNewScreen(
                                page: 0,
                                dto: widget.dto,
                                bankId: widget.dto.id),
                            settings: const RouteSettings(
                              name: Routes.BANK_CARD_DETAIL_NEW,
                            ),
                          ),
                        );
                      } else {
                        await NavigatorUtils.navigatePage(
                            context, const AddBankScreen(),
                            routeName: AddBankScreen.routeName);
                      }
                    },
                    child: Container(
                      width: 80,
                      height: 25,
                      decoration: BoxDecoration(
                        color: AppColor.BLUE_E1EFFF,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          XImage(
                            imagePath: 'assets/images/ic-i-black.png',
                            width: 20,
                            height: 20,
                          ),
                          Text(
                            'Chi tiết',
                            style: TextStyle(
                              color: AppColor.BLACK,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if(!widget.dto.isAuthenticated) 
          const SizedBox.shrink()
          else if(inclusiveDays(widget.dto.validFeeTo) > 15 &&
              widget.dto.isAuthenticated) ...[
            const SizedBox(
              height: 15,
            ),
            GradientBorderButton(
              gradient: VietQRTheme.gradientColor.aiTextColor,
              borderRadius: BorderRadius.circular(10),
              borderWidth: 1.5,
              widget: Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const XImage(
                          imagePath: 'assets/images/ic-suggest.png',
                          width: 30,
                        ),
                        Expanded(
                          flex: 1,
                          child: ShaderMask(
                            shaderCallback: (bounds) => VietQRTheme
                                .gradientColor.aiTextColor
                                .createShader(bounds),
                            child: const Text(
                              'Gia hạn dịch vụ VietQR',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.WHITE,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),

                        //sắp hết hạn
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            'Đến ${timestampToDate(widget.dto.validFeeTo)}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColor.BLACK,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),

                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          weight: 1,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ] else ...[
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                showDialogActiveKey(
                  context,
                  bankId: widget.dto.id,
                  bankCode: widget.dto.bankCode,
                  bankName: widget.dto.bankName,
                  bankAccount: widget.dto.bankAccount,
                  userBankName: widget.dto.userBankName,
                );
              },
              child: GradientBorderButton(
                gradient: VietQRTheme.gradientColor.aiTextColor,
                borderRadius: BorderRadius.circular(10),
                borderWidth: 1.5,
                widget: Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const XImage(
                            imagePath: 'assets/images/ic-suggest.png',
                            width: 30,
                          ),
                          Expanded(
                            flex: 1,
                            child: ShaderMask(
                              shaderCallback: (bounds) => VietQRTheme
                                  .gradientColor.aiTextColor
                                  .createShader(bounds),
                              child: Text(
                                (widget.dto.isValidService &&
                                        widget.dto.validFeeTo != 0 &&
                                        inclusiveDays(widget.dto.validFeeTo) <=
                                            15)
                                    ? 'Gia hạn dịch vụ VietQR'
                                    : 'Đăng ký dịch vụ VietQR',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColor.WHITE,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),

                          //sắp hết hạn
                          if (widget.dto.isValidService &&
                              widget.dto.validFeeTo != 0 &&
                              inclusiveDays(widget.dto.validFeeTo) <= 15 &&
                              inclusiveDays(widget.dto.validFeeTo) >= 0)
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                inclusiveDays(widget.dto.validFeeTo) == 0
                                    ? 'Hạn ngày cuối'
                                    : 'Còn ${inclusiveDays(widget.dto.validFeeTo)} ngày',
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      inclusiveDays(widget.dto.validFeeTo) == 0
                                          ? AppColor.RED_FFFF0000
                                          : AppColor.ORANGE_DARK,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          //dã quá hạn
                          if (widget.dto.validFeeTo != 0 &&
                              inclusiveDays(widget.dto.validFeeTo) < 0)
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                'Quá hạn ${inclusiveDays(widget.dto.validFeeTo).abs()} ngày',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppColor.RED_FFFF0000,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            weight: 1,
                          )
                        ],
                      ),
                      // const SizedBox(height: ,)

                      //chưa sử đăng ký
                      if (widget.dto.validFeeTo == 0)
                        SizedBox(
                          width: 345,
                          child: Text(
                            contents[0],
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),

                      //sắp hết hạn
                      if (widget.dto.isValidService &&
                          widget.dto.validFeeTo != 0 &&
                          inclusiveDays(widget.dto.validFeeTo) <= 15 &&
                          inclusiveDays(widget.dto.validFeeTo) > 0)
                        SizedBox(
                          width: 345,
                          child: Text(
                            contents[1],
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),

                      //đã quá hạn
                      if (widget.dto.validFeeTo != 0 &&
                          inclusiveDays(widget.dto.validFeeTo) <= 0)
                        SizedBox(
                          width: 345,
                          child: Text(
                            contents[2],
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}
