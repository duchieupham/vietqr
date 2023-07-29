// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vierqr/commons/constants/configurations/route.dart';
// import 'package:vierqr/commons/constants/configurations/theme.dart';
// import 'package:vierqr/commons/enums/enum_type.dart';
// import 'package:vierqr/commons/widgets/dialog_widget.dart';
// import 'package:vierqr/features/contact/save_contact_screen.dart';
// import 'package:vierqr/features/scan_qr/blocs/scan_qr_bloc.dart';
// import 'package:vierqr/features/scan_qr/states/scan_qr_state.dart';
// import 'package:vierqr/models/bank_name_search_dto.dart';
// import 'package:vierqr/models/qr_generated_dto.dart';
//
// import 'events/scan_qr_event.dart';
//
// class ScanQrScreen extends StatelessWidget {
//   const ScanQrScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ScanQrBloc(),
//       child: _BodyWidget(),
//     );
//   }
// }
//
// class _BodyWidget extends StatefulWidget {
//   @override
//   State<_BodyWidget> createState() => _ScanQrScreenState();
// }
//
// class _ScanQrScreenState extends State<_BodyWidget> {
//   late ScanQrBloc _bloc;
//
//   @override
//   void initState() {
//     super.initState();
//     _bloc = BlocProvider.of(context);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       startBarcodeScanStream();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ScanQrBloc, ScanQrState>(
//       listener: (context, state) {
//         if (state.status == BlocStatus.LOADING) {
//           DialogWidget.instance.openLoadingDialog();
//         }
//
//         if (state.status == BlocStatus.UNLOADING) {
//           Navigator.pop(context);
//         }
//
//         if (state.request == ScanType.SCAN_ERROR) {
//           Navigator.of(context).pop({'type': TypeContact.ERROR});
//         }
//
//         if (state.request == ScanType.SCAN_NOT_FOUND) {
//           Navigator.of(context).pop({'type': TypeContact.NOT_FOUND});
//         }
//
//         if (state.request == ScanType.SEARCH_NAME) {
//           QRGeneratedDTO dto = QRGeneratedDTO(
//             bankCode: state.bankTypeDTO?.bankCode ?? '',
//             bankName: state.bankTypeDTO?.bankName ?? '',
//             bankAccount: state.bankAccount ?? '',
//             userBankName: state.informationDTO?.accountName ?? '',
//             amount: '',
//             content: '',
//             qrCode: state.codeQR ?? '',
//             imgId: state.bankTypeDTO?.imageId ?? '',
//             bankTypeId: state.bankTypeDTO?.id ?? '',
//           );
//
//           if (!mounted) return;
//           Navigator.of(context).pop({
//             'type': state.typeContact,
//             'data': dto,
//           });
//         }
//
//         if (state.request == ScanType.SCAN) {
//           if (state.typeQR == TypeQR.QR_BANK) {
//             String transferType = '';
//             if (state.bankTypeDTO?.bankCode == 'MB') {
//               transferType = 'INHOUSE';
//             } else {
//               transferType = 'NAPAS';
//             }
//             BankNameSearchDTO bankNameSearchDTO = BankNameSearchDTO(
//               accountNumber: state.bankAccount ?? '',
//               accountType: 'ACCOUNT',
//               transferType: transferType,
//               bankCode: state.bankTypeDTO?.caiValue ?? '',
//             );
//
//             _bloc.add(ScanQrEventSearchName(dto: bankNameSearchDTO));
//           } else if (state.typeQR == TypeQR.QR_BARCODE) {
//             DialogWidget.instance.openMsgDialog(
//               title: 'Không thể xác nhận mã QR',
//               msg:
//                   'Không tìm thấy thông tin trong đoạn mã QR. Vui lòng kiểm tra lại thông tin.',
//               function: () {
//                 Navigator.pop(context);
//                 if (Navigator.canPop(context)) {
//                   Navigator.pop(context);
//                 }
//               },
//             );
//           } else if (state.typeQR == TypeQR.QR_ID) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => SaveContactScreen(
//                   code: state.codeQR ?? '',
//                   typeQR: TypeContact.VietQR_ID,
//                 ),
//                 // settings: RouteSettings(name: ContactEditView.routeName),
//               ),
//             );
//           } else if (state.typeQR == TypeQR.QR_LINK) {
//             Navigator.of(context).pop({
//               'type': state.typeContact,
//               'typeQR': TypeQR.QR_LINK,
//               'data': state.codeQR,
//             });
//           } else if (state.typeQR == TypeQR.QR_CMT) {
//             if (!mounted) return;
//             Navigator.pushReplacementNamed(
//               context,
//               Routes.NATIONAL_INFORMATION,
//               arguments: {'dto': state.nationalScannerDTO},
//             );
//           } else if (state.typeQR == TypeQR.OTHER) {
//             Navigator.of(context).pop({
//               'type': state.typeContact,
//               'typeQR': TypeQR.OTHER,
//               'data': state.codeQR,
//             });
//           }
//         }
//       },
//       builder: (context, state) {
//         return const Scaffold(
//           backgroundColor: AppColor.BLACK,
//         );
//       },
//     );
//   }
//
//   Future<void> startBarcodeScanStream() async {
//     final data = await FlutterBarcodeScanner.scanBarcode(
//         '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
//
//     if (data.isNotEmpty) {
//       if (data == TypeQR.NEGATIVE_ONE.value) {
//         if (!mounted) return;
//         Navigator.pop(context);
//       } else if (data == TypeQR.NEGATIVE_TWO.value) {
//         DialogWidget.instance.openMsgDialog(
//           title: 'Không thể xác nhận mã QR',
//           msg: 'Ảnh QR không đúng định dạng, vui lòng chọn ảnh khác.',
//           function: () {
//             Navigator.pop(context);
//             if (Navigator.canPop(context)) {
//               Navigator.pop(context);
//             }
//           },
//         );
//       } else {
//         _bloc.add(ScanQrEventGetBankType(code: data));
//       }
//     }
//   }
// }
