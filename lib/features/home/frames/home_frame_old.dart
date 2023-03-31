// import 'package:flutter/material.dart';
// import 'package:vierqr/commons/utils/platform_utils.dart';
// import 'package:vierqr/commons/widgets/web_widgets/header_mweb_widget_old.dart';
// import 'package:vierqr/commons/widgets/web_widgets/header_web_widget_old.dart';
// import 'package:vierqr/layouts/blur_layout.dart';

// class HomeFrame2 extends StatelessWidget {
//   final double width;
//   final double height;
//   final List<Widget> mobileChildren;
//   final Widget widget1;
//   final Widget widget2;
//   final Widget widget3;
//   final String backgroundAsset;

//   const HomeFrame2({
//     super.key,
//     required this.width,
//     required this.height,
//     required this.mobileChildren,
//     required this.widget1,
//     required this.widget2,
//     required this.widget3,
//     required this.backgroundAsset,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: (PlatformUtils.instance.resizeWhen(width, 870))
//           ? [
//               Container(
//                 width: width,
//                 height: height,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage(backgroundAsset), fit: BoxFit.cover),
//                 ),
//                 child: SingleChildScrollView(
//                   controller: ScrollController(),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const Padding(padding: EdgeInsets.only(top: 100)),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Column(
//                             children: [
//                               BlurLayout(
//                                 width: 350,
//                                 height: 100,
//                                 child: widget1,
//                               ),
//                               const Padding(padding: EdgeInsets.only(top: 20)),
//                               BlurLayout(
//                                 width: 350,
//                                 height: 500,
//                                 child: widget2,
//                               ),
//                             ],
//                           ),
//                           const Padding(padding: EdgeInsets.only(left: 20)),
//                           Column(
//                             children: [
//                               BlurLayout(
//                                   width: 500, height: 620, child: widget3),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const Padding(padding: EdgeInsets.only(top: 100)),
//                     ],
//                   ),
//                 ),
//               ),
//               const HeaderWebWidgetOld(
//                 title: '',
//               ),
//             ]
//           : (PlatformUtils.instance.isWeb())
//               ? [
//                   Container(
//                     width: width,
//                     height: height,
//                     decoration: const BoxDecoration(
//                       image: DecorationImage(
//                           image: AssetImage('assets/images/bg-qr.png'),
//                           fit: BoxFit.cover),
//                     ),
//                     child: SingleChildScrollView(
//                       controller: ScrollController(),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Padding(padding: EdgeInsets.only(top: 100)),
//                           BlurLayout(
//                               width: PlatformUtils.instance.getDynamicWidth(
//                                 screenWidth: width,
//                                 defaultWidth: 350,
//                                 minWidth: width * 0.8,
//                               ),
//                               height: 100,
//                               child: widget1),
//                           const Padding(padding: EdgeInsets.only(top: 20)),
//                           BlurLayout(
//                             width: PlatformUtils.instance.getDynamicWidth(
//                               screenWidth: width,
//                               defaultWidth: 350,
//                               minWidth: width * 0.8,
//                             ),
//                             height: 600,
//                             child: widget2,
//                           ),
//                           const Padding(padding: EdgeInsets.only(top: 20)),
//                           BlurLayout(
//                             width: PlatformUtils.instance.getDynamicWidth(
//                               screenWidth: width,
//                               defaultWidth: 350,
//                               minWidth: width * 0.8,
//                             ),
//                             height: 500,
//                             child: widget3,
//                           ),
//                           const Padding(padding: EdgeInsets.only(top: 100)),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const HeaderMwebWidgetOld(
//                     title: '',
//                   ),
//                 ]
//               : mobileChildren,
//     );
//   }
// }
