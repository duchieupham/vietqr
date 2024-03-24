import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/search_user/blocs/search_user_bloc.dart';
import 'package:vierqr/features/search_user/events/search_user_event.dart';
import 'package:vierqr/models/detail_group_dto.dart';

import 'states/search_user_state.dart';
import 'views/dialog_filter_view.dart';
import 'views/item_member_view.dart';

class SearchUserScreen extends StatefulWidget {
  final Function(AccountMemberDTO) onSelected;
  final List<AccountMemberDTO> listMember;

  const SearchUserScreen(
      {super.key, required this.onSelected, required this.listMember});

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  late SearchUserBloc bloc;
  final _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  int type = 0;

  @override
  void initState() {
    super.initState();
    bloc = SearchUserBloc(context, widget.listMember);
  }

  void _onSearch(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      bloc.add(SearchMemberEvent(value: value, type: type));
    });
  }

  void _onSubmitted(String value) {}

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: GestureDetector(
        onTap: _onHideKeyboard,
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              _buildAppbar(),
              const SizedBox(height: 16),
              _buildSearch(),
              const SizedBox(height: 30),
              Expanded(
                child: BlocConsumer<SearchUserBloc, SearchUserState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state.request == SearchUserType.SEARCH_MEMBER) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 120),
                          child: SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(
                                  color: AppColor.BLUE_TEXT)),
                        ),
                      );
                    }

                    if (state.members.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kết quả tìm kiếm',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.members.length,
                              itemBuilder: (BuildContext context, int index) {
                                AccountMemberDTO e = state.members[index];
                                return ItemMemberView(
                                  dto: e,
                                  callBack: () {
                                    widget.onSelected(e);
                                    bloc.add(InsertMemberToList(e));
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }

                    if (state.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/ic-member-empty.png',
                            height: 100,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text('Không tìm thấy người dùng'),
                          const SizedBox(
                            height: 48,
                          ),
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: _onFilter,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColor.BLUE_TEXT.withOpacity(0.3)),
              child: Image.asset(
                'assets/images/ic-filter-blue.png',
                height: 41,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 41,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: AppColor.BLACK_BUTTON.withOpacity(0.5),
                      width: 0.5)),
              child: TextFieldCustom(
                  isObscureText: false,
                  maxLines: 1,
                  autoFocus: true,
                  fillColor: AppColor.WHITE,
                  hintText: type == 0
                      ? 'Tìm kiếm theo số điện thoại'
                      : 'Tìm kiếm theo tên',
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  inputType:
                      type == 0 ? TextInputType.phone : TextInputType.text,
                  maxLength: type == 0 ? 10 : 200,
                  keyboardAction: TextInputAction.search,
                  controller: _searchController,
                  focusNode: _focusNode,
                  onSubmitted: _onSubmitted,
                  onChange: _onSearch),
            ),
          ),
          GestureDetector(
            onTap: () => _onSearch(_searchController.text),
            child: Container(
              height: 41,
              width: 41,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColor.BLUE_TEXT),
              child: const Icon(Icons.search, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  _buildAppbar() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Chia sẻ thông báo giao dịch cho nhân viên cửa hàng',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 24),
          GestureDetector(
              onTap: () {
                _onHideKeyboard();
                Navigator.pop(context);
              },
              child: const Icon(Icons.close, size: 24)),
        ],
      ),
    );
  }

  void _onFilter() async {
    _onHideKeyboard();

    final data = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return DialogFilterView(type: type);
      },
    );

    if (type != data) {
      _searchController.text = '';
    }

    setState(() {
      type = data;
    });

    if (_searchController.text.isEmpty) {
      bloc.add(UpdateMembersEvent());
    }
  }

  void _onHideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
