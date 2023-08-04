import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/models/network_providers_dto.dart';

import '../../../commons/widgets/divider_widget.dart';

class ListNetWorkProvider extends StatelessWidget {
  final List<NetworkProviders> list;
  final Function(NetworkProviders) onTap;
  const ListNetWorkProvider({Key? key, required this.list, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(context),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: AppColor.BLUE_TEXT.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.info_outline,
                    color: AppColor.BLUE_TEXT,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Lưu ý:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.BLUE_TEXT,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                'Chỉ thay đổi nhà mạng khi bạn đã đăng kí giữ số chuyển nhà mạng',
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
              itemBuilder: (context, index) {
                return _buildItem(list[index], context);
              },
              separatorBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child:
                      DividerWidget(width: MediaQuery.of(context).size.width),
                );
              },
              itemCount: list.length),
        ),
      ],
    );
  }

  Widget _buildItem(NetworkProviders item, BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(item);
        Navigator.pop(context);
      },
      child: SizedBox(
        height: 45,
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    width: 0.5, color: AppColor.GREY_TEXT.withOpacity(0.3)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: ImageUtils.instance.getImageNetWork(item.imgId),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              item.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 24),
        const Expanded(
          child: Text(
            'Thay đổi nhà mạng',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: Navigator.of(context).pop,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(
            Icons.clear,
            size: 20,
          ),
        )
      ],
    );
  }
}
