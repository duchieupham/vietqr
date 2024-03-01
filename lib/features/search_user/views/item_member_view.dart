import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/models/detail_group_dto.dart';

class ItemMemberView extends StatefulWidget {
  final AccountMemberDTO dto;
  final VoidCallback callBack;

  const ItemMemberView({super.key, required this.dto, required this.callBack});

  @override
  State<ItemMemberView> createState() => _ItemMemberViewState();
}

class _ItemMemberViewState extends State<ItemMemberView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildItemUser(widget.dto);
  }

  Widget _buildItemUser(AccountMemberDTO dto) {
    return GestureDetector(
      onTap: () async {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: AppColor.BLACK_BUTTON.withOpacity(0.5), width: 0.5)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: dto.imgId.isNotEmpty
                    ? DecorationImage(
                        image: ImageUtils.instance.getImageNetWork(dto.imgId),
                        fit: BoxFit.cover)
                    : DecorationImage(
                        image: AssetImage('assets/images/ic-avatar.png')),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dto.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(dto.phoneNo ?? '',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: dto.existed == 0 && !dto.isMe
                  ? GestureDetector(
                      onTap: widget.callBack.call,
                      child: Container(
                        width: 80,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: AppColor.BLUE_TEXT.withOpacity(0.35),
                        ),
                        child: Text(
                          'Thêm',
                          style: TextStyle(color: AppColor.BLUE_TEXT),
                        ),
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 32,
                      child: Row(
                        children: [
                          Text(
                            'Đã thêm',
                            textAlign: TextAlign.end,
                            style: TextStyle(color: AppColor.BLUE_TEXT),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.check,
                            color: AppColor.BLUE_TEXT,
                            size: 18,
                          )
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
