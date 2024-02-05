import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/bank_detail/blocs/share_bdsd_bloc.dart';
import 'package:vierqr/features/bank_detail/provider/add_user_bdsd_provider.dart';
import 'package:vierqr/features/bank_detail/states/share_bdsd_state.dart';
import 'package:vierqr/models/member_search_dto.dart';

import '../events/share_bdsd_event.dart';

class BottomSheetAddUserBDSD extends StatefulWidget {
  final Function(MemberSearchDto) onSelect;
  final String terminalId;

  const BottomSheetAddUserBDSD({
    Key? key,
    required this.terminalId,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<BottomSheetAddUserBDSD> createState() => _BottomSheetAddUserBDSDState();
}

class _BottomSheetAddUserBDSDState extends State<BottomSheetAddUserBDSD> {
  late ShareBDSDBloc bloc;
  List<MemberSearchDto> listMember = [];
  bool isSearched = false;
  String _valueSearch = '';
  Timer? _debounce;

  @override
  void initState() {
    bloc = ShareBDSDBloc(context);
    super.initState();
  }

  _onSearch(
      {required String terminalId, required int type, required String value}) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      bloc.add(
          SearchMemberEvent(terminalId: terminalId, type: type, value: value));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShareBDSDBloc>(
      create: (BuildContext context) => bloc,
      child: ChangeNotifierProvider<AddUserBDSDProvider>(
        create: (context) => AddUserBDSDProvider(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  const Spacer(),
                  const SizedBox(
                    width: 32,
                  ),
                  Text(
                    'Chia sẻ BĐSD',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.clear,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 28,
            ),
            Consumer<AddUserBDSDProvider>(builder: (context, provider, child) {
              return Row(
                children: [
                  Text(
                    'Lọc theo',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  _buildTypeSearch(
                      title: 'Số điện thoại',
                      selected: provider.typeSearch == 0,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        provider.changeTypeSearch(0);
                      }),
                  const SizedBox(
                    width: 8,
                  ),
                  _buildTypeSearch(
                      title: 'Họ tên',
                      selected: provider.typeSearch == 1,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        provider.changeTypeSearch(1);
                      }),
                ],
              );
            }),
            const SizedBox(height: 20),
            Consumer<AddUserBDSDProvider>(builder: (context, provider, child) {
              return Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 41,
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
                        hintText: 'Tìm kiếm người dùng',
                        inputType: provider.typeSearch == 0
                            ? TextInputType.number
                            : TextInputType.text,
                        prefixIcon: const Icon(Icons.search),
                        keyboardAction: TextInputAction.search,
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            int type = provider.typeSearch;
                            String terminalId = widget.terminalId;
                            String valueSearch = value.toString();
                            _onSearch(
                                terminalId: terminalId,
                                type: type,
                                value: valueSearch);
                          }
                        },
                        onChange: (value) {
                          _valueSearch = value;
                          if (provider.typeSearch == 0) {
                            if (value.length >= 8) {
                              int type = provider.typeSearch;
                              String terminalId = widget.terminalId;
                              _onSearch(
                                terminalId: terminalId,
                                type: type,
                                value: _valueSearch,
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ButtonWidget(
                      width: 100,
                      height: 41,
                      text: 'Tìm kiếm',
                      textColor: AppColor.WHITE,
                      fontSize: 12,
                      borderRadius: 5,
                      bgColor: AppColor.BLUE_TEXT,
                      function: () {
                        if (_valueSearch.isNotEmpty) {
                          FocusScope.of(context).unfocus();
                          int type = provider.typeSearch;
                          String terminalId = widget.terminalId;
                          _onSearch(
                              terminalId: terminalId,
                              type: type,
                              value: _valueSearch);
                        }
                      })
                ],
              );
            }),
            const SizedBox(
              height: 28,
            ),
            Expanded(
                child: BlocConsumer<ShareBDSDBloc, ShareBDSDState>(
              listener: (context, state) {
                if (state.request == ShareBDSDType.SHARE_BDSD) {
                  // if (state.status == BlocStatus.LOADING_SHARE) {
                  //   DialogWidget.instance.openLoadingDialog();
                  // }
                  // if (state.status == BlocStatus.UNLOADING) {
                  //   Navigator.pop(context);
                  //   Fluttertoast.showToast(
                  //     msg: 'Chia sẻ BĐSD thành công',
                  //     toastLength: Toast.LENGTH_SHORT,
                  //     gravity: ToastGravity.CENTER,
                  //     backgroundColor: Theme.of(context).cardColor,
                  //     textColor: Theme.of(context).hintColor,
                  //     fontSize: 15,
                  //   );
                  //   Navigator.pop(context);
                  // }
                  if (state.request == ShareBDSDType.ERROR) {
                    DialogWidget.instance.openMsgDialog(
                        title: 'Đã có lỗi xảy ra', msg: state.msg ?? '');
                  }
                }
                if (state.request == ShareBDSDType.SEARCH_MEMBER) {
                  listMember = state.listMemberSearch;
                  isSearched = true;
                }
                //
                // if (state.type == ContactType.SEARCH_USER) {
                //   Provider.of<ContactProvider>(context, listen: false)
                //       .updateList(state.listContactDTO);
                // }
              },
              builder: (context, state) {
                if (state.request == ShareBDSDType.SEARCH_MEMBER &&
                    state.status == BlocStatus.LOADING) {
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

                if (state.listMemberSearch.isNotEmpty) {
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
                        child: ListView(
                          children: state.listMemberSearch.map((e) {
                            return _buildItemUser(e, state);
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                }
                if (isSearched) {
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
                } else {
                  return SizedBox.shrink();
                }
              },
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSearch(
      {String title = '', bool selected = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        padding: EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: selected
                ? AppColor.BLUE_TEXT.withOpacity(0.3)
                : AppColor.GREY_BUTTON),
        child: Text(
          title,
          style: TextStyle(
              color: selected ? AppColor.BLUE_TEXT : AppColor.BLACK,
              fontSize: 12,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal),
        ),
      ),
    );
  }

  Widget _buildItemUser(MemberSearchDto dto, ShareBDSDState state) {
    if (state.status == BlocStatus.UNLOADING && state.userIdSelect == dto.id) {
      dto.existed = 1;
    }
    return GestureDetector(
      onTap: () async {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: AppColor.BLACK_BUTTON.withOpacity(0.5), width: 0.5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dto.imgId.isNotEmpty
                ? Container(
                    width: 54,
                    height: 54,
                    margin: EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                          image: ImageUtils.instance.getImageNetWork(dto.imgId),
                          fit: BoxFit.cover),
                    ),
                  )
                : Container(
                    width: 54,
                    height: 54,
                    margin: EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                          image: AssetImage('assets/images/ic-avatar.png')),
                    ),
                  ),
            const SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 96,
                            child: Text(
                              'Họ tên:',
                              style: TextStyle(color: AppColor.GREY_TEXT),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              dto.fullName,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 96,
                            child: Text(
                              'Số điện thoại:',
                              style: TextStyle(color: AppColor.GREY_TEXT),
                            ),
                          ),
                          Expanded(
                            child: Text(dto.phoneNo ?? '',
                                textAlign: TextAlign.start,
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                if (state.status == BlocStatus.LOADING_SHARE &&
                    state.userIdSelect == dto.id)
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: UnconstrainedBox(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            color: AppColor.BLUE_TEXT),
                      ),
                    ),
                  ))
                // else if (state.status == BlocStatus.UNLOADING &&
                //     state.userIdSelect == dto.id)
                //   SizedBox(
                //     width: 80,
                //     child: Padding(
                //       padding: const EdgeInsets.only(top: 10, left: 8),
                //       child: Row(
                //         children: [
                //           Text(
                //             'Đã thêm',
                //             textAlign: TextAlign.end,
                //             style: TextStyle(color: AppColor.BLUE_TEXT),
                //           ),
                //           Icon(
                //             Icons.check,
                //             color: AppColor.BLUE_TEXT,
                //             size: 18,
                //           )
                //         ],
                //       ),
                //     ),
                //   )
                else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: dto.existed == 0
                          ? ButtonWidget(
                              height: 32,
                              width: 80,
                              text: 'Chia sẻ',
                              textColor: AppColor.WHITE,
                              bgColor: AppColor.BLUE_TEXT,
                              function: () {
                                widget.onSelect(dto);
                                Navigator.pop(context);
                                // Map<String, dynamic> param = {};
                                // param['userId'] = dto.id;
                                // param['bankId'] = widget.bankId;
                                // bloc.add(ShareUserBDSDEvent(param));
                              },
                              fontSize: 12,
                              borderRadius: 5,
                            )
                          : SizedBox(
                              width: 80,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      'Đã thêm',
                                      textAlign: TextAlign.end,
                                      style:
                                          TextStyle(color: AppColor.BLUE_TEXT),
                                    ),
                                    Icon(
                                      Icons.check,
                                      color: AppColor.BLUE_TEXT,
                                      size: 18,
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
