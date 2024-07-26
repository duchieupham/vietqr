import 'package:carousel_slider/carousel_slider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/features/contact/blocs/contact_bloc.dart';
import 'package:vierqr/features/contact/events/contact_event.dart';
import 'package:vierqr/features/contact/states/contact_state.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';
import 'package:vierqr/models/contact_detail_dto.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/sqflite/local_database.dart';

import '../../../commons/utils/printer_utils.dart';
import '../../../commons/widgets/button_icon_widget.dart';
import '../../../commons/widgets/viet_qr.dart';
import '../../../models/qr_generated_dto.dart';
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
  final carouselController = CarouselController();

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

  int pageIndex = 0;

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
      phone: dto.phoneNo,
    );
  }

  ContactDetailDTO detailDTO = ContactDetailDTO();

  int selectedIndex = 0;

  bool isScrollCard = false;

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

  Future<void> share({required QRGeneratedDTO dto, GlobalKey? key}) async {
    String text = '';

    if (dto.type == 4) {
      String sdt = '';
      String name = '';
      String email = '';
      if (dto.userBankName.isNotEmpty) {
        name = '\n${dto.userBankName}';
      }
      if (dto.phone.isNotEmpty) {
        sdt = '\nSĐT: ${dto.phone}';
      }
      if (dto.email.isNotEmpty) {
        email = '\nEmail: ${dto.email}';
      }
      text = '$name$sdt$email\nĐược tạo từ VietQR VN';
    } else {
      text = ShareUtils.instance.getTextSharing(dto);
    }

    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance.shareImage(
        key: key!,
        textSharing: text,
      );
    });
  }

  void actionServices(BuildContext context, String action, QRGeneratedDTO dto,
      GlobalKey key) async {
    if (action == 'SAVE') {
      await Future.delayed(const Duration(milliseconds: 300), () async {
        await ShareUtils.instance.saveImageToGallery(key).then((value) {
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
    offset = widget.pageNumber;
    isScrollCard = SharePrefUtils.getScrollCard();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
            phone: state.contactDetailDTO.phoneNo,
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
          body: Stack(
            children: [
              if (state.listContactDetail.isNotEmpty)
                CarouselSlider(
                  carouselController: carouselController,
                  items: List.generate(state.listContactDTO.length, (index) {
                    ContactDetailDTO dto = state.listContactDetail[index];
                    return ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        if (state.status == BlocStatus.LOADING)
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
                    initialPage: state.pageIndex,
                    enableInfiniteScroll: false,
                    scrollDirection: Axis.vertical,
                    onScrolled: (value) async {
                      if (!isScrollCard) {
                        setState(() {
                          isScrollCard = true;
                        });
                        await SharePrefUtils.saveScrollCard(true);
                      }
                    },
                    onPageChanged: ((index, reason) {
                      setState(() {
                        qrGeneratedDTO =
                            getQrDTO(state.listContactDetail[index]);
                        detailDTO = state.listContactDetail[index];
                        selectedIndex = index;
                      });

                      if (index == state.listContactDTO.length - 1) {
                        if (!state.isLoadMore) {
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
                        _bloc.add(ContactEventGetListDetail(index: index));
                      }
                    }),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  bool isPrev = false;

  Widget _buildTypeQr(ContactDetailDTO dto) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6, bottom: 2),
                      child: Image.asset(
                        dto.relation == 1
                            ? 'assets/images/gl-white.png'
                            : 'assets/images/personal-relation.png',
                        color: AppColor.WHITE.withOpacity(0.7),
                        width: 13,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: dto.type == 1
                        ? 'VietQR ID'
                        : dto.type == 4
                            ? 'VCard'
                            : 'Thẻ khác',
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColor.WHITE,
                        fontWeight: FontWeight.w500,
                        height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.clear),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(maxWidth: 40, minWidth: 38),
        ),
        GestureDetector(
          onTap: () {},
          child: SizedBox(
            width: 60,
            height: 40,
            child: Image.asset(
              'assets/images/ic-viet-qr.png',
              height: 40,
            ),
          ),
        ),
        if (widget.isEdit)
          GestureDetector(
            onTap: () async {
              final data = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ContactEditView(contactDetailDTO: detailDTO),
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
      ],
    );
  }

  Widget _buildViewCard(ContactDetailDTO dto, BuildContext contextBloc) {
    final height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Column(
          children: [
            if (dto.type == 2)
              Container(
                padding: EdgeInsets.only(
                    top: height < 750 ? 70 : kToolbarHeight + 40),
                color: AppColor.GREY_BG,
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RepaintBoundaryWidget(
                      globalKey: dto.globalKey ?? GlobalKey(),
                      builder: (key) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: VietQr(
                              qrGeneratedDTO: qrGeneratedDTO, isVietQR: true),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'Mô tả QR',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: double.infinity,
                            height: height < 750 ? null : 80,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                                color: AppColor.WHITE,
                                borderRadius: BorderRadius.circular(8)),
                            child: SingleChildScrollView(
                              child: Text(
                                dto.additionalData,
                                maxLines: 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            else
              RepaintBoundaryWidget(
                globalKey: dto.globalKey ?? GlobalKey(),
                builder: (key) {
                  return Container(
                    height: height,
                    decoration: BoxDecoration(gradient: dto.getBgGradient()),
                    padding: EdgeInsets.only(
                        top: height < 750 ? 70 : kToolbarHeight + 40),
                    child: Column(
                      children: [
                        Container(
                          margin: height < 750
                              ? const EdgeInsets.only(
                                  left: 50, right: 50, top: 8, bottom: 8)
                              : const EdgeInsets.only(
                                  left: 50, right: 50, top: 20, bottom: 20),
                          decoration: const BoxDecoration(color: AppColor.WHITE),
                          child: Stack(
                            children: [
                              VietQr(
                                qrGeneratedDTO: null,
                                qrCode: dto.value,
                                size: height < 750 ? height / 3 : null,
                                isEmbeddedImage: true,
                              ),
                              if (dto.imgId.isNotEmpty)
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: AppColor.WHITE,
                                        borderRadius: BorderRadius.circular(40),
                                        image: getImage(dto.type, dto.imgId),
                                      ),
                                    ),
                                  ),
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
                        _buildTypeQr(dto),
                        SizedBox(height: height < 750 ? 4 : 20),
                        if (dto.type == 4)
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  _buildItem('Số điện thoại', dto.phoneNo),
                                  _buildItem('Email',
                                      dto.email.isNotEmpty ? dto.email : ''),
                                  _buildItem('Địa chỉ',
                                      dto.address.isNotEmpty ? dto.address : ''),
                                  _buildItem('Công ty',
                                      dto.company.isNotEmpty ? dto.company : ''),
                                  _buildItem('Website',
                                      dto.website.isNotEmpty ? dto.website : ''),
                                  _buildItem('Ghi chú',
                                      dto.additionalData.isNotEmpty ? dto.additionalData : ''),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          )
                        else ...[
                          _buildItem('Ghi chú',
                              dto.additionalData.isNotEmpty ? dto.additionalData : ''),
                          if (dto.type == 3 && dto.value.contains('https')) ...[
                            _buildItem('Đường dẫn',
                                dto.value.isNotEmpty ? dto.value : '',
                                style: const TextStyle(
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
                  );
                },
              ),
          ],
        ),
        Positioned(
          top: height < 750 ? 30 : kToolbarHeight,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildAppBar(),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: SizedBox(
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
                    bgColor: Theme.of(context).cardColor.withOpacity(0.7),
                    textColor: AppColor.ORANGE,
                    function: () async {
                      BluetoothPrinterDTO bluetoothPrinterDTO =
                          await LocalDatabase.instance.getBluetoothPrinter(
                              SharePrefUtils.getProfile().userId);
                      if (bluetoothPrinterDTO.id.isNotEmpty) {
                        bool isPrinting = false;
                        if (!isPrinting) {
                          isPrinting = true;
                          DialogWidget.instance.showFullModalBottomContent(
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
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Expanded(
                  child: ButtonIconWidget(
                    height: 40,
                    pathIcon: 'assets/images/ic-edit-avatar-setting.png',
                    title: '',
                    function: () {
                      actionServices(context, 'SAVE', qrGeneratedDTO,
                          dto.globalKey ?? GlobalKey());
                    },
                    bgColor: Theme.of(context).cardColor.withOpacity(0.7),
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
                      await FlutterClipboard.copy(ShareUtils.instance
                              .getTextSharing(qrGeneratedDTO))
                          .then(
                        (value) => Fluttertoast.showToast(
                          msg: 'Đã sao chép',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Theme.of(context).cardColor,
                          textColor: Theme.of(context).hintColor,
                          fontSize: 15,
                          webBgColor: 'rgba(255, 255, 255)',
                          webPosition: 'center',
                        ),
                      );
                    },
                    bgColor: Theme.of(context).cardColor.withOpacity(0.7),
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
                      await share(dto: qrGeneratedDTO, key: dto.globalKey);
                    },
                    bgColor: Theme.of(context).cardColor.withOpacity(0.7),
                    textColor: AppColor.BLUE_TEXT,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isScrollCard)
          Positioned.fill(
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  isScrollCard = true;
                });
                await SharePrefUtils.saveScrollCard(true);
              },
              child: Container(
                color: AppColor.BLACK.withOpacity(0.8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/ic-slide-updown.png'),
                    const SizedBox(height: 30),
                    const Text(
                      'Trượt lên và xuống để xem thẻ QR khác',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColor.WHITE,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }

  Widget _buildItem(String title, String content,
      {GestureTapCallback? onTap, TextStyle? style}) {
    final height = MediaQuery.of(context).size.height;
    if (content.isEmpty) {
      return const SizedBox();
    }
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 20, vertical: height < 750 ? 9 : 14),
          decoration: const BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(width: 0.5, color: AppColor.WHITE),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColor.WHITE,
                    fontSize: height < 750 ? 12 : 14,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: onTap,
                  child: Text(
                    content,
                    style: style ??
                        TextStyle(
                          color: AppColor.WHITE,
                          fontSize: height < 750 ? 12 : 14,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
