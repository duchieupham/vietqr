// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:photo_gallery/photo_gallery.dart';
// import 'package:vierqr/commons/utils/file_utils.dart';
//
// class ImageChooserBottomSheet extends StatefulWidget {
//   final Function(File) onPhotoTaken;
//   final Function(List<File>) onChoosePhoto;
//   final Function() onClose;
//   final int maxChooseImage;
//
//   ImageChooserBottomSheet({
//     Key? key,
//     required this.onPhotoTaken,
//     required this.onChoosePhoto,
//     required this.onClose,
//     this.maxChooseImage = 20,
//   }) : super(key: key);
//
//   @override
//   ImageChooserBottomSheetState createState() => ImageChooserBottomSheetState();
// }
//
// class ImageChooserBottomSheetState extends State<ImageChooserBottomSheet> {
//   List<Medium>? _listMediumImage;
//
//   _handleChangeSelectedImage(List<Medium>? imageList) async {
//     setState(() {
//       _listMediumImage = imageList;
//     });
//   }
//
//   _handleConfirmChooseImage() async {
//     if (_listMediumImage == null) return;
//     List<File> imageFile =
//         await Future.wait(_listMediumImage!.map((item) => item.getFile()));
//     widget.onChoosePhoto(imageFile);
//   }
//
//   _handlePermissionDenied() {
//     widget.onClose();
//   }
//
//   _handlePermissionPermanentlyDenied() {
//     // FileUtils.instance.showGoSettingPhotoPermission(context, () {
//     //   widget.onClose();
//     // });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           height: MediaQuery.of(context).size.height - 64,
//           child: Column(
//             children: [
//               CommonFunctions.buildBottomSheetIndicator(),
//               SizedBox(height: 8),
//               Container(
//                 decoration: BoxDecoration(
//                   color: AppColor.white,
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(16),
//                   ),
//                 ),
//                 child: ImageChooser(
//                   multiChoiceCanUnselectLastItem: true,
//                   images: _listMediumImage,
//                   onChange: _handleChangeSelectedImage,
//                   onPhotoTaken: widget.onPhotoTaken,
//                   height: MediaQuery.of(context).size.height - 76,
//                   canSwitchChoiceMode: false,
//                   showCloseButton: true,
//                   onClose: widget.onClose,
//                   maxChooseImage: widget.maxChooseImage,
//                   autoSelect: false,
//                   onPermissionDenied: _handlePermissionDenied,
//                   onPermissionPermanentlyDenied:
//                       _handlePermissionPermanentlyDenied,
//                 ),
//               )
//             ],
//           ),
//         ),
//         if (_listMediumImage != null && _listMediumImage!.length > 0)
//           Positioned(
//               bottom: MediaQuery.of(context).padding.bottom + 16,
//               left: 16,
//               right: 16,
//               child: SizedBox(
//                 width: double.infinity,
//                 child: Container(
//                   child: PrimaryButton(
//                     onPressed: _handleConfirmChooseImage,
//                     text: 'base.upload-xxx-image'.tr(
//                       args: [
//                         _listMediumImage!.length.toString(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ))
//       ],
//     );
//   }
// }
