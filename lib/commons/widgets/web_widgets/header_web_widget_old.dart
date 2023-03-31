// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vierqr/commons/constants/configurations/stringify.dart';
// import 'package:vierqr/commons/constants/configurations/theme.dart';
// import 'package:vierqr/commons/utils/time_utils.dart';
// import 'package:vierqr/commons/widgets/dialog_widget.dart';
// import 'package:vierqr/commons/widgets/web_widgets/pop_up_menu_web_widget.dart';
// import 'package:vierqr/features/home/home.dart';
// import 'package:vierqr/features/notification/blocs/notification_bloc.dart';
// import 'package:vierqr/features/notification/events/notification_event.dart';
// import 'package:vierqr/features/notification/states/notification_state.dart';
// import 'package:vierqr/models/notification_dto.dart';
// import 'package:vierqr/services/shared_references/user_information_helper.dart';

// class HeaderWebWidgetOld extends StatelessWidget {
//   final String title;
//   final bool? isSubHeader;
//   final bool? isAuthenticate;
//   final VoidCallback? functionBack;
//   final VoidCallback? functionHome;

//   static late NotificationBloc _notificationBloc;

//   static final List<NotificationDTO> _notifications = [];
//   static int _notificationCount = 0;

//   const HeaderWebWidgetOld({
//     super.key,
//     required this.title,
//     this.isAuthenticate,
//     this.isSubHeader,
//     this.functionBack,
//     this.functionHome,
//   });

//   void initialServices(BuildContext context) {
//     String userId = UserInformationHelper.instance.getUserId();
//     _notificationBloc = BlocProvider.of(context);
//     _notificationBloc.add(NotificationEventGetList(userId: userId));
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     initialServices(context);
//     return ClipRRect(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
//         child: Container(
//           width: width,
//           height: 60,
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           decoration: BoxDecoration(
//             color: Theme.of(context).cardColor.withOpacity(0.8),
//           ),
//           child: Row(
//             children: (isAuthenticate != null && !isAuthenticate!)
//                 ? [
//                     InkWell(
//                       onTap: (functionBack == null)
//                           ? () {
//                               Navigator.of(context).pop();
//                               ;
//                             }
//                           : functionBack,
//                       child: Tooltip(
//                         message: 'Trở về',
//                         child: Container(
//                           width: 25,
//                           height: 25,
//                           padding: const EdgeInsets.all(2),
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).canvasColor,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: const Icon(
//                             Icons.arrow_back_ios_rounded,
//                             color: DefaultTheme.GREY_TEXT,
//                             size: 15,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const Padding(padding: EdgeInsets.only(left: 10)),
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ]
//                 : [
//                     SizedBox(
//                       width: (isSubHeader != null && isSubHeader!) ? 0 : 90,
//                     ),
//                     (isSubHeader != null && isSubHeader!)
//                         ? InkWell(
//                             onTap: (functionBack == null)
//                                 ? () {
//                                     Navigator.of(context).pop();
//                                     ;
//                                   }
//                                 : functionBack,
//                             child: Tooltip(
//                               message: 'Trở về',
//                               child: Container(
//                                 width: 25,
//                                 height: 25,
//                                 padding: const EdgeInsets.all(2),
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context).canvasColor,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: const Icon(
//                                   Icons.arrow_back_ios_rounded,
//                                   color: DefaultTheme.GREY_TEXT,
//                                   size: 15,
//                                 ),
//                               ),
//                             ),
//                           )
//                         : const SizedBox(),
//                     const Padding(padding: EdgeInsets.only(left: 10)),
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Spacer(),
//                     (isSubHeader != null && isSubHeader!)
//                         ? const SizedBox()
//                         : Tooltip(
//                             message: 'Trang chủ',
//                             child: Image.asset(
//                               'assets/images/ic-viet-qr.png',
//                               height: 30,
//                             ),
//                           ),
//                     const Spacer(),
//                     (isSubHeader != null && isSubHeader!)
//                         ? InkWell(
//                             onTap: (functionHome != null)
//                                 ? functionHome
//                                 : () {
//                                     Navigator.of(context).pushReplacement(
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             const HomeScreen(),
//                                       ),
//                                     );
//                                   },
//                             child: Tooltip(
//                               message: 'Trang chủ',
//                               child: Container(
//                                 width: 40,
//                                 height: 40,
//                                 padding: const EdgeInsets.all(2),
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context).canvasColor,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: const Icon(
//                                   Icons.home_rounded,
//                                   size: 20,
//                                   color: DefaultTheme.GREY_TEXT,
//                                 ),
//                               ),
//                             ),
//                           )
//                         : const SizedBox(),
//                     (isSubHeader != null && isSubHeader!)
//                         ? const Padding(padding: EdgeInsets.only(left: 5))
//                         : const SizedBox(),
//                     BlocConsumer<NotificationBloc, NotificationState>(
//                         listener: (context, state) {
//                       if (state is NotificationListSuccessfulState) {
//                         _notifications.clear();
//                         if (_notifications.isEmpty && state.list.isNotEmpty) {
//                           _notifications.addAll(state.list);
//                           _notificationCount = 0;
//                           for (NotificationDTO dto in _notifications) {
//                             if (!dto.isRead) {
//                               _notificationCount += 1;
//                             }
//                           }
//                         }
//                       }
//                     }, builder: (context, state) {
//                       if (state is NotificationListSuccessfulState) {
//                         if (state.list.isEmpty) {
//                           _notifications.clear();
//                         }
//                       }
//                       if (state is NotificationsUpdateSuccessState) {
//                         _notificationCount = 0;
//                       }
//                       return InkWell(
//                         onTap: () {
//                           List<String> notificationIds = [];
//                           for (NotificationDTO dto in _notifications) {
//                             if (!dto.isRead) {
//                               notificationIds.add(dto.id);
//                             }
//                           }
//                           if (notificationIds.isNotEmpty) {
//                             _notificationBloc.add(
//                                 NotificationEventUpdateAllStatus(
//                                     notificationIds: notificationIds));
//                           }
//                           DialogWidget.instance.openNotificationDialog(
//                             height: height,
//                             child: _buildNotificationList(_notifications),
//                           );
//                         },
//                         child: SizedBox(
//                           height: 60,
//                           width: 60,
//                           child: Stack(
//                             children: [
//                               Center(
//                                 child: Container(
//                                   width: 40,
//                                   height: 40,
//                                   decoration: BoxDecoration(
//                                     color: Theme.of(context).canvasColor,
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: const Icon(
//                                     Icons.notifications_rounded,
//                                     color: DefaultTheme.GREY_TEXT,
//                                     size: 20,
//                                   ),
//                                 ),
//                               ),
//                               (_notificationCount != 0)
//                                   ? Positioned(
//                                       bottom: 5,
//                                       right: 0,
//                                       child: Container(
//                                         width: 20,
//                                         height: 20,
//                                         alignment: Alignment.center,
//                                         decoration: BoxDecoration(
//                                           color: DefaultTheme.RED_CALENDAR,
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                         ),
//                                         child: Text(
//                                           _notificationCount.toString(),
//                                           textAlign: TextAlign.center,
//                                           style: const TextStyle(
//                                             color: DefaultTheme.WHITE,
//                                             fontSize: 8,
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   : const SizedBox(),
//                             ],
//                           ),
//                         ),
//                       );
//                     }),
//                     const Padding(padding: EdgeInsets.only(left: 5)),
//                     InkWell(
//                       onHover: (isHover) async {
//                         if (isHover) {
//                           PopupMenuWebWidget.instance.showPopupMenu(context);
//                         }
//                       },
//                       onTap: () {
//                         PopupMenuWebWidget.instance.showPopupMenu(context);
//                       },
//                       child: Tooltip(
//                         message: 'Tài khoản',
//                         child: Container(
//                           width: 100,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).canvasColor,
//                             borderRadius: BorderRadius.circular(width),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               const Padding(padding: EdgeInsets.only(left: 5)),
//                               Image.asset(
//                                 'assets/images/ic-avatar.png',
//                                 width: 35,
//                                 height: 35,
//                               ),
//                               const Padding(padding: EdgeInsets.only(left: 5)),
//                               Expanded(
//                                 child: Text(
//                                   UserInformationHelper.instance
//                                       .getAccountInformation()
//                                       .firstName,
//                                   style: const TextStyle(
//                                     fontSize: 15,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNotificationList(List<NotificationDTO> list) {
//     return (list.isNotEmpty)
//         ? ListView.builder(
//             itemCount: list.length,
//             shrinkWrap: true,
//             padding: const EdgeInsets.all(0),
//             itemBuilder: ((context, index) {
//               return Container(
//                 color: (list[index].isRead || _notificationCount == 0)
//                     ? DefaultTheme.TRANSPARENT
//                     : DefaultTheme.GREY_VIEW.withOpacity(0.5),
//                 padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       width: 40,
//                       height: 40,
//                       child: Image.asset(
//                         (list[index].type ==
//                                 Stringify.NOTIFICATION_TYPE_TRANSACTION)
//                             ? 'assets/images/ic-transaction-success.png'
//                             : 'assets/images/ic-member.png',
//                       ),
//                     ),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             (list[index].type ==
//                                     Stringify.NOTIFICATION_TYPE_TRANSACTION)
//                                 ? 'Giao dịch thành công'
//                                 : 'Thêm thành viên',
//                             style: const TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             list[index].message,
//                             style: const TextStyle(
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Text(
//                       TimeUtils.instance.formatDateFromTimeStamp(
//                           list[index].timeInserted, true),
//                       textAlign: TextAlign.right,
//                       style: const TextStyle(
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }),
//           )
//         : const Center(
//             child: Text(
//               'Không có thông báo nào.',
//               style: TextStyle(fontSize: 10),
//             ),
//           );
//   }
// }
