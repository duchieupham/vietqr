import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/web_widgets/notification_list_widget.dart';
import 'package:vierqr/commons/widgets/web_widgets/pop_up_menu_web_widget.dart';
import 'package:vierqr/features/notification/blocs/notification_bloc.dart';
import 'package:vierqr/features/notification/events/notification_event.dart';
import 'package:vierqr/features/notification/states/notification_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/notification_dto.dart';
import 'package:vierqr/services/providers/clock_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class HeaderMWebWidget extends StatelessWidget {
  final double width;
  final double height;
  final bool isSubHeader;
  final VoidCallback? backFunction;
  final VoidCallback? homeFunction;

  //providers
  final ClockProvider clockProvider = ClockProvider('');
  static late NotificationBloc _notificationBloc;

  static final List<NotificationDTO> _notifications = [];
  static int _notificationCount = 0;

  HeaderMWebWidget({
    super.key,
    required this.width,
    required this.height,
    required this.isSubHeader,
    this.backFunction,
    this.homeFunction,
  });

  void initialServices(BuildContext context) {
    clockProvider.getRealTime();
    String userId = UserInformationHelper.instance.getUserId();
    _notificationBloc = BlocProvider.of(context);
    _notificationBloc.add(NotificationEventGetList(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    initialServices(context);
    return Container(
      width: width,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: Image.asset(
              'assets/images/ic-viet-qr-small-trans.png',
              width: 30,
              height: 30,
            ),
          ),
          const Spacer(),
          Text(
            '${TimeUtils.instance.getCurrentDateInWeek(null)}, ${TimeUtils.instance.getCurentDate(null)}',
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          (PlatformUtils.instance.resizeWhen(width, 400))
              ? ValueListenableBuilder(
                  builder: (_, clock, child) {
                    return (clock.toString().isNotEmpty)
                        ? BoxLayout(
                            width: 80,
                            height: 35,
                            borderRadius: 5,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(0),
                            bgColor:
                                Theme.of(context).canvasColor.withOpacity(0.5),
                            child: Text(
                              clock.toString(),
                              style: const TextStyle(
                                fontFamily: 'TimesNewRoman',
                                fontSize: 12,
                              ),
                            ),
                          )
                        : const SizedBox();
                  },
                  valueListenable: clockProvider,
                )
              : const SizedBox(),
          const Spacer(),
          BlocConsumer<NotificationBloc, NotificationState>(
              listener: (context, state) {
            if (state is NotificationListSuccessfulState) {
              _notifications.clear();
              if (_notifications.isEmpty && state.list.isNotEmpty) {
                _notifications.addAll(state.list);
                _notificationCount = 0;
                for (NotificationDTO dto in _notifications) {
                  if (!dto.isRead) {
                    _notificationCount += 1;
                  }
                }
              }
            }
          }, builder: (context, state) {
            if (state is NotificationListSuccessfulState) {
              if (state.list.isEmpty) {
                _notifications.clear();
              }
            }
            if (state is NotificationsUpdateSuccessState) {
              _notificationCount = 0;
            }
            return InkWell(
              onTap: () {
                List<String> notificationIds = [];
                for (NotificationDTO dto in _notifications) {
                  if (!dto.isRead) {
                    notificationIds.add(dto.id);
                  }
                }
                if (notificationIds.isNotEmpty) {
                  _notificationBloc.add(NotificationEventUpdateAllStatus(
                      notificationIds: notificationIds));
                }
                DialogWidget.instance.openNotificationDialog(
                  height: height,
                  marginRight: 40,
                  child: NotificationListWidget(
                    list: _notifications,
                    notificationCount: _notificationCount,
                  ),
                );
              },
              child: SizedBox(
                height: 60,
                width: 60,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.notifications_rounded,
                          color: DefaultTheme.GREY_TEXT,
                          size: 15,
                        ),
                      ),
                    ),
                    (_notificationCount != 0)
                        ? Positioned(
                            bottom: 5,
                            right: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: DefaultTheme.RED_CALENDAR,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _notificationCount.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: DefaultTheme.WHITE,
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            );
          }),
          InkWell(
            onTap: () {
              PopupMenuWebWidget.instance.showPopupMMenu(
                context,
                isSubHeader,
                homeFunction,
              );
            },
            child: Tooltip(
              message: 'Menu',
              child: Container(
                  width: 30,
                  height: 30,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.menu_rounded,
                    size: 20,
                    color: DefaultTheme.GREY_TEXT,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
