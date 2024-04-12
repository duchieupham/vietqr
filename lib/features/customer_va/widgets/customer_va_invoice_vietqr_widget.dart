// import 'package:flutter/material.dart';
// import 'package:vierqr/commons/constants/configurations/numeral.dart';
// import 'package:vierqr/commons/constants/configurations/theme.dart';

// class QRBankView extends StatelessWidget {


//   const QRBankView({
//     super.key,

//   });

//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;
//     final double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: AppColor.WHITE,
//       body: Material(
//             child: 
//             Container(
//               width: width,
//               height: height,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage('assets/images/bg-qr-vqr.png'),
//                   fit: BoxFit.fitHeight,
//                 ),
//               ),
//               child: const Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//           );
//         },
//         child: Container(
//           width: width,
//           height: height,
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/images/bg-qr-vqr.png'),
//               fit: BoxFit.fitHeight,
//             ),
//           ),
//           child: Column(
//             children: [
//               const Padding(padding: EdgeInsets.only(top: 10)),
//               const HeaderWidget(
//                 colorType: 1,
//                 padding: 20,
//               ),
//               const Spacer(),
//               VietQRWidget(
//                 dto: dto,
//               ),
//               const Spacer(),
//               const Text(
//                 'BY VIETQR VN',
//                 style: TextStyle(
//                   color: AppColor.WHITE,
//                   fontSize: 12,
//                 ),
//               ),
//               const Padding(padding: EdgeInsets.only(bottom: 10))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
