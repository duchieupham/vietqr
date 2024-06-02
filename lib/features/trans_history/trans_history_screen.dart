import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/trans_history/blocs/trans_history_bloc.dart';
import 'package:vierqr/features/trans_history/blocs/trans_history_provider.dart';
import 'package:vierqr/features/trans_history/views/bottom_sheet_filter.dart';
import 'package:vierqr/features/transaction_detail/repositories/transaction_repository.dart';
import 'package:vierqr/features/transaction_detail/transaction_detail_screen.dart';
import 'package:vierqr/models/terminal_response_dto.dart';
import 'package:vierqr/models/trans_dto.dart';
import 'package:vierqr/models/transaction_input_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import 'events/trans_history_event.dart';
import 'states/trans_history_state.dart';

class TransHistoryScreen extends StatelessWidget {
  final String bankId;
  final String bankUserId;

  // final TerminalDto terminalDto;
  final List<TerminalAccountDTO> terminalAccountList;

  const TransHistoryScreen({
    super.key,
    required this.bankId,
    required this.bankUserId,
    // required this.terminalDto,
    required this.terminalAccountList,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransHistoryBloc(context,
          getIt.get<TransactionRepository>(), bankId, terminalAccountList),
      child: ChangeNotifierProvider<TransProvider>(
        create: (context) =>
            TransProvider(bankUserId == SharePrefUtils.getProfile().userId, [
          TerminalAccountDTO(
              terminalCode: 'Tất cả (mặc định)',
              terminalName: 'Tất cả (mặc định)'),
          // TerminalResponseDTO(
          //     banks: [], code: 'Tất cả (mặc định)', name: 'Tất cả (mặc định)'),
          ...terminalAccountList
        ])
              ..setBankId(bankId),
        child: _BodyWidget(bankId: bankId, bankUserId: bankUserId),
      ),
    );
  }
}

class _BodyWidget extends StatefulWidget {
  final String bankId;
  final String bankUserId;

  const _BodyWidget({required this.bankId, required this.bankUserId});

  @override
  State<_BodyWidget> createState() => _TransHistoryScreenState();
}

class _TransHistoryScreenState extends State<_BodyWidget> {
  late TransHistoryBloc _bloc;
  List<TransDTO> listTransaction = [];
  List<TransDTO> listFilterTransaction = [];

  bool get isOwner => widget.bankUserId == SharePrefUtils.getProfile().userId;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData(context);
    });
  }

  void initData(BuildContext context) {
    Provider.of<TransProvider>(context, listen: false).init(
      (dto) {
        if (isOwner) {
          _bloc.add(TransactionEventIsOwnerGetList(dto));
        } else {
          _bloc.add(TransactionEventGetList(dto));
        }
      },
      (dto) {
        if (isOwner) {
          _bloc.add(TransactionEventFetchIsOwner(dto));
        } else {
          _bloc.add(TransactionEventFetch(dto));
        }
      },
    );
  }

  Future<void> onRefresh(TransactionInputDTO dto) async {
    if (isOwner) {
      _bloc.add(TransactionEventIsOwnerGetList(dto));
    } else {
      _bloc.add(TransactionEventGetList(dto));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocConsumer<TransHistoryBloc, TransHistoryState>(
          listener: (context, state) {
            if (state.status == BlocStatus.LOADING) {
              // DialogWidget.instance.openLoadingDialog();
            }
            if (state.type == TransactionType.LOAD_DATA) {}
            if (state.status == BlocStatus.UNLOADING) {
              listTransaction = state.list;
              listFilterTransaction = state.list;
              // Navigator.pop(context);
            }
            if (state.type == TransHistoryType.LOAD_DATA) {
              listTransaction = state.list;
              listFilterTransaction = state.list;
              Provider.of<TransProvider>(context, listen: false)
                  .updateCallLoadMore(true);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Danh sách giao dịch',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              if (!isOwner)
                                Text(
                                  'Hiển thị các giao dịch thuộc cửa hàng của bạn.',
                                  style: TextStyle(
                                      fontSize: 12, color: AppColor.GREY_TEXT),
                                ),
                            ],
                          ),
                        ),
                        Consumer<TransProvider>(
                          builder: (context, provider, child) {
                            return GestureDetector(
                              onTap: () =>
                                  onFilter(provider, provider.terminalList),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: AppColor.BLUE_TEXT.withOpacity(0.3)),
                                child: Image.asset(
                                  'assets/images/ic-filter-blue.png',
                                  height: 36,
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Consumer<TransProvider>(builder: (context, provider, _) {
                      return Row(
                        children: [
                          Text(
                            'Lọc theo:',
                            style: TextStyle(
                                fontSize: 12, color: AppColor.GREY_TEXT),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  if (provider.valueFilter.id == 4) ...[
                                    if (isOwner)
                                      _buildFilterWith(
                                          'Cửa hàng: ${provider.keywordSearch}')
                                    else
                                      _buildFilterWith(
                                          'Cửa hàng: ${provider.terminalAccountDTO.terminalName}'),
                                    const SizedBox(width: 4),
                                  ] else if (!isOwner) ...[
                                    _buildFilterWith(
                                        'Cửa hàng: ${provider.terminalAccountDTO.terminalName}'),
                                    const SizedBox(width: 4),
                                  ],
                                  if (provider.valueFilter.id == 5) ...[
                                    _buildFilterWith(
                                        'Trạng thái: ${provider.statusValue.title}'),
                                    const SizedBox(width: 4),
                                  ],
                                  if (provider.valueFilter.id == 3) ...[
                                    _buildFilterWith(
                                        'Nội dung: ${provider.keywordSearch}'),
                                    const SizedBox(width: 4),
                                  ],
                                  if (provider.valueFilter.id == 2) ...[
                                    _buildFilterWith(
                                        'Mã đơn hàng: ${provider.keywordSearch}'),
                                    const SizedBox(width: 4),
                                  ],
                                  if (provider.valueFilter.id == 1) ...[
                                    _buildFilterWith(
                                        'Mã giao dịch: ${provider.keywordSearch}'),
                                    const SizedBox(width: 4),
                                  ],
                                  ...[
                                    if (provider.valueTimeFilter.id != 5)
                                      _buildFilterWith(
                                          'Thời gian: ${provider.valueTimeFilter.title}')
                                    else
                                      _buildFilterWith(
                                          'Thời gian: từ ${provider.fromDateText} đến ${provider.toDateText}'),
                                  ],
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }),
                    const SizedBox(height: 12),
                    if (state.status == BlocStatus.LOADING)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 100),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.BLUE_TEXT,
                            ),
                          ),
                        ),
                      )
                    else ...[
                      Consumer<TransProvider>(
                          builder: (context, provider, child) {
                        return Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              provider.onSearch((dto) {
                                if (dto.type == 5) {
                                  _bloc.add(TransactionEventIsOwnerGetList(dto,
                                      isLoading: false));
                                } else {
                                  if (isOwner) {
                                    _bloc.add(TransactionEventIsOwnerGetList(
                                        dto,
                                        isLoading: false));
                                  } else {
                                    _bloc.add(TransactionEventGetList(dto,
                                        isLoading: false));
                                  }
                                }
                              });
                            },
                            child: SingleChildScrollView(
                              controller: provider.scrollControllerList,
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  if (state.isEmpty)
                                    Column(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 200),
                                          child: const Center(
                                            child:
                                                Text('Không có giao dịch nào'),
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    ...List.generate(
                                      listTransaction.length,
                                      (index) {
                                        return _buildElement(
                                          context: context,
                                          dto: listTransaction[index],
                                        );
                                      },
                                    ).toList(),
                                  if (state.isLoadMore)
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
                        );
                      }),
                    ],
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildElement({
    required BuildContext context,
    required TransDTO dto,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        NavigatorUtils.navigatePage(
            context, TransactionDetailScreen(transactionId: dto.transactionId),
            routeName: TransactionDetailScreen.routeName);
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColor.WHITE,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              '${TransactionUtils.instance.getTransType(dto.transType)} ${dto.amount.contains('*') ? dto.amount : CurrencyUtils.instance.getCurrencyFormatted(dto.amount)} VND',
              style: TextStyle(fontSize: 18, color: dto.getColorStatus),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (dto.isTimeCreate)
                        _buildItem(
                            'Thời gian tạo:',
                            TimeUtils.instance.formatDateFromInt(
                                dto.time, false,
                                isShowHHmmFirst: true)),
                      if (dto.isTimeTT)
                        _buildItem(
                            'Thời gian TT:',
                            TimeUtils.instance.formatDateFromInt(
                                dto.timePaid, false,
                                isShowHHmmFirst: true)),
                      _buildItem(
                        'Trạng thái:',
                        TransactionUtils.instance.getStatusString(dto.status),
                        style: TextStyle(
                          color: TransactionUtils.instance.getColorStatus(
                            dto.status,
                            dto.type,
                            dto.transType,
                          ),
                        ),
                      ),
                      _buildItem(
                        'Nội dung:',
                        dto.content,
                        style: const TextStyle(color: AppColor.GREY_TEXT),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  bool isEdit = false;

  Widget _buildItem(String title, String value,
      {TextStyle? style, int? maxLines}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(color: AppColor.GREY_TEXT),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 4,
            child: Text(value, style: style, maxLines: maxLines),
          ),
        ],
      ),
    );
  }

  void onFilter(
      TransProvider provider, List<TerminalAccountDTO> terminals) async {
    await DialogWidget.instance.showModelBottomSheet(
      isDismissible: true,
      margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      height: MediaQuery.of(context).size.height * 0.8,
      borderRadius: BorderRadius.circular(16),
      widget: BottomSheetFilter(
        terminals: terminals,
        bankId: widget.bankId,
        isOwner: isOwner,
        fromDate: provider.fromDate,
        toDate: provider.toDate!,
        filterTransaction: provider.valueFilter,
        keyword: provider.keywordSearch,
        codeTerminal: provider.codeTerminal,
        filterStatusTransaction: provider.statusValue,
        filterTerminal: provider.valueFilterTerminal,
        filterTimeTransaction: provider.valueTimeFilter,
        // terminalResponseDTO: provider.terminalResponseDTO,
        terminalAcc: provider.terminalAccountDTO,
        onApply: (dto,
            fromDate,
            toDate,
            timeFilter,
            valueFilter,
            keyword,
            codeTerminal,
            stateValue,
            valueFilerTerminal,
            terminalResponseDTO) async {
          if (isOwner) {
            if (valueFilter.id == 5) {
              _bloc.add(TransactionEventIsOwnerGetList(dto));
            } else {
              _bloc.add(TransactionEventIsOwnerGetList(dto));
            }
          } else {
            _bloc.add(TransactionEventGetList(dto));
          }

          provider.updateDataFilter(
            valueFilerTerminal,
            valueFilter,
            stateValue,
            keyword,
            codeTerminal,
            timeFilter,
            fromDate,
            toDate,
            terminalResponseDTO,
          );
        },
        reset: () {
          provider.resetFilter((dto) {
            if (isOwner) {
              _bloc.add(TransactionEventIsOwnerGetList(dto));
            } else {
              _bloc.add(TransactionEventGetList(dto));
            }
          }, isOwner);
        },
      ),
    );
  }

  Widget _buildFilterWith(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor.BLUE_TEXT.withOpacity(0.3),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
      ),
    );
  }
}
