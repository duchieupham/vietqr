import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/contact/blocs/contact_bloc.dart';
import 'package:vierqr/features/contact/blocs/contact_provider.dart';
import 'package:vierqr/features/contact/events/contact_event.dart';
import 'package:vierqr/features/contact/states/contact_state.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/contact_dto.dart';

import 'save_contact_screen.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactBloc>(
      create: (context) => ContactBloc(context),
      child: ChangeNotifierProvider<ContactProvider>(
        create: (context) => ContactProvider(),
        child: _ContactState(),
      ),
    );
  }
}

class _ContactState extends StatefulWidget {
  @override
  State<_ContactState> createState() => _ContactStateState();
}

class _ContactStateState extends State<_ContactState>
    with AutomaticKeepAliveClientMixin {
  late ContactBloc _bloc;
  late PageController _pageController;

  final List<Widget> _listScreens = [];

  final searchController = TextEditingController();

  List<DataModel> listTab = [
    DataModel(
      title: 'Đã lưu',
      index: 0,
    ),
    DataModel(
      title: 'Gợi ý',
      index: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _pageController = PageController(
        initialPage: Provider.of<ContactProvider>(context, listen: false).tab,
        keepPage: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(ContactEventGetList());
      _bloc.add(ContactEventGetListPending());
    });
  }

  Future<void> _onRefresh() async {
    _bloc.add(ContactEventGetList());
  }

  Future<void> _onRefreshTabSecond() async {
    _bloc.add(ContactEventGetListPending());
  }

  void _animatedToPage(int index) {
    try {
      _pageController.jumpToPage(index);
    } catch (e) {
      _pageController = PageController(
        initialPage: Provider.of<ContactProvider>(context, listen: false).tab,
        keepPage: true,
      );
      _animatedToPage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: MAppBar(
        title: 'Danh bạ',
        actions: [
          GestureDetector(
            onTap: () async {
              final data =
                  await Navigator.pushNamed(context, Routes.SCAN_QR_VIEW);
              if (data is Map<String, dynamic>) {
                if (!mounted) return;
                await QRScannerUtils.instance.onScanNavi(data, context,
                    onTapSave: (data) async {
                  _bloc.add(SaveContactEvent(dto: data));
                }, onTapAdd: (data) {
                  context.read<DashBoardBloc>().add(DashBoardCheckExistedEvent(
                      bankAccount: data['bankAccount'],
                      bankTypeId: data['bankTypeId']));
                }, onCallBack: () {
                  _bloc.add(ContactEventGetList());
                });
              }
              _bloc.add(ContactEventGetList());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/ic-tb-qr.png',
              ),
            ),
          )
        ],
      ),
      body: BlocConsumer<ContactBloc, ContactState>(
        listener: (context, state) async {
          if (state.status == BlocStatus.LOADING) {
            DialogWidget.instance.openLoadingDialog();
          }

          if (state.status == BlocStatus.UNLOADING) {
            Navigator.pop(context);
          }

          if (state.type == ContactType.GET_LIST) {
            if (state.listContactDTO.isNotEmpty) {
              Provider.of<ContactProvider>(context, listen: false)
                  .updateList(state.listContactDTO);
            }
          }

          if (state.type == ContactType.SAVE) {
            Fluttertoast.showToast(
              msg: 'Lưu thành công',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
            );
            _bloc.add(ContactEventGetList());
          }

          if (state.type == ContactType.SUGGEST) {
            Provider.of<ContactProvider>(context, listen: false).updateTab(0);
            _bloc.add(ContactEventGetList());
            _bloc.add(ContactEventGetListPending());
            _animatedToPage(0);
          }

          if (state.type == ContactType.SCAN) {
            _bloc.add(UpdateEventContact());
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SaveContactScreen(
                  code: state.qrCode,
                  typeQR: state.typeQR,
                ),
                // settings: RouteSettings(name: ContactEditView.routeName),
              ),
            );
            _bloc.add(ContactEventGetList());
          }

          if (state.type == ContactType.ERROR) {
            await DialogWidget.instance.openMsgDialog(
                title: 'Không thể lưu danh bạ', msg: state.msg ?? '');
          }
        },
        builder: (context, state) {
          return Consumer<ContactProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: List.generate(listTab.length, (index) {
                        DataModel model = listTab.elementAt(index);
                        return _buildTab(
                            onTap: () {
                              _animatedToPage(index);
                            },
                            text: model.title,
                            isSuggest: index == 1 &&
                                state.listContactDTOSuggest.isNotEmpty,
                            isSelect: provider.tab == model.index,
                            textSuggest:
                                '${state.listContactDTOSuggest.length}');
                      }).toList(),
                    ),
                    Expanded(
                      child: PageView(
                        key: const PageStorageKey('Page_view_contact'),
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (index) async {
                          provider.updateTab(index);
                        },
                        children: [
                          _buildTapFirst(
                            listContactDTO: provider.listSearch,
                            onChange: provider.onSearch,
                          ),
                          _buildTapSecond(list: state.listContactDTOSuggest),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTapSecond({required List<ContactDTO> list}) {
    if (list.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: _onRefreshTabSecond,
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 16),
            child: Column(
              children: List.generate(
                list.length,
                (index) {
                  ContactDTO dto = list[index];
                  return _buildItemSuggest(dto: dto);
                },
              ).toList(),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildTapFirst({
    required List<ContactDTO> listContactDTO,
    ValueChanged<String>? onChange,
  }) {
    return Column(
      children: [
        const SizedBox(height: 10),
        TextFieldCustom(
          isObscureText: false,
          maxLines: 1,
          fillColor: AppColor.WHITE,
          controller: searchController,
          hintText: 'Tìm kiếm danh bạ',
          inputType: TextInputType.text,
          prefixIcon: const Icon(Icons.search),
          keyboardAction: TextInputAction.next,
          onChange: onChange,
        ),
        const SizedBox(height: 30),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.separated(
              itemCount: listContactDTO.length,
              separatorBuilder: (context, index) {
                if (index == listContactDTO.length - 1) {
                  return const SizedBox.shrink();
                }
                String firstLetterA = (listContactDTO[index].nickname)[0];
                String firstLetterB = (listContactDTO[index + 1].nickname)[0];
                if (firstLetterA != firstLetterB) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      firstLetterB,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text((listContactDTO[index].nickname)[0],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      _buildItemSave(dto: listContactDTO[index]),
                    ],
                  );
                }
                return _buildItemSave(dto: listContactDTO[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemSave({required ContactDTO? dto}) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(context, Routes.PHONE_BOOK_DETAIL,
            arguments: dto);
        _bloc.add(ContactEventGetList());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.WHITE,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: AppColor.GREY_LIGHT.withOpacity(0.3)),
                image: dto?.type == 2
                    ? DecorationImage(
                        image: ImageUtils.instance
                            .getImageNetWork(dto?.imgId ?? ''),
                        fit: BoxFit.contain)
                    : const DecorationImage(
                        image: AssetImage('assets/images/ic-viet-qr-small.png'),
                        fit: BoxFit.contain),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dto?.nickname ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.BLACK,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    dto?.description ?? '',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColor.BLUE_TEXT,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItemSuggest({required ContactDTO? dto}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.WHITE,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border:
                      Border.all(color: AppColor.GREY_LIGHT.withOpacity(0.3)),
                  image: dto?.type == 2
                      ? DecorationImage(
                          image: ImageUtils.instance
                              .getImageNetWork(dto?.imgId ?? ''),
                          fit: BoxFit.contain)
                      : const DecorationImage(
                          image:
                              AssetImage('assets/images/ic-viet-qr-small.png'),
                          fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dto?.nickname ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.BLACK,
                        height: 1.4,
                      ),
                    ),
                    Text(
                      dto?.description ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColor.BLUE_TEXT,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MButtonWidget(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (!mounted) return;
                  Map<String, dynamic> data = {
                    "id": dto?.id ?? '',
                    "status": 0
                  };
                  _bloc.add(UpdateStatusContactEvent(data));
                },
                height: 30,
                title: 'Lưu',
                width: 90,
                margin: EdgeInsets.zero,
                colorEnableText: AppColor.WHITE,
                fontSize: 12,
                isEnable: true,
              ),
              const SizedBox(width: 12),
              MButtonWidget(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (!mounted) return;
                    Map<String, dynamic> data = {
                      "id": dto?.id ?? '',
                      "status": 2,
                    };
                    _bloc.add(UpdateStatusContactEvent(data));
                  },
                  height: 30,
                  width: 90,
                  title: 'Bỏ qua',
                  margin: EdgeInsets.zero,
                  colorEnableText: AppColor.BLUE_TEXT,
                  fontSize: 12,
                  colorDisableBgr: AppColor.GREY_BUTTON),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTab({
    required String text,
    GestureTapCallback? onTap,
    bool isSuggest = false,
    bool isSelect = false,
    required String textSuggest,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(bottom: 4),
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelect ? AppColor.BLUE_TEXT : AppColor.TRANSPARENT,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            if (isSuggest)
              Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(left: 4),
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColor.BLUE_TEXT.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(100)),
                child: Text(
                  textSuggest,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColor.BLUE_TEXT),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class DataModel {
  final String title;
  final int index;

  DataModel({required this.title, required this.index});
}
