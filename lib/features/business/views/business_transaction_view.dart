import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';

import 'package:vierqr/features/branch/blocs/branch_bloc.dart';
import 'package:vierqr/features/branch/states/branch_state.dart';
import 'package:vierqr/features/business/blocs/business_trans_bloc.dart';
import 'package:vierqr/features/business/events/business_trans_event.dart';
import 'package:vierqr/features/business/providers/business_trans_provider.dart';
import 'package:vierqr/features/business/states/business_trans_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/branch_filter_dto.dart';
import 'package:vierqr/models/branch_filter_insert_dto.dart';
import 'package:vierqr/models/business_detail_dto.dart';
import 'package:vierqr/models/transaction_branch_input_dto.dart';
import 'package:vierqr/services/providers/business_inforamtion_provider.dart';

class BusinessTransactionView extends StatelessWidget {
  const BusinessTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BusinessTransBloc>(
      create: (BuildContext context) => BusinessTransBloc(context),
      child: ChangeNotifierProvider(
        create: (context) => BusinessTransProvider(),
        child: const _BodyWidget(),
      ),
    );
  }
}

class _BodyWidget extends StatefulWidget {
  const _BodyWidget();

  @override
  State<_BodyWidget> createState() => _BusinessTransactionViewState();
}

class _BusinessTransactionViewState extends State<_BodyWidget> {
  late BusinessTransBloc _bloc;
  final scrollController = ScrollController();

  void initialServices(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    BranchFilterInsertDTO brandDTO = args['brandDTO'];

    Provider.of<BusinessTransProvider>(context, listen: false)
        .updateFilters([]);
    Provider.of<BusinessTransProvider>(context, listen: false)
        .updateBranchFilter(brandDTO);

    _bloc.add(BranchEventGetFilter(dto: brandDTO));

    _bloc.add(
      TransactionEventGetListBranch(
          dto: TransactionBranchInputDTO(
              businessId: brandDTO.businessId, branchId: 'all', offset: 0)),
    );

    scrollController.addListener(() {
      final maxScroll = scrollController.position.maxScrollExtent;
      if (scrollController.offset >= maxScroll &&
          !scrollController.position.outOfRange) {
        _onLoadMore();
      }
    });
  }

  _onLoadMore() {
    String businessId =
        Provider.of<BusinessTransProvider>(context, listen: false)
                .brandDTO
                ?.businessId ??
            '';
    String branchId = Provider.of<BusinessTransProvider>(context, listen: false)
            .filterSelected
            ?.branchId ??
        '';

    TransactionBranchInputDTO dto = TransactionBranchInputDTO(
      businessId: businessId,
      branchId: branchId,
      offset: 0,
    );

    _bloc.add(TransactionEventFetchBranch(dto: dto));
  }

  Future<void> onRefresh() async {
    String businessId =
        Provider.of<BusinessTransProvider>(context, listen: false)
                .brandDTO
                ?.businessId ??
            '';
    String branchId = Provider.of<BusinessTransProvider>(context, listen: false)
            .filterSelected
            ?.branchId ??
        '';

    _bloc.add(
      TransactionEventGetListBranch(
          dto: TransactionBranchInputDTO(
              businessId: businessId, branchId: branchId, offset: 0)),
    );
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialServices(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const MAppBar(title: 'Lịch sử giao dịch'),
      body: Consumer<BusinessTransProvider>(
        builder: (context, provider, child) {
          return BlocConsumer<BusinessTransBloc, BusinessTransState>(
            listener: (context, state) {
              if (state.type == TransType.GET_FILTER) {
                provider.updateFilters(state.listBranch);
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  //filter search
                  Visibility(
                    visible: provider.filters.isNotEmpty,
                    child: BoxLayout(
                      width: width - 20,
                      borderRadius: 5,
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 120,
                            child: Text(
                              'Chọn chi nhánh',
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Expanded(
                            child: DropdownButton<BranchFilterDTO>(
                              value: provider.filterSelected,
                              isDense: true,
                              isExpanded: true,
                              underline: const SizedBox(),
                              onChanged: (BranchFilterDTO? value) {
                                provider.updateFilterSelected(value);
                                _bloc.add(
                                  TransactionEventGetListBranch(
                                    dto: TransactionBranchInputDTO(
                                        businessId:
                                            provider.brandDTO?.businessId ?? '',
                                        branchId: value?.branchId ?? '',
                                        offset: 0),
                                  ),
                                );
                                scrollController.jumpTo(0.0);
                              },
                              items: provider.filters
                                  .map<DropdownMenuItem<BranchFilterDTO>>(
                                      (BranchFilterDTO value) {
                                return DropdownMenuItem<BranchFilterDTO>(
                                  value: value,
                                  child: Text(
                                    value.branchName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10, left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Danh sách giao dịch',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: state.listTrans.isEmpty
                        ? const SizedBox()
                        : RefreshIndicator(
                            onRefresh: onRefresh,
                            child: SingleChildScrollView(
                              controller: scrollController,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  Column(
                                    children: List.generate(
                                      state.listTrans.length,
                                      (index) {
                                        return _buildTransactionItem(
                                          context: context,
                                          dto: state.listTrans[index],
                                        );
                                      },
                                    ).toList(),
                                  ),
                                  if (!state.isLoadMore)
                                    const UnconstrainedBox(
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator(
                                          color: AppColor.BLUE_TEXT,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTransactionItem({
    required BuildContext context,
    required BusinessTransactionDTO dto,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.TRANSACTION_DETAIL,
          arguments: {
            'transactionId': dto.transactionId,
            'businessTransactionBloc': _bloc,
          },
        );
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 25,
              height: 25,
              child: Icon(
                TransactionUtils.instance
                    .getIconStatus(dto.status, dto.tranStype),
                color: TransactionUtils.instance
                    .getColorStatus(dto.status, dto.type, dto.tranStype),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${TransactionUtils.instance.getTransType(dto.tranStype)} ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)}',
                    style: TextStyle(
                      fontSize: 18,
                      color: TransactionUtils.instance
                          .getColorStatus(dto.status, dto.type, dto.tranStype),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 3)),
                  Text(
                    'Đến TK: ${dto.bankAccount}',
                    style: const TextStyle(),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 3)),
                  Text(
                    dto.content.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColor.GREY_TEXT,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                TimeUtils.instance.formatDateFromInt(dto.time, true),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';
// import 'package:vierqr/commons/constants/configurations/route.dart';
// import 'package:vierqr/commons/constants/configurations/theme.dart';
// import 'package:vierqr/commons/enums/enum_type.dart';
// import 'package:vierqr/commons/utils/currency_utils.dart';
// import 'package:vierqr/commons/utils/time_utils.dart';
// import 'package:vierqr/commons/utils/transaction_utils.dart';
// import 'package:vierqr/commons/widgets/sub_header_widget.dart';
//
// import 'package:vierqr/features/branch/blocs/branch_bloc.dart';
// import 'package:vierqr/features/branch/states/branch_state.dart';
// import 'package:vierqr/features/transaction/blocs/transaction_bloc.dart';
// import 'package:vierqr/features/transaction/events/transaction_event.dart';
// import 'package:vierqr/features/transaction/states/transaction_state.dart';
// import 'package:vierqr/layouts/box_layout.dart';
// import 'package:vierqr/models/branch_filter_dto.dart';
// import 'package:vierqr/models/business_detail_dto.dart';
// import 'package:vierqr/models/transaction_branch_input_dto.dart';
// import 'package:vierqr/services/providers/business_inforamtion_provider.dart';
//
// class BusinessTransactionView extends StatelessWidget {
//   late TransactionBloc transactionBloc;
//   final ScrollController scrollController = ScrollController();
//   final List<BranchFilterDTO> filters = [];
//   final List<BusinessTransactionDTO> transactions = [];
//   int offset = 0;
//   bool isEnded = false;
//
//   BusinessTransactionView({super.key});
//
//   void initialServices(BuildContext context) {
//     transactions.clear();
//     filters.clear();
//     isEnded = false;
//     offset = 0;
//     transactionBloc = BlocProvider.of(context);
//     Future.delayed(const Duration(milliseconds: 0), () {
//       transactionBloc.add(
//         TransactionEventGetListBranch(
//           dto: TransactionBranchInputDTO(
//               businessId: Provider.of<BusinessInformationProvider>(context,
//                       listen: false)
//                   .businessId,
//               branchId: 'all',
//               offset: 0),
//         ),
//       );
//     });
//     if (filters.where((element) => element.branchId == 'all').isEmpty) {
//       filters.add(const BranchFilterDTO(
//           branchId: 'all', branchName: 'Tất cả chi nhánh'));
//     }
//     scrollController.addListener(() {
//       if (scrollController.position.pixels ==
//           scrollController.position.maxScrollExtent) {
//         // ListView đã cuộn đến cuối
//         // Xử lý tại đây
//         offset += 1;
//         Future.delayed(const Duration(milliseconds: 0), () {
//           TransactionBranchInputDTO transactionInputDTO =
//               TransactionBranchInputDTO(
//             businessId:
//                 Provider.of<BusinessInformationProvider>(context, listen: false)
//                     .businessId,
//             branchId:
//                 Provider.of<BusinessInformationProvider>(context, listen: false)
//                     .filterSelected
//                     .branchId,
//             offset: offset * 20,
//           );
//           transactionBloc
//               .add(TransactionEventFetchBranch(dto: transactionInputDTO));
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;
//     initialServices(context);
//     return Scaffold(
//       appBar: AppBar(toolbarHeight: 0),
//       body: Column(
//         children: [
//           const SubHeader(title: 'Lịch sử giao dịch'),
//           //filter search
//           BlocBuilder<BranchBloc, BranchState>(
//             builder: (context, state) {
//               if (state is BranchGetFilterSuccessState) {
//                 filters.clear();
//                 if (filters
//                     .where((element) => element.branchId == 'all')
//                     .isEmpty) {
//                   filters.add(const BranchFilterDTO(
//                       branchId: 'all', branchName: 'Tất cả chi nhánh'));
//                 }
//                 if (filters.length <= 1) {
//                   filters.addAll(state.list);
//                 }
//               }
//               return Visibility(
//                 visible: filters.isNotEmpty,
//                 child: BoxLayout(
//                   width: width - 20,
//                   borderRadius: 5,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                   child: Row(
//                     children: [
//                       const SizedBox(
//                         width: 120,
//                         child: Text(
//                           'Chọn chi nhánh',
//                         ),
//                       ),
//                       const Padding(padding: EdgeInsets.only(left: 10)),
//                       Expanded(
//                         child: Consumer<BusinessInformationProvider>(
//                           builder: (context, provider, child) {
//                             return DropdownButton<BranchFilterDTO>(
//                               value: provider.filterSelected,
//                               isDense: true,
//                               isExpanded: true,
//                               underline: const SizedBox(),
//                               onChanged: (BranchFilterDTO? value) {
//                                 if (value == null) {
//                                   provider.updateFilterSelected(
//                                       provider.filterSelected);
//                                 } else {
//                                   transactions.clear();
//                                   isEnded = false;
//                                   provider.updateFilterSelected(value);
//                                   transactionBloc.add(
//                                     TransactionEventGetListBranch(
//                                       dto: TransactionBranchInputDTO(
//                                           businessId: provider.input.businessId,
//                                           branchId: value.branchId,
//                                           offset: 0),
//                                     ),
//                                   );
//                                   provider.updateInput(
//                                     TransactionBranchInputDTO(
//                                         businessId: provider.input.businessId,
//                                         branchId: value.branchId,
//                                         offset: 0),
//                                   );
//                                 }
//                               },
//                               items: filters
//                                   .map<DropdownMenuItem<BranchFilterDTO>>(
//                                       (BranchFilterDTO value) {
//                                 return DropdownMenuItem<BranchFilterDTO>(
//                                   value: value,
//                                   child: Text(
//                                     value.branchName,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: const TextStyle(
//                                       fontSize: 13,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//           const Padding(
//             padding: EdgeInsets.only(top: 20, bottom: 10, left: 20),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Danh sách giao dịch',
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Consumer<BusinessInformationProvider>(
//               builder: (context, provider, child) {
//                 return BlocBuilder<TransactionBloc, TransactionState>(
//                   builder: (context, state) {
//                     if (state.type == TransactionType.GET_LIST) {
//                       transactions.clear();
//                       if (state.list.isEmpty || state.list.length < 20) {
//                         isEnded = true;
//                       } else {
//                         isEnded = false;
//                       }
//                       if (transactions.isEmpty) {
//                         transactions.addAll(state.list);
//                       }
//                     }
//                     if (state is TransactionFetchBranchSuccessState) {
//                       if (state.list.isEmpty || state.list.length < 20) {
//                         isEnded = true;
//                       } else {
//                         isEnded = false;
//                         transactions.addAll(state.list);
//                       }
//                     }
//                     return (transactions.isEmpty)
//                         ? const SizedBox()
//                         : ListView.builder(
//                             shrinkWrap: true,
//                             controller: scrollController,
//                             padding: const EdgeInsets.symmetric(horizontal: 20),
//                             itemCount: transactions.length + 1,
//                             itemBuilder: (context, index) {
//                               return (index == transactions.length && !isEnded)
//                                   ? const UnconstrainedBox(
//                                       child: SizedBox(
//                                         width: 50,
//                                         height: 50,
//                                         child: CircularProgressIndicator(
//                                           color: AppColor.BLUE_TEXT,
//                                         ),
//                                       ),
//                                     )
//                                   : (index == transactions.length && isEnded)
//                                       ? const SizedBox()
//                                       : _buildTransactionItem(
//                                           context: context,
//                                           dto: transactions[index],
//                                         );
//                             },
//                           );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTransactionItem({
//     required BuildContext context,
//     required BusinessTransactionDTO dto,
//   }) {
//     final double width = MediaQuery.of(context).size.width;
//     return InkWell(
//       onTap: () {
//         Navigator.pushNamed(
//           context,
//           Routes.TRANSACTION_DETAIL,
//           arguments: {
//             'transactionId': dto.transactionId,
//             'businessTransactionBloc': transactionBloc,
//           },
//         );
//       },
//       child: Container(
//         width: width,
//         padding: const EdgeInsets.symmetric(vertical: 15),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               width: 25,
//               height: 25,
//               child: Icon(
//                 TransactionUtils.instance
//                     .getIconStatus(dto.status, dto.tranStype),
//                 color: TransactionUtils.instance
//                     .getColorStatus(dto.status, dto.type, dto.tranStype),
//               ),
//             ),
//             const Padding(padding: EdgeInsets.only(left: 5)),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '${TransactionUtils.instance.getTransType(dto.tranStype)} ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)}',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: TransactionUtils.instance
//                           .getColorStatus(dto.status, dto.type, dto.tranStype),
//                     ),
//                   ),
//                   const Padding(padding: EdgeInsets.only(top: 3)),
//                   Text(
//                     'Đến TK: ${dto.bankAccount}',
//                     style: const TextStyle(),
//                   ),
//                   const Padding(padding: EdgeInsets.only(top: 3)),
//                   Text(
//                     dto.content.trim(),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       color: AppColor.GREY_TEXT,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Align(
//               alignment: Alignment.topRight,
//               child: Text(
//                 TimeUtils.instance.formatDateFromInt(dto.time, true),
//                 textAlign: TextAlign.right,
//                 style: const TextStyle(
//                   fontSize: 13,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
