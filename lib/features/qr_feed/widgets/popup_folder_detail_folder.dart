import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/qr_feed_folder_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class PopupDetailFolder extends StatefulWidget {
  final QrFeedFolderDTO dto;
  const PopupDetailFolder({Key? key, required this.dto}) : super(key: key);

  @override
  State<PopupDetailFolder> createState() => _PopupDetailFolderState();
}

class _PopupDetailFolderState extends State<PopupDetailFolder> {
  double _popupHeight = 330;

  @override
  void initState() {
    super.initState();
    if (widget.dto.description.length > 100) {
      setState(() {
        _popupHeight = 400;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _popupHeight,
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF5CEC7), Color(0xFFFFD7BF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child:
                        const XImage(imagePath: 'assets/images/ic-folder.png'),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.dto.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
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
          const SizedBox(height: 30),
          _buildItem(
            expandHeight: false,
            title: 'Tên thư mục',
            value: widget.dto.title,
          ),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildItem(
            expandHeight: false,
            title: 'Thẻ QR',
            value: '${widget.dto.countQrs} thẻ',
          ),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildItem(
            expandHeight: false,
            title: 'Quyền truy cập',
            value: '${widget.dto.countUsers} người',
          ),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildItem(
            expandHeight: widget.dto.description.length > 100,
            title: 'Mô tả thư mục',
            value: widget.dto.description,
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
      {required String title,
      required String value,
      required bool expandHeight}) {
    return Container(
      height: expandHeight ? 160 : 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment:
                  expandHeight ? Alignment.topLeft : Alignment.centerLeft,
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment:
                  expandHeight ? Alignment.topRight : Alignment.centerRight,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 12,
                ), // Adjust font size and weight if necessary
                // maxLines: expandHeight
                //     ? 5
                //     : 1, // Expand max lines if description is too long
                // overflow:
                //     TextOverflow.ellipsis, // Handle overflow with ellipsis
              ),
            ),
          ),
        ],
      ),
    );
  }
}
