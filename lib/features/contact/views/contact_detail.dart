import 'package:carousel_slider/carousel_slider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/contact/blocs/contact_bloc.dart';
import 'package:vierqr/features/contact/events/contact_event.dart';
import 'package:vierqr/features/contact/states/contact_state.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';
import 'package:vierqr/models/contact_detail_dto.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/services/sqflite/local_database.dart';

import '../../../commons/utils/printer_utils.dart';
import '../../../commons/widgets/button_icon_widget.dart';
import '../../../commons/widgets/viet_qr.dart';
import '../../../models/qr_generated_dto.dart';
import '../../../services/shared_references/user_information_helper.dart';
import '../../printer/views/printing_view.dart';
import 'contact_edit_view.dart';

class ContactDetailScreen extends StatelessWidget {
  final ContactDTO dto;
  final List<ContactDTO> listContact;
  final bool isEdit;
  final int pageNumber;
  final int type;

  const ContactDetailScreen(
      {super.key,
      required this.dto,
      required this.isEdit,
      required this.listContact,
      this.pageNumber = 0,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactBloc>(
      create: (context) => ContactBloc(context)
        ..add(ContactEventGetDetail(
            id: dto.id, type: dto.type, list: listContact)),
      child: _ContactDetailScreen(
        dto: dto,
        isEdit: isEdit,
        pageNumber: pageNumber,
        type: type,
      ),
    );
  }
}

// ignore: must_be_immutable
class _ContactDetailScreen extends StatefulWidget {
  final ContactDTO dto;
  final bool isEdit;
  final int pageNumber;
  final int type;

  const _ContactDetailScreen(
      {required this.dto,
      required this.isEdit,
      required this.pageNumber,
      required this.type});

  @override
  State<_ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<_ContactDetailScreen> {
  final GlobalKey globalKey = GlobalKey();

  late ContactBloc _bloc;

  int offset = 0;

  QRGeneratedDTO qrGeneratedDTO = QRGeneratedDTO(
    bankCode: '',
    bankName: '',
    bankAccount: '',
    userBankName: '',
    amount: '',
    content: '',
    qrCode: '',
    imgId: '',
    email: '',
    type: 0,
  );

  ContactDetailDTO detailDTO = ContactDetailDTO();

  int selectedIndex = 0;

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

  Future<void> share({required QRGeneratedDTO dto}) async {
    String text = '';

    if (dto.type == 4) {
      text =
          'SĐT: ${dto.bankAccount} - Email: ${dto.email} - Được tạo từ VietQR VN';
    } else {
      text = ShareUtils.instance.getTextSharing(dto);
    }

    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance.shareImage(
        key: globalKey,
        textSharing: text,
      );
    });
  }

  void actionServices(
      BuildContext context, String action, QRGeneratedDTO dto) async {
    if (action == 'SAVE') {
      await Future.delayed(const Duration(milliseconds: 300), () async {
        await ShareUtils.instance.saveImageToGallery(globalKey).then((value) {
          Fluttertoast.showToast(
            msg: 'Đã lưu ảnh',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
          // Navigator.pop(context);
        });
      });
    }
  }

  late PageController pageView;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    setState(() {
      offset = widget.pageNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactBloc, ContactState>(
      listener: (context, state) {
        if (state.type == ContactType.REMOVE) {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: 'Xoá thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
        }

        if (state.type == ContactType.GET_DETAIL) {
          qrGeneratedDTO = QRGeneratedDTO(
            bankCode: state.contactDetailDTO.bankShortName,
            bankName: state.contactDetailDTO.bankName,
            bankAccount: state.contactDetailDTO.bankAccount,
            userBankName: state.contactDetailDTO.nickname,
            amount: '',
            content: '',
            qrCode: state.contactDetailDTO.value,
            imgId: state.contactDetailDTO.imgId,
            email: state.contactDetailDTO.email,
            type: state.contactDetailDTO.type,
          );

          detailDTO = state.contactDetailDTO;
        }

        if (state.type == ContactType.GET_LIST) {
          if (state.listContactDTO.length >= (offset * 20)) {
            _bloc.add(ContactEventGetListDetail(index: (offset * 20)));
          } else {
            _bloc.add(ContactEventGetListDetail(
                index: state.listContactDTO.length - 1));
          }

          setState(() {
            offset++;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: MAppBar(
            title: 'Thẻ QR',
            onPressed: () {
              Navigator.of(context).pop(state.isChange);
            },
            actions: widget.isEdit && qrGeneratedDTO.type == 2
                ? [
                    GestureDetector(
                      onTap: () async {
                        final data = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ContactEditView(contactDetailDTO: detailDTO),
                            // settings: RouteSettings(name: ContactEditView.routeName),
                          ),
                        );

                        if (!mounted) return;
                        if (data is bool) {
                          _bloc.add(ContactEventGetListDetail(
                              index: selectedIndex, isChange: true));
                        }
                      },
                      child: Image.asset(
                        'assets/images/ic-edit.png',
                        height: 40,
                        width: 40,
                      ),
                    ),
                    SizedBox(width: 12)
                  ]
                : null,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: _buildListWidget(
                      context,
                      state.listContactDetail,
                      state.listContactDTO,
                      state.status == BlocStatus.LOADING,
                      state.isLoadMore),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ButtonIconWidget(
                                height: 40,
                                pathIcon: 'assets/images/ic-print-blue.png',
                                title: '',
                                function: () async {
                                  BluetoothPrinterDTO bluetoothPrinterDTO =
                                      await LocalDatabase.instance
                                          .getBluetoothPrinter(
                                              UserInformationHelper.instance
                                                  .getUserId());
                                  if (bluetoothPrinterDTO.id.isNotEmpty) {
                                    bool isPrinting = false;
                                    if (!isPrinting) {
                                      isPrinting = true;
                                      DialogWidget.instance
                                          .showFullModalBottomContent(
                                              widget: const PrintingView());
                                      await PrinterUtils.instance
                                          .print(qrGeneratedDTO)
                                          .then((value) {
                                        Navigator.pop(context);
                                        isPrinting = false;
                                      });
                                    }
                                  } else {
                                    DialogWidget.instance.openMsgDialog(
                                        title: 'Không thể in',
                                        msg:
                                            'Vui lòng kết nối với máy in để thực hiện việc in.');
                                  }
                                },
                                bgColor: Theme.of(context).cardColor,
                                textColor: AppColor.ORANGE,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            Expanded(
                              child: ButtonIconWidget(
                                height: 40,
                                pathIcon:
                                    'assets/images/ic-edit-avatar-setting.png',
                                title: '',
                                function: () {
                                  actionServices(
                                      context, 'SAVE', qrGeneratedDTO);
                                },
                                bgColor: Theme.of(context).cardColor,
                                textColor: AppColor.RED_CALENDAR,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            Expanded(
                              child: ButtonIconWidget(
                                height: 40,
                                pathIcon: 'assets/images/ic-copy-blue.png',
                                title: '',
                                function: () async {
                                  await FlutterClipboard.copy(ShareUtils
                                          .instance
                                          .getTextSharing(qrGeneratedDTO))
                                      .then(
                                    (value) => Fluttertoast.showToast(
                                      msg: 'Đã sao chép',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                          Theme.of(context).cardColor,
                                      textColor: Theme.of(context).hintColor,
                                      fontSize: 15,
                                      webBgColor: 'rgba(255, 255, 255)',
                                      webPosition: 'center',
                                    ),
                                  );
                                },
                                bgColor: Theme.of(context).cardColor,
                                textColor: AppColor.BLUE_TEXT,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            Expanded(
                              child: ButtonIconWidget(
                                height: 40,
                                pathIcon: 'assets/images/ic-share-blue.png',
                                title: '',
                                function: () async {
                                  await share(dto: qrGeneratedDTO);
                                },
                                bgColor: Theme.of(context).cardColor,
                                textColor: AppColor.BLUE_TEXT,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypeQr(ContactDetailDTO dto, {required Function()? onEdit}) {
    Widget buttonEdit = widget.isEdit
        ? GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                  color: AppColor.GREY_BUTTON.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                'Sửa',
                style: TextStyle(fontSize: 12),
              ),
            ),
          )
        : const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: BorderRadius.circular(40),
              image: getImage(dto.type, dto.imgId),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dto.nickname,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                dto.type == 2
                    ? Text(
                        dto.bankShortName,
                        style: TextStyle(fontSize: 12),
                      )
                    : Text(
                        dto.type == 1
                            ? 'VietQR ID'
                            : dto.type == 4
                                ? 'VCard'
                                : 'Thẻ khác',
                        style: TextStyle(fontSize: 12),
                      ),
              ],
            ),
          ),
          buttonEdit,
        ],
      ),
    );
  }

  QRGeneratedDTO getQrDTO(ContactDetailDTO dto) {
    return QRGeneratedDTO(
      bankCode: dto.bankShortName,
      bankName: dto.bankName,
      bankAccount: dto.bankAccount,
      userBankName: dto.nickname,
      amount: '',
      content: '',
      qrCode: dto.value,
      imgId: dto.imgId,
      email: dto.email,
      type: dto.type,
    );
  }

  Widget _buildViewCard(ContactDetailDTO dto, BuildContext contextBloc) {
    if (dto.type == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          VietQr(qrGeneratedDTO: qrGeneratedDTO),
          const SizedBox(
            height: 24,
          ),
          Text(
            'Mô tả QR',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            width: double.infinity,
            height: 100,
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
                color: AppColor.WHITE, borderRadius: BorderRadius.circular(8)),
            child: SingleChildScrollView(
              child: Text(dto.additionalData),
            ),
          )
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: dto.getBgGradient()),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 40, right: 40, top: 68, bottom: 32),
                      decoration: BoxDecoration(
                        color: AppColor.WHITE,
                      ),
                      child: Stack(
                        children: [
                          QrImage(
                            data: dto.value,
                            version: QrVersions.auto,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      dto.nickname,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.WHITE),
                    ),
                    const SizedBox(height: 4),
                    if (dto.type == 4) ...[
                      const Divider(thickness: 1, color: AppColor.WHITE),
                      _buildItem('Số điện thoại', '${dto.phoneNo}'),
                      const Divider(thickness: 1, color: AppColor.WHITE),
                      _buildItem(
                          'Email', '${dto.email.isNotEmpty ? dto.email : '-'}'),
                      const Divider(thickness: 1, color: AppColor.WHITE),
                      _buildItem('Địa chỉ',
                          '${dto.address.isNotEmpty ? dto.address : '-'}'),
                      const Divider(thickness: 1, color: AppColor.WHITE),
                      _buildItem('Công ty',
                          '${dto.company.isNotEmpty ? dto.company : '-'}'),
                      const Divider(thickness: 1, color: AppColor.WHITE),
                      _buildItem('Website',
                          '${dto.website.isNotEmpty ? dto.website : '-'}'),
                      const Divider(thickness: 1, color: AppColor.WHITE),
                      _buildItem('Ghi chú',
                          '${dto.additionalData.isNotEmpty ? dto.additionalData : '-'}'),
                      const SizedBox(height: 20),
                    ] else ...[
                      const Divider(thickness: 1, color: AppColor.WHITE),
                      _buildItem('Ghi chú',
                          '${dto.additionalData.isNotEmpty ? dto.additionalData : '-'}'),
                      if (dto.type == 3 && dto.value.contains('https')) ...[
                        const Divider(thickness: 1, color: AppColor.WHITE),
                        _buildItem('Đường dẫn',
                            '${dto.value.isNotEmpty ? dto.value : '-'}',
                            style: TextStyle(
                              color: Colors.lightBlueAccent,
                              decoration: TextDecoration.underline,
                            ), onTap: () async {
                          // ignore: deprecated_member_use
                          await launch(
                            dto.value,
                            forceSafariVC: false,
                          );
                        }),
                      ],
                      const SizedBox(height: 60),
                    ],
                  ],
                ),
              ),
              Positioned(
                top: 32,
                right: 0,
                left: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTypeQr(
                      dto,
                      onEdit: () async {
                        final data = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ContactEditView(contactDetailDTO: dto),
                          ),
                        );

                        if (!mounted) return;
                        if (data is bool) {
                          _bloc.add(ContactEventGetListDetail(
                              index: selectedIndex, isChange: true));
                        }
                      },
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: AppColor.greyF0F0F0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
        ],
      );
    }
  }

  Widget _buildItem(String title, String content,
      {GestureTapCallback? onTap, TextStyle? style}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: TextStyle(color: AppColor.WHITE),
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                content,
                style: style ?? TextStyle(color: AppColor.WHITE),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final carouselController = CarouselController();

  Widget _buildListWidget(
    BuildContext context,
    List<ContactDetailDTO> list,
    List<ContactDTO> values,
    bool isLoading,
    bool isLoadMore,
  ) {
    final height = MediaQuery.of(context).size.height;
    if (list.isEmpty) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: height,
      child: CarouselSlider(
        carouselController: carouselController,
        items: List.generate(values.length, (index) {
          ContactDetailDTO dto = list[index];
          return ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              if (isLoading)
                Padding(
                  padding: EdgeInsets.only(top: height / 3),
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
              else
                _buildViewCard(dto, context)
            ],
          );
        }).toList(),
        options: CarouselOptions(
          viewportFraction: 1,
          animateToClosest: true,
          height: height,
          enableInfiniteScroll: false,
          scrollDirection: Axis.vertical,
          onPageChanged: ((index, reason) {
            setState(() {
              qrGeneratedDTO = getQrDTO(list[index]);
              detailDTO = list[index];
              selectedIndex = index;
            });

            if (index == values.length - 1) {
              if (!isLoadMore) {
                _bloc.add(
                  GetListContactLoadMore(
                    type: widget.type,
                    offset: offset,
                    isLoading: false,
                    isLoadMore: true,
                    isCompare: true,
                  ),
                );
              }
            } else {
              if (!values[index + 1].isGetDetail) {
                _bloc.add(ContactEventGetListDetail(index: index + 1));
              } else {
                if (list[index].id.isEmpty) {
                  _bloc.add(ContactEventGetListDetail(index: index));
                }
              }
            }
          }),
        ),
      ),
    );
  }
}
