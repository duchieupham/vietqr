import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/icon_navigate_next_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/bank_type/blocs/bank_type_bloc.dart';
import 'package:vierqr/features/bank_type/events/bank_type_event.dart';
import 'package:vierqr/features/bank_type/states/bank_type_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/services/providers/add_bank_provider.dart';
import 'package:vierqr/services/providers/search_clear_provider.dart';

class SelectBankTypeWidget extends StatelessWidget {
  //
  final TextEditingController searchController = TextEditingController();

  final Function(int)? callBack;

  //
  final List<BankTypeDTO> bankTypesResult = [];
  final List<BankTypeDTO> bankTypes = [];
  static late BankTypeBloc bankTypeBloc;
  static final _formKey = GlobalKey<FormState>();

  static final SearchClearProvider _searchClearProvider =
      SearchClearProvider(false);

  SelectBankTypeWidget({
    super.key,
    this.callBack,
  });

  void initialServices(BuildContext context) {
    bankTypeBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<BankTypeBloc, BankTypeState>(
            builder: (context, state) {
              if (state is BankTypeLoadingState) {
                return SizedBox(
                  width: width,
                  height: 200,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: DefaultTheme.GREEN,
                    ),
                  ),
                );
              }
              if (state is BankTypeGetListSuccessfulState) {
                if (state.list.isNotEmpty && bankTypes.isEmpty) {
                  bankTypes.addAll(state.list);
                  bankTypesResult.addAll(bankTypes);
                }
              }
              if (state is BankTypeSearchState) {
                bankTypesResult.clear();
                bankTypesResult.addAll(state.list);
              }
              return Visibility(
                visible: bankTypesResult.isNotEmpty,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: bankTypesResult.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    return _buildBankTypeItem(
                        context, bankTypesResult[index], width);
                  },
                  separatorBuilder: (context, index) {
                    return DividerWidget(width: width);
                  },
                ),
              );
            },
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 20)),
        BoxLayout(
          width: width,
          borderRadius: 50,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 15,
                color: Theme.of(context).hintColor,
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: TextFieldWidget(
                    width: width,
                    hintText: 'Tìm theo tên',
                    controller: searchController,
                    keyboardAction: TextInputAction.done,
                    autoFocus: true,
                    onChange: (value) {
                      if (searchController.text.isNotEmpty) {
                        _searchClearProvider.updateClearSearch(true);
                        bankTypeBloc.add(
                          BankTypeEventSearch(
                            textSearch: searchController.text,
                            list: bankTypes,
                          ),
                        );
                      } else {
                        _searchClearProvider.updateClearSearch(false);
                      }
                    },
                    inputType: TextInputType.text,
                    isObscureText: false,
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _searchClearProvider,
                builder: (_, provider, child) {
                  return Visibility(
                    visible: provider == true,
                    child: InkWell(
                      onTap: () {
                        searchController.clear();
                        _searchClearProvider.updateClearSearch(false);
                        bankTypeBloc.add(
                          BankTypeEventSearch(
                            textSearch: searchController.text,
                            list: bankTypes,
                          ),
                        );
                      },
                      child: Icon(
                        Icons.close_rounded,
                        size: 15,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBankTypeItem(
      BuildContext context, BankTypeDTO dto, double width) {
    return InkWell(
      onTap: () {
        Provider.of<AddBankProvider>(context, listen: false)
            .updateSelectBankType(dto);
        if (dto.bankCode == 'MB') {
          Provider.of<AddBankProvider>(context, listen: false)
              .updateRegisterAuthentication(true);
        } else {
          Provider.of<AddBankProvider>(context, listen: false)
              .updateRegisterAuthentication(false);
        }
        callBack!(2);
      },
      child: BoxLayout(
        width: width,
        borderRadius: 0,
        bgColor: DefaultTheme.TRANSPARENT,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: DefaultTheme.WHITE,
                image: DecorationImage(
                    image: ImageUtils.instance.getImageNetWork(dto.imageId)),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Expanded(
              child: Text(
                '${dto.bankCode} - ${dto.bankName}',
                style: const TextStyle(
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const IconNavigateNextWidget(),
          ],
        ),
      ),
    );
  }
}
