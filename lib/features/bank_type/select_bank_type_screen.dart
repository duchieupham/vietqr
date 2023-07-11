import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/icon_navigate_next_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/bank_type/blocs/bank_type_bloc.dart';
import 'package:vierqr/features/bank_type/events/bank_type_event.dart';
import 'package:vierqr/features/bank_type/states/bank_type_state.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/services/providers/add_bank_provider.dart';
import 'package:vierqr/services/providers/search_clear_provider.dart';

class SelectBankTypeScreen extends StatelessWidget {
  const SelectBankTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BankTypeBloc>(
      create: (BuildContext context) => BankTypeBloc(context),
      child: const _SelectBankTypeScreenState(),
    );
  }
}

class _SelectBankTypeScreenState extends StatefulWidget {
  const _SelectBankTypeScreenState({super.key});

  @override
  State<_SelectBankTypeScreenState> createState() =>
      _SelectBankTypeScreenStateState();
}

class _SelectBankTypeScreenStateState
    extends State<_SelectBankTypeScreenState> {
  final TextEditingController searchController = TextEditingController();

  final _searchFocus = FocusNode();

  late BankTypeBloc bankTypeBloc;

  final _formKey = GlobalKey<FormState>();

  final _searchClearProvider = SearchClearProvider(false);

  @override
  void initState() {
    super.initState();
    bankTypeBloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bankTypeBloc.add(const BankTypeEventGetList());
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return BlocConsumer<BankTypeBloc, BankTypeState>(
      listener: (context, state) {
        if (state.status == BlocStatus.SUCCESS) {
          Future.delayed(const Duration(milliseconds: 100), () {
            _searchFocus.requestFocus();
          });
        }
      },
      builder: (context, state) {
        if (state.status == BlocStatus.LOADING) {
          return SizedBox(
            width: width,
            height: 200,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColor.GREEN,
              ),
            ),
          );
        }
        return Scaffold(
          appBar: MAppBar(title: ''),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Visibility(
                    visible: state.list.isNotEmpty,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.list.length,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (context, index) {
                        return _buildBankTypeItem(
                            context, state.list[index], width);
                      },
                      separatorBuilder: (context, index) {
                        return DividerWidget(width: width);
                      },
                    ),
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
                            autoFocus: false,
                            focusNode: _searchFocus,
                            onChange: (value) {
                              if (searchController.text.isNotEmpty) {
                                _searchClearProvider.updateClearSearch(true);
                                bankTypeBloc.add(
                                  BankTypeEventSearch(
                                    textSearch: searchController.text,
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildBankTypeItem(
      BuildContext context, BankTypeDTO dto, double width) {
    return InkWell(
      onTap: () {
        // Provider.of<AddBankProvider>(context, listen: false)
        //     .updateSelectBankType(dto);
        // if (dto.bankCode == 'MB') {
        //   Provider.of<AddBankProvider>(context, listen: false)
        //       .updateRegisterAuthentication(true);
        // } else {
        //   Provider.of<AddBankProvider>(context, listen: false)
        //       .updateRegisterAuthentication(false);
        // }
        // widget.callBack!(2);
      },
      child: BoxLayout(
        width: width,
        borderRadius: 0,
        bgColor: AppColor.TRANSPARENT,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColor.WHITE,
                image: DecorationImage(
                    image: ImageUtils.instance.getImageNetWork(dto.imageId)),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Expanded(
              child: Text(
                '${dto.bankShortName} - ${dto.bankName}',
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
