// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:vierqr/commons/constants/configurations/theme.dart';
// import 'package:vierqr/commons/di/injection/injection.dart';
// import 'package:vierqr/commons/enums/enum_type.dart';
// import 'package:vierqr/commons/utils/currency_utils.dart';
// import 'package:vierqr/commons/widgets/shimmer_block.dart';
// import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
// import 'package:vierqr/features/bank_card/events/bank_event.dart';
// import 'package:vierqr/features/bank_card/states/bank_state.dart';
// import 'package:vierqr/features/bank_detail_new/widgets/filter_time_widget.dart';
// import 'package:vierqr/layouts/button/button.dart';
// import 'package:vierqr/layouts/image/x_image.dart';
// import 'package:vierqr/models/bank_account_dto.dart';
// import 'package:vierqr/models/bank_overview_dto.dart';

// class OverviewStatistic extends StatefulWidget {
//   final BankAccountDTO bankDto;
//   const OverviewStatistic({super.key, required this.bankDto});

//   @override
//   State<OverviewStatistic> createState() => _OverviewStatisticState();
// }

// class _OverviewStatisticState extends State<OverviewStatistic> {
//   List<FilterTrans> list = [
//     FilterTrans(
//         title: 'Ngày',
//         type: 1,
//         fromDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 00:00:00',
//         toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59'),
//     FilterTrans(
//         title: 'Tháng',
//         type: 2,
//         fromDate:
//             '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 30)))} 00:00:00',
//         toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59'),
//     FilterTrans(
//         title: 'Tuần',
//         type: 3,
//         fromDate:
//             '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 7)))} 00:00:00',
//         toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59'),
//   ];

//   FilterTrans selected = FilterTrans(
//       title: 'Ngày',
//       type: 1,
//       fromDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 00:00:00',
//       toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59');
//   final BankBloc bankBloc = getIt.get<BankBloc>();

//   BankAccountDTO? dto;
//   bool isTapped = false;

//   @override
//   void initState() {
//     super.initState();
//     dto = widget.bankDto;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<BankBloc, BankState>(
//       bloc: bankBloc,
//       listener: (context, state) {
//         if (state.request == BankType.GET_OVERVIEW &&
//             state.status == BlocStatus.SUCCESS) {
//           isTapped = false;
//         }
//       },
//       builder: (context, state) {
//         return Container(
//           width: double.infinity,
//           margin: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   ...List.generate(
//                     list.length,
//                     (index) {
//                       bool isSelect = selected.type == list[index].type;

//                       return InkWell(
//                         onTap: !isTapped
//                             ? () {
//                                 // print(DateTime.now().);
//                                 setState(() {
//                                   isTapped = true;
//                                   selected = list[index];
//                                 });
//                                 bankBloc
//                                     .add(SelectTimeEvent(timeSelect: selected));
//                                 bankBloc.add(GetOverviewEvent(
//                                   bankId: widget.bankDto.id,
//                                   fromDate: list[index].fromDate,
//                                   toDate: list[index].toDate,
//                                 ));
//                               }
//                             : null,
//                         child: Container(
//                           height: 30,
//                           // margin: EdgeInsets.only(left: index == 0 ? 0 : 8),
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(100),
//                               gradient: isSelect
//                                   ? VietQRTheme.gradientColor.lilyLinear
//                                   : null),
//                           child: Center(
//                             child: Text(
//                               list[index].title,
//                               style: TextStyle(
//                                   fontSize: 12,
//                                   color: isSelect
//                                       ? AppColor.BLACK
//                                       : AppColor.GREY_TEXT),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   const Spacer(),
//                   Text(
//                     selected.type == 1
//                         ? DateFormat('dd/MM/yyyy').format(DateTime.now())
//                         : selected.type == 2
//                             ? DateFormat('MM/yyyy').format(DateTime.now())
//                             : '${DateFormat('dd/MM/yy').format(DateTime.now().subtract(const Duration(days: 7)))} - ${DateFormat('dd/MM/yy').format(DateTime.now())}',
//                     style: const TextStyle(fontSize: 12),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 20),
//               if (state.status == BlocStatus.LOADING) ...[
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 18, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: AppColor.WHITE,
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: const ShimmerBlock(
//                           width: 150, height: 12, borderRadius: 50),
//                     ),
//                     // ShimmerBlock(width: 150, height: 22, borderRadius: 50),
//                     const SizedBox(width: 8),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 18, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: AppColor.WHITE,
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: const ShimmerBlock(
//                           width: 70, height: 12, borderRadius: 50),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//               ] else if (state.overviewDto != null &&
//                   state.overviewDto!.merchantName.isNotEmpty &&
//                   !state.bankSelect!.isOwner) ...[
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 18, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: AppColor.WHITE,
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: RichText(
//                           text: TextSpan(
//                               text: 'Đại lý',
//                               style: const TextStyle(
//                                   fontSize: 12, color: AppColor.GREY_TEXT),
//                               children: [
//                             TextSpan(
//                                 text: ' ${state.overviewDto!.merchantName}',
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.w600, fontSize: 12))
//                           ])),
//                     ),
//                     const SizedBox(width: 8),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 18, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: AppColor.WHITE,
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: Text(
//                           state.overviewDto!.terminals.length > 1
//                               ? '${state.overviewDto!.terminals.length} cửa hàng'
//                               : state.overviewDto!.terminals.length == 1
//                                   ? '${state.overviewDto!.terminals.first} cửa hàng'
//                                   : '0 cửa hàng',
//                           style: const TextStyle(
//                               fontSize: 12, color: AppColor.BLACK)),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//               ],
//               if (state.overviewDto != null)
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 12),
//                         decoration: BoxDecoration(
//                           color: AppColor.WHITE,
//                           borderRadius: BorderRadius.circular(8),
//                           boxShadow: [
//                             BoxShadow(
//                               color: AppColor.BLACK.withOpacity(0.1),
//                               spreadRadius: 1,
//                               blurRadius: 10,
//                               offset: const Offset(0, 1),
//                             )
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             VietQRButton.solid(
//                                 borderRadius: 100,
//                                 width: 30,
//                                 height: 30,
//                                 padding: const EdgeInsets.all(4),
//                                 onPressed: () {},
//                                 isDisabled: false,
//                                 child: const XImage(
//                                   imagePath: 'assets/images/ic-trans-type.png',
//                                   width: 20,
//                                   height: 20,
//                                 )),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   if (state.status == BlocStatus.LOADING) ...[
//                                     const ShimmerBlock(
//                                         width: 100,
//                                         height: 12,
//                                         borderRadius: 10),
//                                     const SizedBox(height: 2),
//                                     const ShimmerBlock(
//                                         width: 70,
//                                         height: 12,
//                                         borderRadius: 10),
//                                   ] else ...[
//                                     AutoSizeText.rich(
//                                       maxLines: 1,
//                                       TextSpan(
//                                         text: CurrencyUtils.instance
//                                             .getCurrencyFormatted(state
//                                                 .overviewDto!.totalCredit
//                                                 .toString()),
//                                         style: const TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.bold,
//                                             color: AppColor.GREEN),
//                                         children: const [
//                                           TextSpan(
//                                             text: ' VND',
//                                             style: TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.normal,
//                                                 color: AppColor.GREY_TEXT),
//                                             children: [],
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     AutoSizeText(
//                                       minFontSize: 10,
//                                       '${state.overviewDto!.countCredit} GD đến (+)',
//                                       style: const TextStyle(fontSize: 12),
//                                     )
//                                   ]
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 12),
//                         decoration: BoxDecoration(
//                           color: AppColor.WHITE,
//                           borderRadius: BorderRadius.circular(8),
//                           boxShadow: [
//                             BoxShadow(
//                               color: AppColor.BLACK.withOpacity(0.1),
//                               spreadRadius: 1,
//                               blurRadius: 10,
//                               offset: const Offset(0, 1),
//                             )
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             VietQRButton.solid(
//                                 borderRadius: 100,
//                                 width: 30,
//                                 height: 30,
//                                 padding: const EdgeInsets.all(4),
//                                 onPressed: () {},
//                                 isDisabled: false,
//                                 child: const XImage(
//                                   imagePath: 'assets/images/ic-trans-debit.png',
//                                   width: 20,
//                                   height: 20,
//                                 )),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   if (state.status == BlocStatus.LOADING) ...[
//                                     const ShimmerBlock(
//                                         width: 100,
//                                         height: 12,
//                                         borderRadius: 10),
//                                     const SizedBox(height: 2),
//                                     const ShimmerBlock(
//                                         width: 70,
//                                         height: 12,
//                                         borderRadius: 10),
//                                   ] else ...[
//                                     AutoSizeText.rich(
//                                       maxLines: 1,
//                                       TextSpan(
//                                         text: CurrencyUtils.instance
//                                             .getCurrencyFormatted(state
//                                                 .overviewDto!.totalDebit
//                                                 .toString()),
//                                         style: const TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.bold,
//                                             color: AppColor.RED_TEXT),
//                                         children: const [
//                                           TextSpan(
//                                             text: ' VND',
//                                             style: TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.normal,
//                                                 color: AppColor.GREY_TEXT),
//                                             children: [],
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     AutoSizeText(
//                                       minFontSize: 8,
//                                       '${state.overviewDto!.countDebit} GD đi (-)',
//                                       style: const TextStyle(fontSize: 12),
//                                     )
//                                   ]
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
