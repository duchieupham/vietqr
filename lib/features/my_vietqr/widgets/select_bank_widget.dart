import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';

class SelectBankWidget extends StatefulWidget {
  final List<BankAccountDTO> listBank;
  final BankAccountDTO selectedBank;
  const SelectBankWidget(
      {super.key, required this.listBank, required this.selectedBank});

  @override
  State<SelectBankWidget> createState() => _SelectBankWidgetState();
}

class _SelectBankWidgetState extends State<SelectBankWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Chọn tài khoản ngân hàng',
                style: TextStyle(fontSize: 20),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.close,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Expanded(
            child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  BankAccountDTO selectBank = widget.listBank[index];
                  bool isSelect = widget.selectedBank.id == selectBank.id;
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop(selectBank);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      color:
                          isSelect ? AppColor.BLUE_BGR : AppColor.TRANSPARENT,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColor.WHITE,
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: ImageUtils.instance
                                    .getImageNetWork(selectBank.imgId),
                              ),
                            ),
                            // child: XImage(imagePath: e.imgId),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  selectBank.bankAccount,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  selectBank.userBankName,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          const XImage(
                            imagePath: 'assets/images/ic-next-black.png',
                            width: 30,
                            height: 30,
                            color: AppColor.BLACK,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: MySeparator(
                        color: AppColor.GREY_DADADA,
                      ),
                    ),
                itemCount: widget.listBank.length)),
      ],
    );
  }
}
