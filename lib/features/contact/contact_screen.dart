import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/contact/blocs/contact_bloc.dart';
import 'package:vierqr/features/contact/blocs/contact_provider.dart';
import 'package:vierqr/features/contact/events/contact_event.dart';
import 'package:vierqr/features/contact/states/contact_state.dart';
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

class _ContactStateState extends State<_ContactState> {
  late ContactBloc _bloc;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(ContactEventGetList());
    });
  }

  Future<void> startBarcodeScanStream() async {
    String data = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
    if (data.isNotEmpty) {
      if (data == TypeQR.NEGATIVE_TWO.value) {
        DialogWidget.instance.openMsgDialog(
          title: 'Không thể xác nhận mã QR',
          msg: 'Ảnh QR không đúng định dạng, vui lòng chọn ảnh khác.',
          function: () {
            Navigator.pop(context);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        );
      } else {
        _bloc.add(ScanQrContactEvent(data));
      }
    }
  }

  Future<void> _onRefresh() async {
    _bloc.add(ContactEventGetList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        title: 'Danh bạ',
        actions: [
          GestureDetector(
            onTap: () {
              startBarcodeScanStream();
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
            // DialogWidget.instance.openLoadingDialog();
          }

          if (state.status == BlocStatus.UNLOADING) {
            // Navigator.pop(context);
          }

          if (state.type == ContactType.SUGGEST) {
            Provider.of<ContactProvider>(context, listen: false).updateTab(0);
            _bloc.add(ContactEventGetList());
          }

          if (state.type == ContactType.SCAN) {
            _bloc.add(UpdateEvent());
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
                            provider.updateTab(index);
                            if (index == 1) {
                              _bloc.add(ContactEventGetListPending());
                            } else {
                              _bloc.add(ContactEventGetList());
                            }
                          },
                          text: model.title,
                          isSuggest: index == 1,
                          isSelect: provider.tab == model.index,
                        );
                      }).toList(),
                    ),
                    if (provider.tab == 0) ...[
                      const SizedBox(height: 10),
                      TextFieldCustom(
                        isObscureText: false,
                        maxLines: 1,
                        fillColor: AppColor.WHITE,
                        // controller: provider.contentController,
                        hintText: 'Tìm kiếm danh bạ',
                        inputType: TextInputType.text,
                        prefixIcon: const Icon(Icons.search),
                        keyboardAction: TextInputAction.next,
                        onChange: (value) {},
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: ListView.separated(
                            itemCount: state.listContactDTO.length,
                            separatorBuilder: (context, index) {
                              if (index == state.listContactDTO.length - 1) {
                                return const SizedBox.shrink();
                              }
                              String firstLetterA =
                                  (state.listContactDTO[index].nickname)[0];
                              String firstLetterB =
                                  (state.listContactDTO[index + 1].nickname)[0];
                              if (firstLetterA != firstLetterB) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    firstLetterB,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
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
                                      child: Text(
                                          (state.listContactDTO[index]
                                              .nickname)[0],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    _buildItemSave(
                                        dto: state.listContactDTO[index]),
                                  ],
                                );
                              }
                              return _buildItemSave(
                                  dto: state.listContactDTO[index]);
                            },
                          ),
                        ),
                      ),
                    ] else
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.only(top: 16),
                          children: List.generate(
                              state.listContactDTOSuggest.length, (index) {
                            ContactDTO dto = state.listContactDTOSuggest[index];
                            return _buildItemSuggest(dto: dto);
                          }).toList(),
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
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              const Spacer(),
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
              const SizedBox(
                width: 12,
              ),
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
            // if (isSuggest)
            //   Container(
            //     padding: const EdgeInsets.all(4),
            //     margin: const EdgeInsets.only(left: 4),
            //     width: 20,
            //     height: 20,
            //     alignment: Alignment.center,
            //     decoration: BoxDecoration(
            //         color: AppColor.BLUE_TEXT.withOpacity(0.4),
            //         borderRadius: BorderRadius.circular(100)),
            //     child: const Text(
            //       '1',
            //       style: TextStyle(
            //           fontSize: 10,
            //           fontWeight: FontWeight.w400,
            //           color: AppColor.BLUE_TEXT),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}

class DataModel {
  final String title;
  final int index;

  DataModel({required this.title, required this.index});
}
