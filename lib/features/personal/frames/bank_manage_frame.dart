// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:vierqr/commons/utils/platform_utils.dart';
// import 'package:vierqr/commons/widgets/web_widgets/header_web_widget_old.dart';
// import 'package:vierqr/layouts/blur_layout.dart';
// import 'package:vierqr/layouts/box_layout.dart';
// import 'package:vierqr/services/providers/bank_account_provider.dart';

// class BankManageFrame extends StatelessWidget {
//   final double width;
//   final Widget mobileChilren;
//   final Widget webChildren;
//   final Widget menu;

//   const BankManageFrame({
//     super.key,
//     required this.width,
//     required this.mobileChilren,
//     required this.webChildren,
//     required this.menu,
//   });

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     return (PlatformUtils.instance.resizeWhen(width, 900))
//         ? Stack(
//             children: [
//               Image.asset(
//                 'assets/images/bg-bank-card.png',
//                 width: width,
//                 //height: height,
//                 fit: BoxFit.cover,
//               ),
//               BlurLayout(
//                 width: width,
//                 height: height,
//                 blur: 50,
//                 borderRadius: 0,
//                 opacity: 0.9,
//                 child: Column(
//                   children: [
//                     HeaderWebWidgetOld(
//                       title: 'Tài khoản ngân hàng',
//                       isSubHeader: true,
//                       functionBack: () {
//                         Provider.of<BankAccountProvider>(context, listen: false)
//                             .reset();
//                         Navigator.pop(context);
//                       },
//                     ),
//                     Expanded(
//                       child: Row(
//                         children: [
//                           BoxLayout(
//                             width: 200,
//                             borderRadius: 0,
//                             child: menu,
//                           ),
//                           Expanded(
//                             child: webChildren,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           )
//         : mobileChilren;
//   }
// }
