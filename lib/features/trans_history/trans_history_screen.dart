import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/trans_history/blocs/trans_history_bloc.dart';
import 'package:vierqr/features/trans_history/blocs/trans_history_provider.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/related_transaction_receive_dto.dart';

import 'events/trans_history_event.dart';
import 'states/trans_history_state.dart';
import 'views/dialog_edit_view.dart';

class TransHistoryScreen extends StatelessWidget {
  final String bankId;

  const TransHistoryScreen({super.key, required this.bankId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransHistoryBloc(context, bankId),
      child: ChangeNotifierProvider<TransProvider>(
        create: (context) => TransProvider()..setBankId(bankId),
        child: const _BodyWidget(),
      ),
    );
  }
}

class _BodyWidget extends StatefulWidget {
  const _BodyWidget();

  @override
  State<_BodyWidget> createState() => _TransHistoryScreenState();
}

class _TransHistoryScreenState extends State<_BodyWidget> {
  late TransHistoryBloc _bloc;

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
        _bloc.add(TransactionEventGetList(dto));
      },
      (dto) {
        if (dto.type == 5) {
          _bloc.add(TransactionStatusEventFetch(dto));
        } else {
          _bloc.add(TransactionEventFetch(dto));
        }
      },
    );
  }

  Future<void> onRefresh() async {}

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

            if (state.status == BlocStatus.UNLOADING) {
              // Navigator.pop(context);
            }
            if (state.type == TransHistoryType.LOAD_DATA) {
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
                    _buildDropDown(),
                    const SizedBox(height: 16),
                    ...[
                      _buildFormStatus(),
                      _buildDropTime(),
                      _buildFormSearch(),
                      const SizedBox(height: 16),
                    ],
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Danh sách giao dịch',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                      if (state.list.isEmpty)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 100),
                            child: const Center(
                              child: Text('Không có giao dịch nào'),
                            ),
                          ),
                        )
                      else
                        Consumer<TransProvider>(
                            builder: (context, provider, child) {
                          return Expanded(
                            child: RefreshIndicator(
                              onRefresh: onRefresh,
                              child: SingleChildScrollView(
                                controller: provider.scrollControllerList,
                                child: Column(
                                  children: [
                                    ...List.generate(
                                      state.list.length,
                                      (index) {
                                        return _buildElement(
                                          context: context,
                                          dto: state.list[index],
                                        );
                                      },
                                    ).toList(),
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
                          );
                        }),
                    ],
                  ],
                ),
                Consumer<TransProvider>(builder: (context, provider, child) {
                  if (provider.enableDropList) {
                    return Container(
                      padding: EdgeInsets.only(left: 20, top: 62),
                      child: Row(
                        children: [
                          Text(
                            'Trạng thái giao dịch',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColor.TRANSPARENT),
                          ),
                          const SizedBox(width: 30),
                          Expanded(child: _buildSearchList()),
                        ],
                      ),
                    );
                  }
                  return Container();
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildElement({
    required BuildContext context,
    required RelatedTransactionReceiveDTO dto,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.TRANSACTION_DETAIL,
          arguments: {
            'transactionId': dto.transactionId,
          },
        );
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
              '${TransactionUtils.instance.getTransType(dto.transType)} ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)} VND',
              style: TextStyle(
                fontSize: 18,
                color: TransactionUtils.instance.getColorStatus(
                  dto.status,
                  dto.type,
                  dto.transType,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildItem(
                          'Thời gian tạo:',
                          TimeUtils.instance
                              .formatDateFromInt(dto.time, false)),
                      if (dto.type != 0)
                        _buildItem(
                            'Thời gian thanh toán:',
                            TimeUtils.instance
                                .formatDateFromInt(dto.timePaid, false)),
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
                IconButton(
                  onPressed: () async {
                    await NavigatorUtils.showGeneralDialog(
                      context: context,
                      child: DialogEditView(id: dto.transactionId),
                    );
                  },
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.edit, size: 20),
                )
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  bool isEdit = false;

  Widget _buildDropTime() {
    return Consumer<TransProvider>(builder: (context, provider, child) {
      return Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 50,
              margin: const EdgeInsets.only(bottom: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: const Text(
                      'Thời gian',
                      style: TextStyle(fontSize: 14, color: AppColor.GREY_TEXT),
                    ),
                  ),
                  const SizedBox(width: 20),
                  if (!provider.enableDropTime)
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<FilterTimeTransaction>(
                        isExpanded: true,
                        onMenuStateChange: provider.onMenuStateChange,
                        hint: Row(
                          children: [
                            Expanded(
                              child: Text(
                                provider.valueTimeFilter.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: provider.listTimeFilter
                            .map(
                              (FilterTimeTransaction item) =>
                                  DropdownMenuItem<FilterTimeTransaction>(
                                value: item,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          item.title,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    const Divider()
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        value: provider.valueTimeFilter,
                        onChanged: (value) =>
                            provider.changeTimeFilter(value, context, (dto) {
                          _bloc.add(TransactionEventGetList(dto));
                        }),
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: 200,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(Icons.expand_more),
                          iconSize: 16,
                          iconEnabledColor: AppColor.BLACK,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    )
                  else
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => provider.openBottomTime(context, (dto) {
                            _bloc.add(TransactionEventGetList(dto));
                          }),
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Text(
                                  'Từ ${TimeUtils.instance.formatDateToString(provider.fromDate, isExport: true)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.BLACK,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Đến ${TimeUtils.instance.formatDateToString(provider.toDate, isExport: true)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.BLACK,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => provider.resetFilterTime((dto) {
                            _bloc.add(TransactionEventGetList(dto));
                          }),
                          child: const Icon(
                            Icons.clear,
                            size: 20,
                          ),
                        )
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFormSearch() {
    return Consumer<TransProvider>(builder: (context, provider, child) {
      if (provider.valueFilter.id.typeTrans != TypeFilter.ALL &&
          provider.valueFilter.id.typeTrans != TypeFilter.STATUS_TRANS) {
        return Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFieldCustom(
                  isObscureText: false,
                  fillColor: AppColor.WHITE,
                  title: '',
                  controller: provider.controller,
                  hintText: provider.hintText,
                  inputType: TextInputType.text,
                  keyboardAction: TextInputAction.next,
                  onChange: provider.updateKeyword,
                ),
              ),
              const SizedBox(width: 10),
              MButtonWidget(
                title: 'Tìm kiếm',
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.zero,
                colorEnableBgr: AppColor.BLUE_TEXT,
                colorEnableText: AppColor.WHITE,
                isEnable: true,
                height: 46,
                onTap: () => provider.onSearch((dto) {
                  _bloc.add(TransactionEventGetList(dto));
                }),
              ),
            ],
          ),
        );
      }
      return const SizedBox();
    });
  }

  Widget _buildFormStatus() {
    return Consumer<TransProvider>(builder: (context, provider, child) {
      if (provider.valueFilter.id.typeTrans == TypeFilter.STATUS_TRANS) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColor.WHITE,
          ),
          child: Row(
            children: [
              Text(
                'Trạng thái giao dịch',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: provider.onHandleTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${provider.statusValue.title}',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.expand_more,
                          color: AppColor.BLACK,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }

      return const SizedBox();
    });
  }

  Widget _buildDropDown() {
    return Consumer<TransProvider>(builder: (context, provider, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Bộ lọc',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton2<FilterTransaction>(
              isExpanded: true,
              onMenuStateChange: provider.onMenuStateChange,
              hint: Row(
                children: [
                  Expanded(
                    child: Text(
                      provider.valueFilter.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: provider.listFilter
                  .map(
                    (FilterTransaction item) =>
                        DropdownMenuItem<FilterTransaction>(
                      value: item,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          const Divider()
                        ],
                      ),
                    ),
                  )
                  .toList(),
              value: provider.valueFilter,
              onChanged: (value) => provider.changeFilter(value, (dto) {
                if (dto.type == 5) {
                  _bloc.add(TransactionStatusEventGetList(dto));
                } else {
                  _bloc.add(TransactionEventGetList(dto));
                }
              }),
              buttonStyleData: ButtonStyleData(
                height: 45,
                width: 200,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.expand_more),
                iconSize: 16,
                iconEnabledColor: AppColor.BLACK,
                iconDisabledColor: Colors.grey,
              ),
              dropdownStyleData: DropdownStyleData(
                width: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          if (provider.valueFilter.id.typeTrans != TypeFilter.ALL)
            MButtonWidget(
              title: 'Xoá bộ lọc',
              onTap: () => provider.resetFilter((dto) {
                _bloc.add(TransactionEventGetList(dto));
              }),
              padding: EdgeInsets.symmetric(horizontal: 16),
              margin: EdgeInsets.zero,
              height: 40,
              radius: 40,
              colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.3),
              isEnable: true,
              colorEnableText: AppColor.BLUE_TEXT,
            )
        ],
      );
    });
  }

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
            flex: 3,
            child: Text(value, style: style, maxLines: maxLines),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchList() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<TransProvider>(builder: (context, provider, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(
                    parent: NeverScrollableScrollPhysics()),
                itemCount: provider.listStatus.length,
                itemBuilder: (context, position) {
                  String title = provider.listStatus[position].title;
                  return InkWell(
                    onTap: () => provider.onChangedStatus(position, (dto) {
                      _bloc.add(TransactionStatusEventGetList(dto));
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 16.0),
                      decoration: BoxDecoration(
                        border: position != (provider.listStatus.length - 1)
                            ? Border(
                                bottom: BorderSide(
                                    color: AppColor.GREY_TEXT.withOpacity(0.3),
                                    width: 0.5))
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(color: Colors.black),
                          ),
                          if (position == 0)
                            const Icon(
                              Icons.expand_less,
                              color: AppColor.BLACK,
                              size: 16,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      );

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }
}
