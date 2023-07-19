import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';

import 'package:vierqr/features/branch/blocs/branch_bloc.dart';
import 'package:vierqr/features/branch/states/branch_state.dart';
import 'package:vierqr/features/business/blocs/business_trans_bloc.dart';
import 'package:vierqr/features/business/events/business_trans_event.dart';
import 'package:vierqr/features/business/states/business_trans_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/branch_filter_dto.dart';
import 'package:vierqr/models/business_detail_dto.dart';
import 'package:vierqr/models/transaction_branch_input_dto.dart';
import 'package:vierqr/services/providers/business_inforamtion_provider.dart';

class BusinessTransactionView extends StatelessWidget {
  const BusinessTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BusinessTransBloc>(
      create: (BuildContext context) => BusinessTransBloc(context),
      child: const _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatefulWidget {
  const _BodyWidget({super.key});

  @override
  State<_BodyWidget> createState() => _BusinessTransactionViewState();
}

class _BusinessTransactionViewState extends State<_BodyWidget> {
  late BusinessTransBloc _bloc;

  final ScrollController scrollController = ScrollController();

  int offset = 0;

  bool isEnded = false;

  void initialServices(BuildContext context) {
    isEnded = false;
    offset = 0;

    _bloc.add(
      TransactionEventGetListBranch(
        dto: TransactionBranchInputDTO(
            businessId:
                Provider.of<BusinessInformationProvider>(context, listen: false)
                    .businessId,
            branchId: 'all',
            offset: 0),
      ),
    );

    // if (filters.where((element) => element.branchId == 'all').isEmpty) {
    //   filters.add(const BranchFilterDTO(
    //       branchId: 'all', branchName: 'Tất cả chi nhánh'));
    // }
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // ListView đã cuộn đến cuối
        // Xử lý tại đây
        offset += 1;
        Future.delayed(const Duration(milliseconds: 0), () {
          TransactionBranchInputDTO transactionInputDTO =
              TransactionBranchInputDTO(
            businessId:
                Provider.of<BusinessInformationProvider>(context, listen: false)
                    .businessId,
            branchId:
                Provider.of<BusinessInformationProvider>(context, listen: false)
                    .filterSelected
                    .branchId,
            offset: offset * 20,
          );
          _bloc.add(TransactionEventFetchBranch(dto: transactionInputDTO));
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: BlocConsumer<BusinessTransBloc, BusinessTransState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            children: [
              const SubHeader(title: 'Lịch sử giao dịch'),
              //filter search
              BlocBuilder<BranchBloc, BranchState>(
                builder: (context, brandState) {
                  // if (brandState is BranchGetFilterSuccessState) {
                  //   filters.clear();
                  //   if (filters
                  //       .where((element) => element.branchId == 'all')
                  //       .isEmpty) {
                  //     filters.add(const BranchFilterDTO(
                  //         branchId: 'all', branchName: 'Tất cả chi nhánh'));
                  //   }
                  //   if (filters.length <= 1) {
                  //     filters.addAll(brandState.list);
                  //   }
                  // }
                  return Visibility(
                    visible: state.listBranch.isNotEmpty,
                    child: BoxLayout(
                      width: width - 20,
                      borderRadius: 5,
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
                            child: Consumer<BusinessInformationProvider>(
                              builder: (context, provider, child) {
                                return DropdownButton<BranchFilterDTO>(
                                  value: provider.filterSelected,
                                  isDense: true,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  onChanged: (BranchFilterDTO? value) {
                                    if (value == null) {
                                      provider.updateFilterSelected(
                                          provider.filterSelected);
                                    } else {
                                      isEnded = false;
                                      provider.updateFilterSelected(value);
                                      _bloc.add(
                                        TransactionEventGetListBranch(
                                          dto: TransactionBranchInputDTO(
                                              businessId:
                                                  provider.input.businessId,
                                              branchId: value.branchId,
                                              offset: 0),
                                        ),
                                      );
                                      provider.updateInput(
                                        TransactionBranchInputDTO(
                                            businessId:
                                                provider.input.businessId,
                                            branchId: value.branchId,
                                            offset: 0),
                                      );
                                    }
                                  },
                                  items: state.listBranch
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
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
                child: Consumer<BusinessInformationProvider>(
                  builder: (context, provider, child) {
                    return (state.listTrans.isEmpty)
                        ? const SizedBox()
                        : ListView.builder(
                            shrinkWrap: true,
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: state.listTrans.length + 1,
                            itemBuilder: (context, index) {
                              return (index == state.listTrans.length &&
                                      !isEnded)
                                  ? const UnconstrainedBox(
                                      child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CircularProgressIndicator(
                                          color: AppColor.BLUE_TEXT,
                                        ),
                                      ),
                                    )
                                  : (index == state.listTrans.length && isEnded)
                                      ? const SizedBox()
                                      : _buildTransactionItem(
                                          context: context,
                                          dto: state.listTrans[index],
                                        );
                            },
                          );
                  },
                ),
              ),
            ],
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
