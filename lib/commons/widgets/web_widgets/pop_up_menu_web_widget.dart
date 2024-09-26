// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';
// import 'package:vierqr/commons/constants/configurations/theme.dart';
// import 'package:vierqr/features/home/home.dart';
// import 'package:vierqr/features/login/blocs/login_bloc.dart';
// import 'package:vierqr/features/login/events/login_event.dart';
// import 'package:vierqr/features/bank_card/views/bank_manage_view.dart';
// import 'package:vierqr/features/personal/views/qr_scanner.dart';
// import 'package:vierqr/features/personal/views/user_edit_view.dart';
// import 'package:vierqr/main.dart';
// import 'package:vierqr/services/providers/bank_account_provider.dart';
// import 'package:vierqr/services/providers/create_qr_page_select_provider.dart';
// import 'package:vierqr/services/providers/create_qr_provider.dart';
// import 'package:vierqr/services/providers/register_provider.dart';
// import 'package:vierqr/services/providers/user_edit_provider.dart';
// import 'package:vierqr/services/shared_references/event_bloc_helper.dart';
// 
// class PopupMenuWebWidget {
//   const PopupMenuWebWidget._privateConsrtructor();

//   static const PopupMenuWebWidget _instance =
//       PopupMenuWebWidget._privateConsrtructor();
//   static PopupMenuWebWidget get instance => _instance;

//   // Future<void> showPopUpBankCard({
//   //   required BankAccountDTO bankAccountDTO,
//   //   required bool isDelete,
//   //   required String role,
//   // }) async {
//   //   final RelativeRect position =
//   //       _buttonMenuCardPosition(NavigationService.context!);
//   //   await showMenu(
//   //     context: NavigationService.context!,
//   //     position: position,
//   //     items: (isDelete)
//   //         ? [
//   //             PopupMenuItem<int>(
//   //               value: 0,
//   //               onTap: () async {
//   //                 await Future.delayed(const Duration(milliseconds: 200), () {})
//   //                     .then(
//   //                   (value) => DialogWidget.instance.openContentDialog(
//   //                     null,
//   //                     AddMembersCardWidget(
//   //                       width: 500,
//   //                       bankId: bankAccountDTO.id,
//   //                       roleInsert: role,
//   //                     ),
//   //                   ),
//   //                 );
//   //               },
//   //               child: Row(
//   //                 children: const [
//   //                   Icon(
//   //                     Icons.people_rounded,
//   //                     size: 15,
//   //                     color: DefaultTheme.GREY_TEXT,
//   //                   ),
//   //                   Padding(padding: EdgeInsets.only(left: 10)),
//   //                   SizedBox(
//   //                     width: 190,
//   //                     child: Text(
//   //                       'Quản lý thành viên',
//   //                       maxLines: 1,
//   //                       overflow: TextOverflow.ellipsis,
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //             PopupMenuItem<int>(
//   //               value: 1,
//   //               onTap: () async {
//   //                 await Future.delayed(
//   //                     const Duration(milliseconds: 200), () {});
//   //                 DialogWidget.instance.openBoxWebConfirm(
//   //                   title: 'Xoá tài khoản ngân hàng',
//   //                   confirmText: 'Xoá',
//   //                   imageAsset: 'assets/images/ic-card.png',
//   //                   description:
//   //                       'Bạn có muốn xoá ${bankAccountDTO.bankAccount} ra khỏi danh sách không?',
//   //                   confirmFunction: () async {
//   //                     final BankManageBloc bankManageBloc = BlocProvider.of(
//   //                         NavigationService.context!);
//   //                     bankManageBloc.add(
//   //                       BankManageEventRemoveDTO(
//   //                         userId: UserInformationHelper.instance.getUserId(),
//   //                         bankCode: bankAccountDTO.bankAccount,
//   //                         bankId: bankAccountDTO.id,
//   //                       ),
//   //                     );
//   //                   },
//   //                   confirmColor: DefaultTheme.RED_TEXT,
//   //                 );
//   //               },
//   //               child: Row(
//   //                 children: const [
//   //                   Icon(
//   //                     Icons.delete_rounded,
//   //                     size: 15,
//   //                     color: DefaultTheme.RED_TEXT,
//   //                   ),
//   //                   Padding(padding: EdgeInsets.only(left: 10)),
//   //                   SizedBox(
//   //                     width: 190,
//   //                     child: Text(
//   //                       'Xoá tài khoản ngân hàng',
//   //                       maxLines: 1,
//   //                       overflow: TextOverflow.ellipsis,
//   //                       style: TextStyle(
//   //                         color: DefaultTheme.RED_TEXT,
//   //                       ),
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           ]
//   //         : [
//   //             PopupMenuItem<int>(
//   //               value: 0,
//   //               onTap: () async {
//   //                 await Future.delayed(const Duration(milliseconds: 200), () {})
//   //                     .then(
//   //                   (value) => DialogWidget.instance.openContentDialog(
//   //                     null,
//   //                     AddMembersCardWidget(
//   //                       width: 500,
//   //                       bankId: bankAccountDTO.id,
//   //                       roleInsert: role,
//   //                     ),
//   //                   ),
//   //                 );
//   //               },
//   //               child: Row(
//   //                 children: const [
//   //                   Icon(
//   //                     Icons.people_rounded,
//   //                     size: 15,
//   //                     color: DefaultTheme.GREY_TEXT,
//   //                   ),
//   //                   Padding(padding: EdgeInsets.only(left: 10)),
//   //                   SizedBox(
//   //                     width: 190,
//   //                     child: Text(
//   //                       'Quản lý thành viên',
//   //                       maxLines: 1,
//   //                       overflow: TextOverflow.ellipsis,
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           ],
//   //   );
//   // }

//   Future<void> showPopupMenu(BuildContext context) async {
//     final RelativeRect position = _buttonMenuPosition(context);
//     await showMenu(
//       context: context,
//       position: position,
//       items: [
//         PopupMenuItem<int>(
//           value: 0,
//           onTap: () async {
//             await Future.delayed(const Duration(milliseconds: 200), () {});
//             Navigator.of(context).push(
//               MaterialPageRoute(builder: (context) => UserEditView()),
//             );
//           },
//           child: Row(children: [
//             Image.asset(
//               'assets/images/ic-avatar.png',
//               width: 50,
//               height: 50,
//             ),
//             const Padding(padding: EdgeInsets.only(left: 5)),
//             SizedBox(
//               width: 190,
//               child: Text(
//                 UserInformationHelper.instance.getUserFullname(),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ]),
//         ),
//         const PopupMenuItem<int>(
//           value: 1,
//           child: Text('Giao dịch'),
//         ),
//         PopupMenuItem<int>(
//           value: 2,
//           child: const Text('Tài khoản ngân hàng'),
//           onTap: () async {
//             await Future.delayed(const Duration(milliseconds: 200), () {});
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => const BankManageView(),
//               ),
//             );
//           },
//         ),
//         const PopupMenuItem<int>(
//           value: 3,
//           child: Text('Mã QR'),
//         ),
//         const PopupMenuItem<int>(
//           value: 4,
//           child: Text('Thay đổi giao diện'),
//         ),
//         PopupMenuItem<int>(
//           value: 5,
//           onTap: () async {
//             await resetAll(context).then((_) {
//               Navigator.of(context).pushAndRemoveUntil(
//                   MaterialPageRoute(builder: (context) => const VietQRApp()),
//                   (Route<dynamic> route) => false);
//             });
//           },
//           child: const Text(
//             'Đăng xuất',
//             style: TextStyle(
//               color: DefaultTheme.RED_TEXT,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Future<void> showPopupMMenu(BuildContext context, bool? isSubHeader,
//       VoidCallback? functionHome) async {
//     final RelativeRect position = _buttonMenuPosition(context);
//     LoginBloc loginBloc = BlocProvider.of(context);
//     await showMenu(
//       context: context,
//       position: position,
//       items: [
//         PopupMenuItem<int>(
//           value: 0,
//           onTap: () async {
//             await Future.delayed(const Duration(milliseconds: 200), () {});
//             Navigator.of(context).push(
//               MaterialPageRoute(builder: (context) => UserEditView()),
//             );
//           },
//           child: Row(children: [
//             Image.asset(
//               'assets/images/ic-avatar.png',
//               width: 50,
//               height: 50,
//             ),
//             const Padding(padding: EdgeInsets.only(left: 5)),
//             SizedBox(
//               width: 190,
//               child: Text(
//                 '${UserInformationHelper.instance.getAccountInformation().lastName} ${UserInformationHelper.instance.getAccountInformation().middleName} ${UserInformationHelper.instance.getAccountInformation().firstName}',
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ]),
//         ),
//         if (isSubHeader != null && isSubHeader)
//           PopupMenuItem<int>(
//             onTap: (functionHome != null)
//                 ? functionHome
//                 : () async {
//                     await Future.delayed(
//                         const Duration(milliseconds: 200), () {});
//                     Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(
//                         builder: (context) => const HomeScreen(),
//                       ),
//                     );
//                   },
//             value: 1,
//             child: const Text('Trang chủ'),
//           ),
//         const PopupMenuItem<int>(
//           value: 2,
//           child: Text('Giao dịch'),
//         ),
//         PopupMenuItem<int>(
//           value: 3,
//           child: const Text('Tài khoản ngân hàng'),
//           onTap: () async {
//             await Future.delayed(const Duration(milliseconds: 200), () {});
//             Navigator.of(context).push(
//               MaterialPageRoute(builder: (context) => const BankManageView()),
//             );
//           },
//         ),
//         const PopupMenuItem<int>(
//           value: 4,
//           child: Text('Mã QR'),
//         ),
//         const PopupMenuItem<int>(
//           value: 5,
//           child: Text('Thay đổi giao diện'),
//         ),
//         //FOR TEST
//         PopupMenuItem<int>(
//           value: 6,
//           onTap: () async {
//             await Future.delayed(const Duration(milliseconds: 200), () {});
//             Navigator.of(context)
//                 .push(
//               MaterialPageRoute(
//                 builder: (context) => QRScanner(),
//               ),
//             )
//                 .then((code) {
//               if (code.toString().isNotEmpty) {
//                 loginBloc.add(
//                   LoginEventUpdateCode(
//                     code: code,
//                     userId: UserInformationHelper.instance.getUserId(),
//                   ),
//                 );
//               }
//             });
//           },
//           child: const Text(
//             'Đăng nhập bằng mã QR',
//           ),
//         ),
//         PopupMenuItem<int>(
//           value: 7,
//           onTap: () async {
//             await resetAll(context).then((_) {
//               Navigator.of(context).pushAndRemoveUntil(
//                   MaterialPageRoute(builder: (context) => const VietQRApp()),
//                   (Route<dynamic> route) => false);
//             });
//           },
//           child: const Text(
//             'Đăng xuất',
//             style: TextStyle(
//               color: DefaultTheme.RED_TEXT,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   RelativeRect _buttonMenuPosition(BuildContext context) {
//     final RenderBox bar = context.findRenderObject() as RenderBox;
//     final RenderBox overlay =
//         Overlay.of(context).context.findRenderObject() as RenderBox;
//     const Offset offset = Offset.zero;
//     final RelativeRect position = RelativeRect.fromRect(
//       Rect.fromPoints(
//         bar.localToGlobal(bar.size.bottomRight(offset), ancestor: overlay),
//         bar.localToGlobal(bar.size.bottomRight(offset), ancestor: overlay),
//       ),
//       offset & overlay.size,
//     );
//     return position;
//   }

//   RelativeRect _buttonMenuCardPosition(BuildContext context) {
//     final RenderBox bar = context.findRenderObject() as RenderBox;
//     final RenderBox overlay =
//         Overlay.of(context).context.findRenderObject() as RenderBox;
//     const Offset offset = Offset.zero;
//     final RelativeRect position = RelativeRect.fromRect(
//       Rect.fromPoints(
//         bar.localToGlobal(bar.size.centerRight(offset), ancestor: overlay),
//         bar.localToGlobal(bar.size.centerRight(offset), ancestor: overlay),
//       ),
//       offset & overlay.size,
//     );
//     return position;
//   }

//   Future<void> resetAll(BuildContext context) async {
//     Provider.of<CreateQRProvider>(context, listen: false).reset();
//     Provider.of<CreateQRPageSelectProvider>(context, listen: false).reset();
//     Provider.of<BankAccountProvider>(context, listen: false).reset();
//     Provider.of<UserEditProvider>(context, listen: false).reset();
//     Provider.of<RegisterProvider>(context, listen: false).reset();
//     await EventBlocHelper.instance.initialEventBlocHelper();
//     await UserInformationHelper.instance.initialUserInformationHelper();
//   }
// }
