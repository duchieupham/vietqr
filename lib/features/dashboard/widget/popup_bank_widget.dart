import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/helper/dialog_helper.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/providers/invoice_provider.dart';
import 'package:vierqr/services/providers/maintain_charge_provider.dart';

class PopupBankWidget extends StatefulWidget {
  const PopupBankWidget({super.key});

  @override
  State<PopupBankWidget> createState() => _PopupBankWidgetState();
}

class _PopupBankWidgetState extends State<PopupBankWidget> with DialogHelper {
  List<BankAccountDTO> list = [];
  @override
  void initState() {
    super.initState();

    list = [...Provider.of<InvoiceProvider>(context, listen: false).listBank!];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 20, height: 20),
              const XImage(
                imagePath: 'assets/images/ic-viet-qr.png',
                width: 80,
                height: 40,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.clear,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Danh sách tài khoản ngân hàng đã liên kết của bạn.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Chọn tài khoản để đăng ký dịch vụ',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0),
              itemBuilder: (context, index) {
                return _itemBank(list[index], index);
              },
              itemCount: list.length,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _itemBank(
    BankAccountDTO dto,
    int index,
  ) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        Provider.of<MaintainChargeProvider>(context, listen: false)
            .selectedBank(dto.bankAccount, dto.bankShortName);
        showDialogActiveKey(
          context,
          bankId: dto.id,
          bankCode: dto.bankCode,
          bankName: dto.bankName,
          bankAccount: dto.bankAccount,
          userBankName: dto.userBankName,
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 75,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 0.5, color: Colors.grey),
                        image: DecorationImage(
                          image: ImageUtils.instance.getImageNetWork(dto.imgId),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 170,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dto.bankAccount,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          Text(dto.userBankName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
        ],
      ),
    );
  }
}
