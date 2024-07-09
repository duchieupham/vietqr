import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/file_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/qr_feed/blocs/qr_feed_bloc.dart';
import 'package:vierqr/features/qr_feed/events/qr_feed_event.dart';
import 'package:vierqr/features/qr_feed/states/qr_feed_state.dart';
import 'package:vierqr/features/qr_feed/widgets/custom_textfield.dart';
import 'package:vierqr/features/qr_feed/widgets/default_appbar_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/qr_create_type_dto.dart';
import 'package:vierqr/navigator/app_navigator.dart';

class QrStyle extends StatefulWidget {
  final int type;
  final QrCreateFeedDTO dto;
  const QrStyle({super.key, required this.type, required this.dto});

  @override
  State<QrStyle> createState() => _QrStyleState();
}

class _QrStyleState extends State<QrStyle> {
  bool _isPersonalSelected = true;
  bool _isLogoAdded = false;
  bool _isQrLink = true;
  int _charCount = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _selectedValue = 1;

  final QrFeedBloc _bloc = getIt.get<QrFeedBloc>();
  final imagePicker = ImagePicker();
  File? filePicker;
  double _inputHeight = 52;

  int maxLine = 1;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_checkInputHeight);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {},
    );
  }

  void _checkInputHeight() async {
    int count = _descriptionController.text.split('\n').length;

    if (count == 0 && _inputHeight == 52.0) {
      return;
    }
    if (count <= 10) {
      // use a maximum height of 6 rows
      // height values can be adapted based on the font size
      var newHeight = count == 0 ? 52.0 : 28.0 + (count * 18.0);
      setState(() {
        _inputHeight = newHeight;
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEnable = false;
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      isEnable = true;
    } else {
      isEnable = false;
    }
    return BlocConsumer<QrFeedBloc, QrFeedState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.request == QrFeed.CREATE_QR &&
            state.status == BlocStatus.SUCCESS) {
          // DialogWidget.instance.openMsgSuccessDialog(
          //   title: 'Tạo mã QR thành công',
          //   msg: '',
          //   function: () {
          //     Navigator.pop(context);

          //   },
          // );
          NavigationService.popUntil(Routes.DASHBOARD);
          Fluttertoast.showToast(
            msg: 'Tạo mã QR thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: _bottomButton(isEnable),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const DefaultAppbarWidget(),
              SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  child: _buildBody(),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    LinearGradient gradient = VietQRTheme.gradientColor.viet_qr;
    String imgQrType = '';
    String textQrType = '';
    switch (widget.type) {
      case 3:
        imgQrType = 'assets/images/ic-vietqr-trans.png';
        textQrType = 'Mã VietQR';
        gradient;
        break;
      case 0:
        imgQrType = 'assets/images/ic-popup-bank-linked.png';
        textQrType = 'Mã QR đường dẫn';
        gradient = VietQRTheme.gradientColor.qr_link;
        break;
      case 2:
        imgQrType = 'assets/images/ic-vcard-green.png';
        textQrType = 'Mã QR VCard';
        gradient = VietQRTheme.gradientColor.vcard;
        break;
      case 1:
        imgQrType = 'assets/images/ic-other-qr.png';
        textQrType = 'Mã QR Khác';
        gradient = VietQRTheme.gradientColor.other_qr;
        break;
      default:
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _gradients[_selectedValue - 1],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(25),
                color: AppColor.WHITE,
                child: QrImageView(
                  data: '',
                  size: 100,
                  version: QrVersions.auto,
                  embeddedImage: filePicker != null
                      ? Image.file(filePicker!).image
                      : const AssetImage('assets/images/ic-viet-qr-small.png'),
                  embeddedImageStyle: const QrEmbeddedImageStyle(
                    size: Size(20, 20),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Quyền riêng tư',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _selectPersonal,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isPersonalSelected
                                  ? Colors.blue.withOpacity(0.3)
                                  : Colors.white,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.person,
                                color: _isPersonalSelected
                                    ? Colors.blue
                                    : AppColor.GREY_TEXT,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _selectPublic,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: !_isPersonalSelected
                                  ? Colors.blue.withOpacity(0.3)
                                  : Colors.white,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.public,
                                color: !_isPersonalSelected
                                    ? Colors.blue
                                    : AppColor.GREY_TEXT,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _toggleLogo,
                          child: Container(
                            width: 120,
                            height: 30,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: AppColor.WHITE,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const XImage(
                                    imagePath: 'assets/images/ic-img-blue.png'),
                                Text(
                                  _isLogoAdded ? 'Đổi Logo' : 'Thêm Logo',
                                  style: const TextStyle(
                                    color: AppColor.BLUE_TEXT,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // const SizedBox(width: 10),
                        // if (filePicker != null)
                        //   XImage(
                        //     borderRadius: BorderRadius.circular(30),
                        //     imagePath: filePicker!.path,
                        //     height: 30,
                        //     width: 50,
                        //     fit: BoxFit.cover,
                        //   )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: gradient,
                ),
                child: XImage(
                  imagePath: imgQrType,
                ),
              ),
              const SizedBox(width: 10),
              Text(textQrType, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
        const MySeparator(
          color: AppColor.GREY_DADADA,
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Tiêu đề ($_charCount/50)',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColor.GREY_DADADA,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _titleController,
                        maxLength: 50,
                        decoration: InputDecoration(
                          hintText: 'Nhập tên mã QR',
                          hintStyle: const TextStyle(
                              color: AppColor.GREY_TEXT, fontSize: 14),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                          suffixIcon: _titleController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    size: 20,
                                    color: AppColor.GREY_DADADA,
                                  ),
                                  onPressed: () {
                                    _titleController.clear();
                                    _updateCharCount(_titleController.text);
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        onChanged: _updateCharCount,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // CustomTextField(
              //   height: _inputHeight,
              //   textInputType: TextInputType.multiline,
              //   maxLines: maxLine,
              //   // expands: true,
              //   isActive: true,
              //   controller: _descriptionController,
              //   hintText: 'Nhập mô tả cho mã QR',
              //   labelText: 'Mô tả',
              //   onClear: () {
              //     _descriptionController.clear();
              //   },
              //   onChanged: (text) {
              //     setState(() {});
              //   },
              // ),
              const Text(
                'Mô tả',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: _inputHeight,
                child: TextField(
                  controller: _descriptionController,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Nhập mô tả cho mã QR',
                    hintStyle: const TextStyle(
                        color: AppColor.GREY_TEXT, fontSize: 14),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.BLUE_TEXT)),
                    suffixIcon: InkWell(
                      onTap: () {
                        _descriptionController.clear();
                      },
                      child: const Icon(
                        Icons.clear,
                        size: 20,
                        color: AppColor.GREY_DADADA,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Màu nền',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisExtent: 50,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 8,
                ),
                itemCount: _gradients.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _selectValue(index + 1),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: _gradients[index],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: _selectedValue == index + 1
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              // const Text(
              //   'Mẫu QR',
              //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bottomButton(bool isEnable) {
    return Container(
      padding: const EdgeInsets.all(20),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   border: Border(
      //     top: BorderSide(color: Colors.grey, width: 0.5),
      //   ),
      // ),
      child: InkWell(
        onTap: isEnable
            ? () {
                QrCreateFeedDTO dto = QrCreateFeedDTO(
                  typeDto: widget.type.toString(),
                  userIdDTO: widget.dto.userIdDTO,
                  qrNameDTO: _titleController.text,
                  qrDescriptionDTO: _descriptionController.text,
                  valueDTO: widget.dto.valueDTO,
                  pinDTO: '',
                  fullNameDTO: widget.dto.fullNameDTO,
                  phoneNoDTO: widget.dto.phoneNoDTO,
                  emailDTO: widget.dto.emailDTO,
                  companyNameDTO: widget.dto.companyNameDTO,
                  websiteDTO: widget.dto.websiteDTO,
                  addressDTO: widget.dto.addressDTO,
                  additionalDataDTO: '',
                  bankAccountDTO: widget.dto.bankAccountDTO,
                  bankCodeDTO: widget.dto.bankCodeDTO,
                  userBankNameDTO: widget.dto.userBankNameDTO,
                  amountDTO: widget.dto.amountDTO,
                  contentDTO: widget.dto.contentDTO,
                  isPublicDTO: _isPersonalSelected ? '0' : '1',
                  styleDTO: '0',
                  themeDTO: _selectedValue.toString(),
                );
                _bloc.add(CreateQrFeedLink(dto: dto, file: filePicker));

                // switch (widget.type) {
                //   case 0:
                //     final parse = QrLink.fromJson(widget.json);
                //     QrLink qrLink = QrLink(
                //         userId: parse.userId,
                //         qrName: _titleController.text,
                //         qrDescription: _descriptionController.text,
                //         value: parse.value,
                //         pin: '',
                //         isPublic: _isPersonalSelected ? '0' : '1',
                //         style: '0',
                //         theme: _selectedValue.toString());
                //     QrCreateTypeDto dto = QrCreateTypeDto(
                //         type: widget.type.toString(), json: qrLink);
                //     _bloc.add(CreateQrFeedLink(dto: dto, file: filePicker));
                //     break;
                //   case 1:
                //     final parse = QrOther.fromJson(widget.json);
                //     QrOther other = QrOther(
                //       userId: parse.userId,
                //       qrName: _titleController.text,
                //       qrDescription: _descriptionController.text,
                //       value: parse.value,
                //       pin: '',
                //       isPublic: _isPersonalSelected ? '0' : '1',
                //       style: '0',
                //       theme: _selectedValue.toString(),
                //     );
                //     QrCreateTypeDto dto = QrCreateTypeDto(
                //         type: widget.type.toString(), json: other);
                //     _bloc.add(CreateQrFeedLink(dto: dto, file: filePicker));

                //     break;
                //   case 2:
                //     final parse = QrVCard.fromJson(widget.json);
                //     QrVCard vCard = QrVCard(
                //         qrName: _titleController.text,
                //         qrDescription: _descriptionController.text,
                //         fullname: parse.fullname,
                //         phoneNo: parse.phoneNo,
                //         email: parse.email,
                //         companyName: parse.companyName,
                //         website: parse.website,
                //         address: parse.address,
                //         userId: parse.userId,
                //         additionalData: '',
                //         style: '0',
                //         theme: _selectedValue.toString(),
                //         isPublic: _isPersonalSelected ? '0' : '1');
                //     QrCreateTypeDto dto = QrCreateTypeDto(
                //         type: widget.type.toString(), json: vCard);
                //     _bloc.add(CreateQrFeedLink(dto: dto, file: filePicker));
                //     break;
                //   case 3:
                //     final parse = VietQr.fromJson(widget.json);
                //     VietQr vietQr = VietQr(
                //         userId: parse.userId,
                //         qrName: _titleController.text,
                //         qrDescription: _descriptionController.text,
                //         bankAccount: parse.bankAccount,
                //         bankCode: parse.bankCode,
                //         userBankName: parse.userBankName,
                //         amount: parse.amount,
                //         content: parse.content,
                //         isPublic: _isPersonalSelected ? '0' : '1',
                //         style: '0',
                //         theme: _selectedValue.toString());
                //     QrCreateTypeDto dto = QrCreateTypeDto(
                //         type: widget.type.toString(), json: vietQr);
                //     _bloc.add(CreateQrFeedLink(dto: dto, file: filePicker));

                //     break;
                //   default:
                // }
              }
            : null,
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: isEnable
                ? const LinearGradient(
                    colors: [
                      Color(0xFF00C6FF),
                      Color(0xFF0072FF),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: isEnable ? null : const Color(0xFFF0F4FA),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColor.TRANSPARENT,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Thêm mới',
                    style: TextStyle(
                      color: isEnable ? AppColor.WHITE : AppColor.BLACK,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColor.TRANSPARENT,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<List<Color>> _gradients = [
    [const Color(0xFFE1EFFF), const Color(0xFFE5F9FF)],
    [const Color(0xFFBAFFBF), const Color(0xFFCFF4D2)],
    [const Color(0xFFFFC889), const Color(0xFFFFDCA2)],
    [const Color(0xFFA6C5FF), const Color(0xFFC5CDFF)],
    [const Color(0xFFCDB3D4), const Color(0xFFF7C1D4)],
    [const Color(0xFFF5CEC7), const Color(0xFFFFD7BF)],
    [const Color(0xFFBFF6FF), const Color(0xFFFFDBE7)],
    [const Color(0xFFF1C9FF), const Color(0xFFFFB5AC)],
    [const Color(0xFFB4FFEE), const Color(0xFFEDFF96)],
    [const Color(0xFF91E2FF), const Color(0xFF91FFFF)],
  ];

  void _selectValue(int value) {
    setState(() {
      _selectedValue = value;
    });
  }

  void _updateCharCount(String text) {
    setState(() {
      _charCount = text.length;
    });
  }

  void _toggleLogo() async {
    await Permission.mediaLibrary.request();
    await imagePicker.pickImage(source: ImageSource.gallery).then(
      (pickedFile) async {
        if (pickedFile != null) {
          File? file = File(pickedFile.path);
          File? compressedFile = FileUtils.instance.compressImage(file);
          filePicker = compressedFile;
          _isLogoAdded = true;
        } else {
          _isLogoAdded = false;
        }
        setState(() {});
      },
    );
  }

  void _selectPersonal() {
    setState(() {
      _isPersonalSelected = true;
    });
  }

  void _selectPublic() {
    setState(() {
      _isPersonalSelected = false;
    });
  }
}
