import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/logo_utils.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/bank_account_dto.dart';

class BankInformationWidget extends StatelessWidget {
  final double width;
  final double? height;
  final BankAccountDTO bankAccountDTO;
  final bool? isCopy;
  final IconData? icon;
  final bool? enableShadow;

  const BankInformationWidget({
    super.key,
    required this.width,
    required this.bankAccountDTO,
    this.height,
    this.isCopy,
    this.icon,
    this.enableShadow,
  });

  @override
  Widget build(BuildContext context) {
    return BoxLayout(
      width: width,
      height: height,
      borderRadius: 5,
      enableShadow: enableShadow,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColor.WHITE,
              image: DecorationImage(
                image: AssetImage(
                  LogoUtils.instance.getAssetImageBank(bankAccountDTO.bankCode),
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bankAccountDTO.bankName.trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColor.GREY_TEXT,
                  ),
                ),
                Text(
                  bankAccountDTO.bankName.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  bankAccountDTO.bankAccount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColor.GREEN,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          (isCopy != null && isCopy!)
              ? InkWell(
                  onTap: () async {
                    String bankInformationString =
                        '${bankAccountDTO.bankName}\n${bankAccountDTO.bankName.toUpperCase()}\n${bankAccountDTO.bankAccount}';

                    await FlutterClipboard.copy(bankInformationString).then(
                      (value) => Fluttertoast.showToast(
                        msg: 'Đã sao chép',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).hintColor,
                        fontSize: 15,
                        webBgColor: 'rgba(255, 255, 255, 0.5)',
                        webPosition: 'center',
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.copy_outlined,
                    color: AppColor.GREY_TOP_TAB_BAR,
                    size: 20,
                  ),
                )
              : const SizedBox(),
          (icon != null)
              ? Icon(
                  icon,
                  color: AppColor.GREY_TOP_TAB_BAR,
                  size: 20,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
