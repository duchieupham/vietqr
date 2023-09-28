import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
import 'package:vierqr/services/local_storage/local_storage.dart';
import 'package:vierqr/services/shared_references/account_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

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
        create: (context) => ContactProvider()
          ..updateCategory(isFirst: true)
          ..updateIntro(),
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
  StreamSubscription? _syncSub;

  LocalStorageRepository _local = LocalStorageRepository();
  Box? _box;

  String get userId => UserInformationHelper.instance.getUserId();

  @override
  void initState() {
    super.initState();

    initData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(ContactEventGetList(isLoading: true));
      _bloc.add(ContactEventGetListPending());

      _onCheckSyncContact();
    });

    _subscription = eventBus.on<ReloadContact>().listen((_) {
      _onRefresh();
    });
    _syncSub = eventBus.on<CheckSyncContact>().listen((_) {
      _onCheckSyncContact();
    });

    scrollController.addListener(_loadMore);
  }

  void _onCheckSyncContact() async {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (!Provider.of<ContactProvider>(context, listen: false).isIntro) {
        DialogWidget.instance.openDialogIntroduce(
          child: ContactIntroWidget(
            onSync: () async {
              Navigator.pop(context);
              final data = await _fetchContacts();
              Provider.of<ContactProvider>(context, listen: false)
                  .updateListSync(data);
            },
            onSelected: (value) async {
              Navigator.pop(context);
              if (value) {
                await AccountHelper.instance.updateVCard(value);
              }
            },
          ),
        );
      }
    });
  }

  initData() async {
    _bloc = BlocProvider.of(context);
    _pageController = PageController(
        initialPage: Provider.of<ContactProvider>(context, listen: false).tab,
        keepPage: true);
    _box = await _local.openBox(userId);
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
            type: 4,
            imgId: '',
            description: '',
            phoneNo: e.phones.isNotEmpty ? e.phones.first.number : '',
            carrierTypeId: '',
            relation: 0);
      }).toList(),
    );

    sendPort.send(list);
  }

  static void heavyTask(List<dynamic> args) async {
    SendPort sendPort = args[0];
    List<ContactDTO> list = args[1];

    double progress = 0;
    double amount = 1 / list.length;
    for (int i = 0; i < list.length; i++) {
      progress += amount;
      if (i == list.length - 1) {
        if (progress < 1) {
          progress = 1;
        }
      } else if (progress > 1) {
        progress = 1;
      }

      sendPort.send(HeavyTaskData(progress: progress, index: i));
    }
    sendPort.send(HeavyTaskData(progress: progress));
  }

  Stream<HeavyTaskData> _heavyTaskStreamReceiver(List<ContactDTO> list) async* {
    final receivePort = ReceivePort();
    Isolate.spawn(heavyTask, [receivePort.sendPort, list]);
    await for (var message in receivePort) {
      if (message is HeavyTaskData) {
        if (message.index != null) {
          final e = await FlutterContacts.getContact(list[message.index!].id);
          if (e != null) {
            String base64Image = '';
            if (e.photo != null) {
              base64Image = base64Encode(e.photo!);
            }

            final contact = ContactDTO(
                id: e.id.isNotEmpty ? e.id : '',
                nickname: e.displayName.isNotEmpty ? e.displayName : '',
                status: 0,
                type: 4,
                imgId: base64Image,
                description: e.notes.isNotEmpty ? e.notes.first.note : '',
                phoneNo: e.phones.isNotEmpty ? e.phones.first.number : '',
                carrierTypeId: '',
                relation: 0);
            await _local.addProductToWishlist(_box!, contact);
          }
        }
        yield message;
        if (message.progress >= 1) {
          receivePort.close();
          Provider.of<ContactProvider>(context, listen: false)
              .updateSync(false);
          return;
        }
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;

    _syncSub?.cancel();
    _syncSub = null;

    super.dispose();
  }

  _loadMore() async {
    int type =
        Provider.of<ContactProvider>(context, listen: false).category!.type;
    int offset = Provider.of<ContactProvider>(context, listen: false).offset;

    final maxScroll = scrollController.position.maxScrollExtent;
    if (scrollController.offset >= maxScroll &&
        !scrollController.position.outOfRange) {
      _bloc.add(
          ContactEventGetList(type: type, offset: offset, isLoading: false));
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
                .updateListAll(state.listCompareContact, state.listContactDTO);
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

                                if (model.type == 4) {
                                  List<ContactDTO> list = [];
                                  if (_box != null) {
                                    list = _local.getWishlist(_box!);
                                  }
                                  provider.updateListAll([], list);
                                } else if (model.type != 0) {
                                  if (scrollController.hasClients)
                                    scrollController.jumpTo(0.0);
                                  _bloc.add(
                                      ContactEventGetList(type: model.type));
                                } else {
                                  if (controller.hasClients)
                                    controller.jumpTo(0.0);
                                  _bloc.add(ContactEventGetListPending());
                                }
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
                                listContactDTO: provider.listAllSearch,
                                onChange: provider.onSearchAll,
                                isEdit: provider.category!.type != 8 &&
                                    provider.category!.type != 4,
                              ),
                            ),
                      ]
                    ],
                  ),
                  Positioned(
                    bottom: 100,
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
                  if (provider.isSync)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          StreamBuilder<HeavyTaskData>(
                            stream:
                                _heavyTaskStreamReceiver(provider.listContact),
                            builder: (context,
                                AsyncSnapshot<HeavyTaskData> snapshot) {
                              int pt = (((snapshot.data?.progress ?? 0) * 100)
                                  .round());

                              return Column(
                                children: [
                                  LinearPercentIndicator(
                                    animation: true,
                                    animationDuration: 0,
                                    lineHeight: 5,
                                    padding: EdgeInsets.zero,
                                    percent: snapshot.data?.progress ?? 0.0,
                                    progressColor: AppColor.BLUE_TEXT,
                                  ),
                                  Container(
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/ic-contact-sync.png',
                                          width: 60,
                                          height: 60,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Đang lưu danh bạ',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                'Vui lòng không tắt ứng dụng cho tới khi quá trình hoàn tất.',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColor.grey979797,
                                                    height: 1.5),
                                              )
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '$pt%',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
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
    required List<List<ContactDTO>> listContactDTO,
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
                                  e.nickname[0].toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: (i == 0)
                                        ? AppColor.textBlack
                                        : AppColor.TRANSPARENT,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: _buildItemSave(
                                  dto: e,
                                  isEdit: isEdit,
                                ),
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
    bool isEdit = true,
  }) {
    return GestureDetector(
      onTap: () async {
        final data = await Utils.navigatePage(
            context, ContactDetailScreen(dto: dto, isEdit: isEdit));
        if (data != null) {
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
                          text: dto.type == 4 ? dto.phoneNo : dto.description,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: dto.type == 4
                                ? AppColor.textBlack
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
      if (type == 4) {
        return DecorationImage(
            image: MemoryImage(base64Decode(imageId)),
            fit: type == 2 ? BoxFit.contain : BoxFit.cover);
      }
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

  @override
  bool get wantKeepAlive => true;
}

class HeavyTaskData {
  HeavyTaskData({required this.progress, this.index});

  double progress;
  int? index;
}
