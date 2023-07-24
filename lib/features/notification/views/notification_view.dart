import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/features/notification/blocs/notification_bloc.dart';
import 'package:vierqr/features/notification/events/notification_event.dart';
import 'package:vierqr/features/notification/states/notification_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/notification_dto.dart';
import 'package:vierqr/models/notification_input_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class NotificationView extends StatelessWidget {
  static ScrollController scrollController = ScrollController();
  static int offset = 0;
  static bool isEnded = false;
  static final List<NotificationDTO> notifications = [];

  const NotificationView({super.key});

  void initialServices(
      BuildContext context, NotificationBloc notificationBloc) {
    isEnded = false;
    offset = 0;
    notifications.clear();
    String userId = UserInformationHelper.instance.getUserId();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // ListView đã cuộn đến cuối
        // Xử lý tại đây
        offset += 1;
        NotificationInputDTO notificationInputDTO = NotificationInputDTO(
          userId: userId,
          offset: offset * 20,
        );
        notificationBloc.add(NotificationFetchEvent(dto: notificationInputDTO));
      }
    });
    NotificationInputDTO dto = NotificationInputDTO(userId: userId, offset: 0);
    notificationBloc.add(NotificationGetListEvent(dto: dto));
  }

  Future<void> _refresh(NotificationBloc notificationBloc) async {
    String userId = UserInformationHelper.instance.getUserId();
    NotificationInputDTO dto = NotificationInputDTO(userId: userId, offset: 0);
    notificationBloc.add(NotificationGetListEvent(dto: dto));
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final NotificationBloc notificationBloc = arg['notificationBloc'];
    initialServices(context, notificationBloc);

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          const SubHeader(title: 'Thông báo'),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _refresh(notificationBloc);
              },
              child: BlocConsumer<NotificationBloc, NotificationState>(
                listener: (context, state) {
                  if (state is NotificationGetListSuccessState) {
                    notifications.clear();
                    if (state.list.isEmpty || state.list.length < 20) {
                      isEnded = true;
                    }
                    if (notifications.isEmpty) {
                      notifications.addAll(state.list);
                    }
                  }
                  if (state is NotificationFetchSuccessState) {
                    if (state.list.isEmpty || state.list.length < 20) {
                      isEnded = true;
                    }
                    notifications.addAll(state.list);
                  }
                },
                builder: (context, state) {
                  return (notifications.isEmpty)
                      ? const SizedBox()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: notifications.length + 1,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          controller: scrollController,
                          itemBuilder: (context, index) {
                            return (index == notifications.length && !isEnded)
                                ? const UnconstrainedBox(
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(
                                        color: AppColor.BLUE_TEXT,
                                      ),
                                    ),
                                  )
                                : (index == notifications.length && isEnded)
                                    ? const SizedBox()
                                    : _buildElement(
                                        context: context,
                                        dto: notifications[index],
                                        notificationBloc: notificationBloc,
                                      );
                          },
                        );
                },
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
        ],
      ),
    );
  }

  Widget _buildElement(
      {required BuildContext context,
      required NotificationDTO dto,
      required NotificationBloc notificationBloc}) {
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        if (dto.type == Stringify.NOTI_TYPE_NEW_TRANSACTION ||
            dto.type == Stringify.NOTI_TYPE_UPDATE_TRANSACTION) {
          Navigator.pushNamed(
            context,
            Routes.TRANSACTION_DETAIL,
            arguments: {'transactionId': dto.data},
          );
        }
      },
      child: Container(
        width: width,
        height: 80,
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            (dto.isRead)
                ? const SizedBox(
                    width: 5,
                    height: 5,
                  )
                : Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColor.BLUE_TEXT,
                    ),
                  ),
            const Padding(padding: EdgeInsets.only(left: 5)),
            BoxLayout(
              width: 30,
              height: 30,
              padding: const EdgeInsets.all(0),
              enableShadow: true,
              child: _getNotificationIcon(dto.type),
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dto.message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    TimeUtils.instance.formatTimeNotification(dto.time),
                    style: TextStyle(
                      fontSize: 10,
                      color: (dto.isRead)
                          ? AppColor.GREY_TEXT
                          : AppColor.BLUE_TEXT,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Icon _getNotificationIcon(String type) {
    Icon result = const Icon(
      Icons.notifications_rounded,
      size: 18,
      color: AppColor.BLUE_TEXT,
    );
    if (type == Stringify.NOTI_TYPE_LOGIN) {
      result = const Icon(
        Icons.login_rounded,
        size: 18,
        color: AppColor.RED_CALENDAR,
      );
    } else if (type == Stringify.NOTI_TYPE_NEW_TRANSACTION) {
      result = const Icon(
        Icons.attach_money_rounded,
        size: 18,
        color: AppColor.ORANGE,
      );
    } else if (type == Stringify.NOTI_TYPE_UPDATE_TRANSACTION) {
      result = const Icon(
        Icons.check_rounded,
        size: 15,
        color: AppColor.GREEN,
      );
    }
    return result;
  }
}
