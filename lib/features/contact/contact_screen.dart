import 'dart:async';
import 'dart:isolate';

import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/check_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/contact/blocs/contact_bloc.dart';
import 'package:vierqr/features/contact/blocs/contact_provider.dart';
import 'package:vierqr/features/contact/events/contact_event.dart';
import 'package:vierqr/features/contact/states/contact_state.dart';
import 'package:vierqr/features/scan_qr/scan_qr_view_screen.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/navigator/app_navigator.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import 'repostiroties/contact_repository.dart';
import 'save_contact_screen.dart';
import 'views/contact_detail.dart';
import 'widgets/introduce_widget.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactBloc>(
      create: (context) => ContactBloc(context),
      child: ChangeNotifierProvider<ContactProvider>(
        create: (context) => ContactProvider()..initData(),
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

  StreamSubscription? _subscription;
  StreamSubscription? _syncSub;
  StreamSubscription? _syncGetSub;

  String get userId => SharePrefUtils.getProfile().userId;

  Timer? _debounce;

  static const int maxLength = 50;

  @override
  void initState() {
    super.initState();
    initData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int type =
          Provider.of<ContactProvider>(context, listen: false).category!.type;
      _bloc.add(ContactEventGetList(isLoading: true, type: type));
      _bloc.add(ContactEventGetListPending());

      if (type == CategoryType.vcard.value) {
        _onCheckSyncContact();
      }
    });

    _subscription = eventBus.on<ReloadContact>().listen((_) {
      _onRefresh();
    });
    _syncSub = eventBus.on<CheckSyncContact>().listen((_) {
      int type =
          Provider.of<ContactProvider>(context, listen: false).category!.type;
      if (type == CategoryType.vcard.value) {
        _onCheckSyncContact();
      }
    });
    _syncGetSub = eventBus.on<SentDataToContact>().listen((data) async {
      _onSyncCard(data.datas);
    });

    scrollController.addListener(_loadMore);
  }

  Future<ResponseMessageDTO> _insertContacts(List<VCardModel> list) async {
    final String token = await SharePrefUtils.getTokenInfo();
    final String tokenFree = SharePrefUtils.getTokenFree();
    ReceivePort port = ReceivePort();
    await Isolate.spawn(_handleInsert, [port.sendPort, list, token, tokenFree]);
    ResponseMessageDTO data = await port.first;
    port.close();
    return data;
  }

  static ContactRepository repository = ContactRepository();

  static void _handleInsert(List<dynamic> params) async {
    SendPort sendPort = params[0];
    List<VCardModel> data = params[1];
    final String token = params[2];
    final String tokenFree = params[3];

    final result =
        await repository.insertVCard(data, token: token, tokenFree: tokenFree);
    sendPort.send(result);
  }

  initData() async {
    _bloc = BlocProvider.of(context);
    _pageController = PageController(
        initialPage: Provider.of<ContactProvider>(context, listen: false).tab,
        keepPage: true);
  }

  void _onCheckSyncContact() async {
    if (!Provider.of<ContactProvider>(context, listen: false).isIntro) {
      DialogWidget.instance.openDialogIntroduce(
        ctx: context,
        child: ContactIntroWidget(
          onSync: () async {
            Navigator.pop(context);
            Provider.of<ContactProvider>(context, listen: false)
                .updateIntro(true);
            final data = await _fetchContacts();

            eventBus.fire(SyncContactEvent(data));
          },
          onSelected: (value) async {
            Navigator.pop(context);
            if (value) {
              Provider.of<ContactProvider>(context, listen: false)
                  .updateIntro(true);
            }
          },
        ),
      );
    }
  }

  void _onUpdateContact() async {
    Provider.of<AuthenProvider>(context, listen: false).updateSync(true);
    final data = await _fetchContacts();

    eventBus.fire(SyncContactEvent(data));
  }

  Future<List<ContactDTO>> _fetchContacts() async {
    if (await FlutterContacts.requestPermission(readonly: true)) {
      ReceivePort port = ReceivePort();

      final contacts = await FlutterContacts.getContacts();

      final isolate = await Isolate.spawn(_handle, [port.sendPort, contacts]);
      List<ContactDTO> data = await port.first;

      isolate.kill(priority: Isolate.immediate);
      return data;
    }
    return [];
  }

  static void _handle(List<dynamic> params) async {
    SendPort sendPort = params[0];
    List<Contact> data = params[1];

    List<ContactDTO> list = await Future.wait(
      data.map<Future<ContactDTO>>((e) async {
        return ContactDTO(
            id: e.id,
            nickname: e.displayName,
            status: 0,
            type: CategoryType.vcard.value,
            imgId: '',
            description: '',
            phoneNo: e.phones.isNotEmpty ? e.phones.first.number : '',
            carrierTypeId: '',
            relation: 0);
      }).toList(),
    );

    sendPort.send(list);
  }

  _loadMore() async {
    int type =
        Provider.of<ContactProvider>(context, listen: false).category!.type;
    int offset = Provider.of<ContactProvider>(context, listen: false).offset;

    final maxScroll = scrollController.position.maxScrollExtent;
    if (scrollController.offset >= maxScroll &&
        !scrollController.position.outOfRange) {
      _bloc.add(GetListContactLoadMore(
          type: type, offset: offset, isLoading: false, isLoadMore: true));
    }
  }

  Future<void> _onRefresh({bool isLoading = true}) async {
    searchController.clear();
    Provider.of<ContactProvider>(context, listen: false).updateOffset(0);

    int type =
        Provider.of<ContactProvider>(context, listen: false).category!.type;
    _bloc.add(ContactEventGetList(type: type, isLoading: isLoading));
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
  void dispose() {
    _subscription?.cancel();
    _subscription = null;

    _syncSub?.cancel();
    _syncSub = null;

    _syncGetSub?.cancel();
    _syncGetSub = null;

    _debounce?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<ContactBloc, ContactState>(
      listener: (context, state) async {
        if (state.status == BlocStatus.LOADING) {
          DialogWidget.instance.openLoadingDialog();
        }

        if (state.status == BlocStatus.UNLOADING) {
          Navigator.pop(context);
        }

        if (state.type == ContactType.GET_LIST) {
          int offset =
              Provider.of<ContactProvider>(context, listen: false).offset;

          Provider.of<ContactProvider>(context, listen: false)
              .updateListAll(state.listCompareContact, state.listContactDTO);

          Provider.of<ContactProvider>(context, listen: false)
              .updateOffset(offset + 1);
        }

        if (state.type == ContactType.INSERT_VCARD) {
          int type = Provider.of<ContactProvider>(context, listen: false)
              .category!
              .type;
          _bloc.add(ContactEventGetList(type: type, isLoading: false));
        }

        if (state.type == ContactType.REMOVE) {
          int type = Provider.of<ContactProvider>(context, listen: false)
              .category!
              .type;
          _bloc.add(ContactEventGetList(type: type));
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
                    Consumer<AuthenProvider>(
                      builder: (context, dashProvider, child) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                          child: Row(
                            children: [
                              const Text(
                                'Ví QR',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const Spacer(),
                              if (provider.isIntro)
                                if (!dashProvider.isSync)
                                  TextButton(
                                    onPressed: _onUpdateContact,
                                    style: ButtonStyle(
                                      overlayColor: WidgetStateProperty.all(
                                          Colors.transparent),
                                    ),
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: const Text(
                                        'Cập nhật danh bạ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColor.BLUE_TEXT,
                                            decoration:
                                                TextDecoration.underline,
                                            height: 1.4),
                                      ),
                                    ),
                                  )
                                else
                                  TextButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      overlayColor: WidgetStateProperty.all(
                                          Colors.transparent),
                                    ),
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: const Text(
                                        'Đang cập nhật',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColor.BLUE_TEXT,
                                            decoration:
                                                TextDecoration.underline,
                                            height: 1.4),
                                      ),
                                    ),
                                  )
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          // padding: const EdgeInsets.only(left: 20),
                          children: List.generate(
                              provider.listCategories.length, (index) {
                            final model = provider.listCategories[index];
                            return GestureDetector(
                              onTap: () {
                                if (scrollController.hasClients) {
                                  scrollController.jumpTo(0.0);
                                }
                                searchController.clear();
                                provider.updateCategory(value: model);
                                provider.updateOffset(0);
                                if (model.type != CategoryType.suggest.value) {
                                  _bloc.add(
                                      ContactEventGetList(type: model.type));
                                } else {
                                  _bloc.add(ContactEventGetListPending());
                                }

                                if (model.type == CategoryType.vcard.value) {
                                  _onCheckSyncContact();
                                }
                              },
                              child: _buildCategory(
                                  title: model.title,
                                  url: model.url,
                                  isSelect: provider.category == model,
                                  type: model.type),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    if (state.isLoading)
                      const Expanded(
                        child: Center(
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
                                listContactDTO: provider.listAllSearch,
                                list: provider.listContactDTO,
                                onChange: (value) {
                                  if (value.isNotEmpty) {
                                    if (_debounce?.isActive ?? false) {
                                      _debounce!.cancel();
                                    }
                                    _debounce = Timer(
                                        const Duration(milliseconds: 300), () {
                                      _bloc.add(
                                        SearchContactEvent(
                                          nickName: value,
                                          type: provider.category!.type,
                                        ),
                                      );
                                    });
                                  } else {
                                    searchController.clear();
                                    provider.updateOffset(0);
                                    int type = provider.category!.type;
                                    _bloc.add(ContactEventGetList(
                                        type: type, isLoading: false));
                                  }
                                },
                                isEdit: provider.category!.type != 8),
                          ),
                    ]
                  ],
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () async {
                      Map<String, dynamic> param = {};
                      param['typeScan'] = TypeScan.DASHBOARD_SCAN;
                      final data = await NavigationService.push(
                          Routes.SCAN_QR_VIEW_SCREEN,
                          arguments: param);
                      if (data is Map<String, dynamic>) {
                        if (!mounted) return;
                        await QRScannerUtils.instance.onScanNavi(data, context,
                            onCallBack: () {
                          _bloc.add(
                            ContactEventGetList(type: provider.category?.type),
                          );
                        });
                      }
                      _bloc.add(ContactEventGetList(
                          type: provider.category?.type, isLoading: false));
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColor.BLUE_TEXT,
                          borderRadius: BorderRadius.circular(100)),
                      child:
                          Image.asset('assets/images/ic-add-new-qr-wallet.png'),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCategory(
      {required String title,
      required String url,
      bool isSelect = false,
      int type = -1}) {
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
            padding: type == CategoryType.community.value
                ? const EdgeInsets.symmetric(vertical: 10.5, horizontal: 8.0)
                : EdgeInsets.zero,
            child: Image.asset(
              url,
              width: type == CategoryType.community.value ? 14 : 35,
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
    required List<List<ContactDTO>> listContactDTO,
    required List<ContactDTO> list,
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
          if (listContactDTO.isNotEmpty)
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: listContactDTO.length,
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return const SizedBox.shrink();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: List.generate(
                        listContactDTO[index].length,
                        (i) {
                          ContactDTO e = listContactDTO[index][i];
                          return IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      right: 12, bottom: 12),
                                  alignment: Alignment.center,
                                  child: Text(
                                    e.nickname.isNotEmpty
                                        ? e.nickname[0].toUpperCase()
                                        : e.nickname.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: (i == 0)
                                          ? AppColor.BLACK_TEXT
                                          : AppColor.TRANSPARENT,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: _buildItemSave(
                                      dto: e, isEdit: isEdit, list: list),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
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
    required List<ContactDTO> list,
    bool isEdit = true,
  }) {
    return GestureDetector(
      onTap: () async {
        int type =
            Provider.of<ContactProvider>(context, listen: false).category!.type;
        int offset =
            Provider.of<ContactProvider>(context, listen: false).offset;

        await Utils.navigatePage(
            context,
            ContactDetailScreen(
              dto: dto,
              isEdit: isEdit,
              listContact: list,
              pageNumber: offset,
              type: type,
            ));
        _onRefresh(isLoading: false);
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
                            color: dto.type == 4
                                ? AppColor.BLACK_TEXT
                                : dto.bankColor,
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
    if (imageId.isNotEmpty) {
      return DecorationImage(
          image: ImageUtils.instance.getImageNetWork(imageId),
          fit: type == 2 ? BoxFit.contain : BoxFit.cover);
    } else {
      if (type != 1) {
        return const DecorationImage(
            image: AssetImage('assets/images/ic-tb-qr.png'),
            fit: BoxFit.contain);
      } else {
        return const DecorationImage(
            image: AssetImage('assets/images/ic-viet-qr-small.png'),
            fit: BoxFit.contain);
      }
    }
  }

  Widget _buildTapSecond({required List<ContactDTO> list}) {
    if (list.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: _onRefreshTabSecond,
        child: Container(
          margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: List.generate(
              list.length,
              (index) {
                ContactDTO dto = list[index];
                return _buildItemSuggest(dto: dto);
              },
            ).toList(),
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.circular(40),
                  border:
                      Border.all(color: AppColor.GREY_LIGHT.withOpacity(0.3)),
                  image: getImage(dto?.type ?? 0, dto?.imgId ?? ''),
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

  void _onSyncCard(List<VCardModel> listVCards) async {
    if (listVCards.isNotEmpty) {
      if (listVCards.length > maxLength) {
        int num = (listVCards.length / maxLength).floor();

        List<List<VCardModel>> datas = [];
        for (int i = 0; i < num; i++) {
          List<VCardModel> values =
              listVCards.sublist(i * maxLength, (i + 1) * maxLength);
          datas = [...datas, values];
        }

        if (num * maxLength < listVCards.length) {
          List<VCardModel> values =
              listVCards.sublist(num * maxLength, listVCards.length);
          datas = [...datas, values];
        }
        for (var e in datas) {
          final data = await _insertContacts(e);
          if (data.status == Stringify.RESPONSE_STATUS_FAILED) {
            await DialogWidget.instance.openMsgDialog(
                title: 'Không thể lưu danh bạ',
                msg: CheckUtils.instance.getCheckMessage(data.message));

            return;
          }
        }
        int type =
            Provider.of<ContactProvider>(context, listen: false).category!.type;
        _bloc.add(ContactEventGetList(type: type, isLoading: false));
      } else {
        _bloc.add(InsertVCardEvent(listVCards));
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class HeavyTaskData {
  HeavyTaskData({required this.progress, this.index});

  double progress;
  int? index;
}
