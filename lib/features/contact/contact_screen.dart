import 'dart:async';

import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/contact/blocs/contact_bloc.dart';
import 'package:vierqr/features/contact/blocs/contact_provider.dart';
import 'package:vierqr/features/contact/events/contact_event.dart';
import 'package:vierqr/features/contact/states/contact_state.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/contact_dto.dart';

import 'save_contact_screen.dart';
import 'views/contact_detail.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactBloc>(
      create: (context) => ContactBloc(context),
      child: ChangeNotifierProvider<ContactProvider>(
        create: (context) => ContactProvider()..updateCategory(isFirst: true),
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

  final searchController = TextEditingController();

  final scrollController = ScrollController();
  final controller = ScrollController();

  StreamSubscription? _subscription;

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

    _subscription = eventBus.on<ReloadContact>().listen((_) {
      _onRefresh();
    });

    controller.addListener(_loadMore);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;

    super.dispose();
  }

  _loadMore() async {
    int type =
        Provider.of<ContactProvider>(context, listen: false).category!.type;
    int offset = Provider.of<ContactProvider>(context, listen: false).offset;

    final maxScroll = controller.position.maxScrollExtent;
    if (controller.offset >= maxScroll && !controller.position.outOfRange) {
      _bloc.add(ContactEventGetList(type: type, offset: offset));
    }
  }

  Future<void> _onRefresh() async {
    Provider.of<ContactProvider>(context, listen: false).updateOffset(0);
    int type =
        Provider.of<ContactProvider>(context, listen: false).category!.type;
    _bloc.add(ContactEventGetList(type: type));
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
      backgroundColor: Colors.transparent,
      body: BlocConsumer<ContactBloc, ContactState>(
        listener: (context, state) async {
          if (state.status == BlocStatus.LOADING) {
            DialogWidget.instance.openLoadingDialog();
          }

          if (state.status == BlocStatus.UNLOADING) {
            Navigator.pop(context);
          }

          if (state.type == ContactType.GET_LIST) {
            Provider.of<ContactProvider>(context, listen: false)
                .updateList(state.listContactDTO);
            Provider.of<ContactProvider>(context, listen: false).updateOffset(
                Provider.of<ContactProvider>(context, listen: false).offset++);
          }

          if (state.type == ContactType.REMOVE) {
            _bloc.add(ContactEventGetList());
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
              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Ví QR',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Nơi lưu trữ mã QR của bạn',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.GREY_TEXT,
                                  height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: List.generate(
                              provider.listCategories.length, (index) {
                            final model = provider.listCategories[index];
                            return GestureDetector(
                              onTap: () {
                                provider.updateCategory(value: model);
                                _bloc.add(ContactEventGetList(
                                    type: provider.category?.type));
                                if (scrollController.hasClients)
                                  scrollController.jumpTo(0.0);
                              },
                              child: _buildCategory(
                                  title: model.title,
                                  url: model.url,
                                  isSelect: provider.category == model,
                                  index: index),
                            );
                          }).toList(),
                        ),
                      ),
                      if (state.isLoading)
                        Expanded(
                          child: const Center(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                color: AppColor.BLUE_TEXT,
                              ),
                            ),
                          ),
                        )
                      else ...[
                        if (provider.category != null)
                          if (provider.category!.type == 0)
                            Expanded(
                              child: _buildTapSecond(
                                list: state.listContactDTOSuggest,
                              ),
                            )
                          else
                            Expanded(
                              child: _buildTapFirst(
                                listContactDTO: provider.listSearch,
                                colors: state.colors,
                                onChange: provider.onSearch,
                                isEdit: provider.category!.type != 8,
                              ),
                            ),
                      ]
                    ],
                  ),
                  Positioned(
                    bottom: 30,
                    right: 20,
                    child: GestureDetector(
                      onTap: () async {
                        final data = await Navigator.pushNamed(
                            context, Routes.SCAN_QR_VIEW);
                        if (data is Map<String, dynamic>) {
                          if (!mounted) return;
                          await QRScannerUtils.instance
                              .onScanNavi(data, context, onCallBack: () {
                            _bloc.add(
                              ContactEventGetList(
                                type: provider.category?.type,
                              ),
                            );
                          });
                        }
                        _bloc.add(
                            ContactEventGetList(type: provider.category?.type));
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: AppColor.BLUE_TEXT,
                            borderRadius: BorderRadius.circular(100)),
                        child: Image.asset(
                            'assets/images/ic-add-new-qr-wallet.png'),
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

  Widget _buildCategory(
      {required String title,
      required String url,
      bool isSelect = false,
      int index = -1}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelect ? AppColor.BLUE_TEXT : AppColor.WHITE,
      ),
      child: Row(
        children: [
          Padding(
            padding: index == 0
                ? const EdgeInsets.symmetric(vertical: 10.5, horizontal: 8.0)
                : EdgeInsets.zero,
            child: Image.asset(
              url,
              width: index == 0 ? 14 : 35,
              color: isSelect ? AppColor.WHITE : AppColor.BLUE_TEXT,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isSelect ? AppColor.WHITE : AppColor.BLUE_TEXT,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildTapFirst({
    required List<ContactDTO> listContactDTO,
    required List<Color> colors,
    ValueChanged<String>? onChange,
    bool isEdit = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
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
          const SizedBox(height: 20),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: listContactDTO.length,
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
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
                        _buildItemSave(
                          dto: listContactDTO[index],
                          color: colors[index],
                          isEdit: isEdit,
                        ),
                      ],
                    );
                  }
                  return _buildItemSave(
                    dto: listContactDTO[index],
                    color: colors[index],
                    isEdit: isEdit,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemSave({
    required ContactDTO dto,
    required Color? color,
    bool isEdit = true,
  }) {
    return GestureDetector(
      onTap: () async {
        final data = await Utils.navigatePage(
            context, ContactDetailScreen(dto: dto, isEdit: isEdit));
        if (data) {
          _bloc.add(ContactEventGetList());
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                image: getImage(dto.type, dto.imgId),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dto.nickname,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.BLACK,
                      height: 1.4,
                    ),
                  ),
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: dto.description,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: color,
                            height: 1.4,
                          ),
                        ),
                        WidgetSpan(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 2.5, left: 8),
                            child: Image.asset(
                              dto.relation == 1
                                  ? 'assets/images/gl-white.png'
                                  : 'assets/images/personal-relation.png',
                              color: AppColor.BLACK.withOpacity(0.7),
                              width: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DecorationImage getImage(int type, String imageId) {
    if (type == 2 || type == 3) {
      if (imageId.isNotEmpty) {
        return DecorationImage(
            image: ImageUtils.instance.getImageNetWork(imageId),
            fit: type == 2 ? BoxFit.contain : BoxFit.cover);
      }
    }
    return const DecorationImage(
        image: AssetImage('assets/images/ic-tb-qr.png'),
        fit: BoxFit.contain);
  }

  Widget _buildTapSecond({required List<ContactDTO> list}) {
    if (list.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: _onRefreshTabSecond,
        child: SingleChildScrollView(
          controller: controller,
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
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
