import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class SaveConnectWidget extends StatelessWidget {
  const SaveConnectWidget({
    required this.list,
    this.onTap,
    super.key,
  });

  final List<BankTypeDTO> list;
  final VoidCallback? onTap;

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
          ListView.separated(
            reverse: true,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: onTap,
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
                            image: list[index].fileBank == null
                                ? DecorationImage(
                                    image: ImageUtils.instance
                                        .getImageNetWork(list[index].imageId))
                                : DecorationImage(
                                    image: FileImage(list[index].fileBank!)),
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
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.BLACK,
                                ),
                                child: Text(
                                  list[1].bankShortName!,
                                ),
                              ),
                              DefaultTextStyle(
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: AppColor.GREY_TEXT),
                                child: Text(
                                  list[index].bankName,
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
        ],
      ),
    );
  }
}
