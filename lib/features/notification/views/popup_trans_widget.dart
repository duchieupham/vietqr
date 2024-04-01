import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/layouts/dashedline/horizontal_dashed_line.dart';
import 'package:vierqr/models/notify_trans_dto.dart';

class PopupTransWidget extends StatefulWidget {
  final NotifyTransDTO dto;
  final TypeImage type; // 1: save image, 2: share

  static String routeName = '/popupTransWidget';

  const PopupTransWidget({super.key, required this.dto, required this.type});

  @override
  State<PopupTransWidget> createState() => _PopupTransWidgetState();
}

class _PopupTransWidgetState extends State<PopupTransWidget> {
  final globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () async {
      if (widget.type == TypeImage.SAVE) {
        onSaveImage(context);
      } else if (widget.type == TypeImage.SHARE) {
        onShare();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RepaintBoundaryWidget(
              globalKey: globalKey,
              builder: (key) {
                return Container(
                  padding:
                      const EdgeInsets.fromLTRB(24, kToolbarHeight + 30, 24, 0),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Image.asset(widget.dto.icon, width: 120),
                      ...[
                        Text(
                          widget.dto.getAmount,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: widget.dto.colorAmount,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                        Text(
                          widget.dto.getTransStatus,
                          style: const TextStyle(
                              fontSize: 12, color: AppColor.BLACK),
                        ),
                        const SizedBox(height: 24),
                        CustomPaint(
                          painter:
                              HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
                          size: const Size(double.infinity, 1),
                        ),
                        const SizedBox(height: 24),
                      ],
                      if (widget.dto.isTerNotEmpty ||
                          widget.dto.orderId.isNotEmpty) ...[
                        if (widget.dto.isTerNotEmpty)
                          Text(
                            widget.dto.terminalName.isNotEmpty
                                ? widget.dto.terminalName
                                : widget.dto.terminalCode,
                            style: const TextStyle(
                                fontSize: 16,
                                color: AppColor.BLACK,
                                fontWeight: FontWeight.bold),
                          ),
                        if (widget.dto.orderId.isNotEmpty)
                          Text(
                            'Mã đơn ${widget.dto.orderId}',
                            style: TextStyle(
                              fontSize: widget.dto.isTerEmpty ? 16 : 12,
                              color: AppColor.BLACK,
                              fontWeight: widget.dto.isTerEmpty
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                        const SizedBox(height: 40),
                      ],
                      _buildInfo(),
                      const Spacer(),
                      Text('BY VIETQR VN'),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              }),
          Positioned(
            top: kToolbarHeight,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close, color: AppColor.BLACK, size: 30),
              padding: EdgeInsets.only(left: 16),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...[
          _buildItem(
            title: 'Tài khoản nhận:',
            content: '${widget.dto.bankCode} - ${widget.dto.bankAccount}',
          ),
          CustomPaint(
            painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
            size: const Size(double.infinity, 1),
          ),
        ],
        ...[
          _buildItem(
            title: 'Thời gian TT:',
            content: widget.dto.timePayment,
          ),
          CustomPaint(
            painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
            size: const Size(double.infinity, 1),
          ),
        ],
        ...[
          _buildItem(
            title: 'Mã GD:',
            content: widget.dto.referenceNumber,
          ),
          CustomPaint(
            painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
            size: const Size(double.infinity, 1),
          ),
        ],
        ...[
          _buildItem(
            title: 'Thời gian tạo:',
            content: widget.dto.getTimeCreate,
          ),
          CustomPaint(
            painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
            size: const Size(double.infinity, 1),
          ),
        ],
        _buildItem(
          title: 'Nội dung:',
          content: widget.dto.content,
          maxLines: 3,
        ),
      ],
    );
  }

  void onSaveImage(BuildContext context) async {
    DialogWidget.instance.openLoadingDialog();
    await Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        await ShareUtils.instance.saveImageToGallery(globalKey).then(
          (value) {
            Navigator.pop(context);
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: 'Đã lưu ảnh',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
            );
          },
        );
      },
    );
  }

  void onShare() async {
    await ShareUtils.instance
        .shareImage(key: globalKey, textSharing: '')
        .then((value) {
      Navigator.pop(context);
    });
  }

  Widget _buildItem(
      {String title = '', String content = '', int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: AppColor.GREY_TEXT.withOpacity(0.8),
              ),
            ),
          ),
          Expanded(
            child: Text(
              content.isEmpty ? '-' : content,
              textAlign: TextAlign.right,
              maxLines: maxLines,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }
}
