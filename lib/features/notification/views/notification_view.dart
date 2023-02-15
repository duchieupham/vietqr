import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/models/notification_dto.dart';

class NotificationScreen extends StatelessWidget {
  final List<NotificationDTO> list;
  final int notificationCount;

  const NotificationScreen({
    super.key,
    required this.list,
    required this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          SubHeader(title: 'Thông báo'),
          Expanded(
            child: Visibility(
              visible: list.isNotEmpty,
              child: ListView.builder(
                itemCount: list.length,
                shrinkWrap: true,
                padding: const EdgeInsets.all(5),
                itemBuilder: ((context, index) {
                  return Container(
                    color: (list[index].isRead || notificationCount == 0)
                        ? DefaultTheme.TRANSPARENT
                        : DefaultTheme.GREY_VIEW.withOpacity(0.5),
                    padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: Image.asset(
                            (list[index].type ==
                                    Stringify.NOTIFICATION_TYPE_TRANSACTION)
                                ? 'assets/images/ic-transaction-success.png'
                                : 'assets/images/ic-member.png',
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (list[index].type ==
                                        Stringify.NOTIFICATION_TYPE_TRANSACTION)
                                    ? 'Giao dịch thành công'
                                    : 'Thêm thành viên',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                list[index].message,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          TimeUtils.instance.formatDateFromTimeStamp(
                              list[index].timeInserted, true),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
