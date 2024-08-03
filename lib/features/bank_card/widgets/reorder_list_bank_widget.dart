import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/models/bank_account_dto.dart';

class ReOrderListBankWidget extends StatefulWidget {
  final List<BankAccountDTO> list;
  const ReOrderListBankWidget({super.key, required this.list});

  @override
  State<ReOrderListBankWidget> createState() => _ReOrderListBankWidgetState();
}

class _ReOrderListBankWidgetState extends State<ReOrderListBankWidget> {
  List<BankAccountDTO> list = [];
  @override
  void initState() {
    super.initState();
    list = widget.list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Danh sách TK ngân hàng',
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
        const SizedBox(height: 8),
        RichText(
          text: const TextSpan(
              text: 'Giữ và kéo biểu tượng  ',
              style: TextStyle(fontSize: 14, color: AppColor.BLACK),
              children: [
                WidgetSpan(
                    child: Icon(
                  Icons.menu,
                  size: 15,
                )),
                TextSpan(text: '  để sắp xếp thứ tự\n'),
                TextSpan(text: 'hiện thị tài khoản ngân hàng của bạn.')
              ]),
        ),
        const SizedBox(height: 25),
        Expanded(
            child: AnimatedReorderableListView(
          onReorder: (oldIndex, newIndex) {
            setState(() {
              final BankAccountDTO dto = list.removeAt(oldIndex);
              list.insert(newIndex, dto);
            });
          },
          items: widget.list,
          enterTransition: [FlipInX(), ScaleIn()],
          exitTransition: [SlideInLeft()],
          insertDuration: const Duration(milliseconds: 300),
          removeDuration: const Duration(milliseconds: 300),
          itemBuilder: (context, index) {
            BankAccountDTO bank = list[index];
            return Container(
              key: Key(list[index].id),
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.GREY_DADADA),
                      image: DecorationImage(
                        image: ImageUtils.instance.getImageNetWork(bank.imgId),
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
                          bank.bankAccount,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          bank.userBankName,
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.menu,
                    size: 20,
                  )
                ],
              ),
            );
          },
        )),
        const SizedBox(height: 15),
        VietQRButton.gradient(
            borderRadius: 50,
            width: double.infinity,
            size: VietQRButtonSize.medium,
            onPressed: () {
              Navigator.of(context).pop(list);
            },
            isDisabled: false,
            child: const Center(
              child: Text(
                'Lưu thay đổi',
                style: TextStyle(fontSize: 14, color: AppColor.WHITE),
              ),
            )),
      ],
    );
  }
}
