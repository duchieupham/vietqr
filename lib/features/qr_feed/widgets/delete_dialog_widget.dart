import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/qr_feed/blocs/qr_feed_bloc.dart';
import 'package:vierqr/features/qr_feed/events/qr_feed_event.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class DeleteDialogWidget extends StatefulWidget {
  final String folderId;
  const DeleteDialogWidget({super.key, required this.folderId});

  @override
  State<DeleteDialogWidget> createState() => _DeleteDialogWidgetState();
}

class _DeleteDialogWidgetState extends State<DeleteDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: AppColor.BLUE_TEXT.withOpacity(0.2),
                  gradient: const LinearGradient(
                      colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight)),
              child: const XImage(
                imagePath: 'assets/images/ic-remove-black.png',
                width: 80,
                height: 80,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Xoá thư mục QR',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'Ngưng chia sẻ các thẻ QR trong\nthư mục này.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 45),
            InkWell(
              onTap: () {
                _showDeleteConfirmationDialog(context, 0);
                // getIt.get<QrFeedBloc>().add(DeleteFolderEvent(
                //     deleteItems: 0, folderId: widget.folderId));
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF00C6FF),
                      Color(0xFF0072FF),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  color: const Color(0xFFF0F4FA),
                ),
                child: const Center(
                  child: Text(
                    'Xoá thư mục nhưng không\nxoá thẻ QR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppColor.WHITE),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                _showDeleteConfirmationDialog(context, 1);
                // getIt.get<QrFeedBloc>().add(DeleteFolderEvent(
                //     deleteItems: 1, folderId: widget.folderId));
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  color: const Color(0xFFF0F4FA),
                ),
                child: const Center(
                  child: Text(
                    'Xoá thư mục và thẻ QR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppColor.BLUE_TEXT),
                  ),
                ),
              ),
            )
          ],
        ),
        Positioned(
            top: 20,
            right: 20,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.close,
                size: 22,
                color: AppColor.GREY_TEXT,
              ),
            ))
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int deleteItems) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xoá'),
          content: const Text('Bạn có chắc chắn muốn xoá mã QR này không?'),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.red.withOpacity(0.1),
                    ),
                    child: TextButton(
                      child: const Text(
                        'Huỷ',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue.withOpacity(0.1),
                    ),
                    child: TextButton(
                      child: const Text(
                        'Xác nhận',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        getIt.get<QrFeedBloc>().add(DeleteFolderEvent(
                            deleteItems: deleteItems,
                            folderId: widget.folderId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Xoá thành công'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
