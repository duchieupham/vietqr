import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/features/add_bank/blocs/add_bank_provider.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class SaveConnectWidget extends StatelessWidget {
  const SaveConnectWidget({
    required this.list,
    required this.provider,
    required this.bankAccountController,
    required this.nameController,
    super.key,
  });

  final List<BankTypeDTO> list;
  final AddBankProvider provider;
  final TextEditingController bankAccountController;
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: AppColor.BLUE_BGR),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                VietQRTheme.gradientColor.aiTextColor.createShader(bounds),
            child: const Text(
              'Nhận Biến động số dư và \nsử dụng các dịch vụ tích hợp',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: AppColor.WHITE,
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Hỗ trợ đầy đủ các dịch vụ khi thực hiện liên kết \n tài khoản ngân hàng thuộc các ngân hàng duối dưới đây',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12,
                color: AppColor.BLACK,
                fontWeight: FontWeight.normal),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: const Divider(color: AppColor.GREY_DADADA),
          ),
          if (list.isNotEmpty)
            ListView.separated(
                reverse: true,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var bank = list[index];
                  return InkWell(
                    onTap: () {
                      bankAccountController.clear();
                      nameController.clear();
                      provider.resetValidate();
                      provider.updateSelectBankType(bank);
                      provider.updateEnableName(true);
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColor.WHITE,
                              borderRadius: BorderRadius.circular(8),
                              image: bank.fileBank == null
                                  ? DecorationImage(
                                      image: ImageUtils.instance
                                          .getImageNetWork(bank.imageId))
                                  : DecorationImage(
                                      image: FileImage(bank.fileBank!)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DefaultTextStyle(
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: AppColor.BLACK,
                                  ),
                                  child: Text(
                                    bank.bankShortName!,
                                  ),
                                ),
                                DefaultTextStyle(
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: AppColor.GREY_TEXT),
                                  child: Text(
                                    bank.bankName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            size: 20,
                            color: AppColor.BLACK,
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const Divider(color: AppColor.GREY_DADADA),
                itemCount: 2)
          else
            const SizedBox.shrink()
        ],
      ),
    );
  }
}
