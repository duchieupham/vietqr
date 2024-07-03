import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/qr_feed/widgets/custom_textfield.dart';
import 'package:vierqr/features/qr_feed/widgets/default_appbar_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class QrStyle extends StatefulWidget {
  const QrStyle({super.key});

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
  int? _selectedValue = 2;

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

  void _toggleLogo() {
    setState(() {
      _isLogoAdded = !_isLogoAdded;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _bottomButton(true),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const DefaultAppbarWidget(),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: _buildBody(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _gradients[_selectedValue! - 1],
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
                  embeddedImage:
                      const AssetImage('assets/images/ic-viet-qr-small.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(20, 20),
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
                            XImage(imagePath: 'assets/images/ic-img-blue.png'),
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
              SizedBox(
                width: 20,
                height: 20,
                child: XImage(
                  imagePath: _isQrLink
                      ? 'assets/images/ic-link.png'
                      : 'assets/images/ic-vcard.png',
                ),
              ),
              const SizedBox(width: 10),
              Text(_isQrLink ? 'Mã QR đường dẫn' : 'Mã QR VCard',
                  style: const TextStyle(fontSize: 12)),
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
              CustomTextField(
                isActive: true,
                controller: _descriptionController,
                hintText: 'Nhập mô tả cho mã QR',
                labelText: 'Mô tả',
                borderColor: AppColor.GREY_DADADA,
                hintTextColor: AppColor.GREY_TEXT,
                onClear: () {
                  _descriptionController.clear();
                },
                onChanged: (text) {},
              ),
              const SizedBox(height: 30),
              const Text(
                'Màu nền',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 50, // Điều chỉnh kích thước ô tối đa
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 20,
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
      child: GestureDetector(
        onTap: isEnable ? () {} : null,
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
}
