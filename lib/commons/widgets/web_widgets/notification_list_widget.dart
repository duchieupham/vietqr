import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/models/notification_dto.dart';

class NotificationListWidget extends StatelessWidget {
  final List<NotificationDTO> list;
  final int notificationCount;

  const NotificationListWidget({
    super.key,
    required this.list,
    required this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return (list.isNotEmpty)
        ? ListView.builder(
            itemCount: list.length,
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
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
          )
        : const Center(
            child: Text(
              'Không có thông báo nào.',
              style: TextStyle(fontSize: 10),
            ),
          );
  }
}
