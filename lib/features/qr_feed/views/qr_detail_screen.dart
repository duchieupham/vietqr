import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/qr_feed/blocs/qr_feed_bloc.dart';
import 'package:vierqr/features/qr_feed/events/qr_feed_event.dart';
import 'package:vierqr/features/qr_feed/widgets/default_appbar_widget.dart';
import 'package:vierqr/features/qr_feed/widgets/pop_up_qr_detail_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class QrDetailScreen extends StatefulWidget {
  final String id;
  const QrDetailScreen({super.key, required this.id});

  @override
  State<QrDetailScreen> createState() => _QrDetailScreenState();
}

class _QrDetailScreenState extends State<QrDetailScreen> {
  final QrFeedBloc _bloc = getIt.get<QrFeedBloc>();

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        // _bloc.add(GetQrFeedDetailEvent(id: widget.id, isLoading: true));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: _bottom(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: _buildBody(),
            ),
          )
        ],
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

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 400,
          // margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
                colors: _gradients[0],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight),
          ),
          child: Container(
            // height: 450,
            margin: const EdgeInsets.fromLTRB(30, 25, 30, 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColor.WHITE,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColor.TRANSPARENT,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Grammar Police 👮🏽‍♂️',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '098 883 1389',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppColor.GREY_F0F4FA,
                          ),
                          child: const XImage(
                              imagePath: 'assets/images/ic-save-blue.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    height: 250,
                    width: 250,
                    margin: EdgeInsets.fromLTRB(25, 10, 25, 0),
                    child: QrImageView(
                      padding: EdgeInsets.zero,
                      data: '',
                      size: 80,
                      backgroundColor: AppColor.WHITE,
                      // embeddedImage: const AssetImage(
                      //     'assets/images/ic-viet-qr-small.png'),
                      // embeddedImageStyle: QrEmbeddedImageStyle(
                      //   size: const Size(50, 50),
                      // ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'VCard   |   By VIETQR.VN',
                    style: TextStyle(fontSize: 10, color: AppColor.GREY_TEXT),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Text(
            'lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsumlorem ipsum lorem ipsum lorem ipsum ipsum lorem ipsum ipsu lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsumlorem ipsum lorem ipsum lorem ipsum ipsum lorem ipsum ipsu',
            style: TextStyle(fontSize: 12),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    // getIt.get<QrFeedBloc>().add(InteractWithQrEvent(
                    //     qrWalletId: dto.id,
                    //     interactionType: dto.hasLiked ? '0' : '1'));
                  },
                  child: XImage(
                    imagePath: 'assets/images/ic-heart-grey.png',
                    height: 50,
                    fit: BoxFit.fitHeight,
                  ),
                  // child: XImage(
                  //   imagePath: dto.hasLiked
                  //       ? 'assets/images/ic-heart-red.png'
                  //       : 'assets/images/ic-heart-grey.png',
                  //   height: 50,
                  //   fit: BoxFit.fitHeight,
                  // ),
                ),
                Text(
                  '100',
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColor.GREY_TEXT,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
            const SizedBox(width: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const XImage(
                  imagePath: 'assets/images/ic-comment.png',
                  height: 17,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(width: 6),
                Text(
                  '123',
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColor.GREY_TEXT,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                const XImage(
                  imagePath: 'assets/images/ic-global.png',
                  width: 15,
                  height: 15,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 4),
                Text(
                  // TimeUtils.instance.formatTimeNotification(dto.timeCreated),
                  TimeUtils.instance.formatTimeNotification(123231),
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: AppColor.GREY_TEXT),
                ),
              ],
            ),
          ],
        ),
        const MySeparator(
          color: AppColor.GREY_DADADA,
        ),
        _buildCmt('assets/images/ic-global.png', 'Nguyễn Hiếu Kiên',
            'Mã QR này thật thú vị!!!!', 112312323123),
        _buildCmt(
            'assets/images/ic-global.png',
            'Nguyễn Hiếu Kiên',
            'lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsumlorem lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsumloremlorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsumloremlorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsumlorem',
            112312323123),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildCmt(String imgId, String name, String cmt, int time) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          XImage(
            borderRadius: BorderRadius.circular(100),
            imagePath: imgId,
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 80, // Giới hạn chiều cao của bình luận
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      cmt,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Text(
            TimeUtils.instance.formatTimeNotification(time),
            style: TextStyle(
              fontSize: 12,
              color: AppColor.GREY_TEXT,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottom() {
    return Container(
      height: 80 + MediaQuery.of(context).viewInsets.bottom,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      color: AppColor.WHITE,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(4),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(
                      colors: _gradients[0],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight)),
              child: const XImage(imagePath: 'assets/images/ic-heart-red.png'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColor.WHITE,
                border: Border.all(color: AppColor.GREY_DADADA),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 20),
                  XImage(
                    imagePath: 'assets/images/ic-comment.png',
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 8),
                        hintText: 'Bình luận',
                        hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(4),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(
                      colors: _gradients[0],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight)),
              child: const XImage(imagePath: 'assets/images/ic-dowload.png'),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(4),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(
                      colors: _gradients[0],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight)),
              child:
                  const XImage(imagePath: 'assets/images/ic-share-black.png'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: false,
      pinned: true,
      leadingWidth: double.infinity,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          // height: 40,
          color: AppColor.WHITE,
        ),
      ),
      leading: Container(
        padding: const EdgeInsets.only(left: 8),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
                size: 25,
              ),
            ),
            SizedBox(width: 2),
            XImage(
              borderRadius: BorderRadius.circular(100),
              imagePath: 'assets/images/ic-global.png',
              width: 30,
              height: 30,
            ),
            SizedBox(width: 10),
            Text(
              'Nguyen Hieu Kien',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                // InkWell(
                //   onTap: () {
                //     showModalBottomSheet(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return Container(
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             children: <Widget>[
                //               ListTile(
                //                 leading: Icon(Icons.update),
                //                 title: Text('Cập nhật nội dung mã QR'),
                //                 onTap: () {
                //                   // Add your code to handle the update action
                //                   Navigator.pop(context);
                //                 },
                //               ),
                //               ListTile(
                //                 leading: Icon(Icons.edit),
                //                 title: Text('Tuỳ chỉnh giao diện mã QR'),
                //                 onTap: () {
                //                   // Add your code to handle the customize action
                //                   Navigator.pop(context);
                //                 },
                //               ),
                //               ListTile(
                //                 leading: Icon(Icons.delete),
                //                 title: Text('Xoá QR'),
                //                 onTap: () {
                //                   // Add your code to handle the delete action
                //                   Navigator.pop(context);
                //                 },
                //               ),
                //             ],
                //           ),
                //         );
                //       },
                //     );
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.all(4),
                //     height: 40,
                //     width: 40,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(100),
                //       gradient: LinearGradient(
                //         colors: _gradients[0],
                //         begin: Alignment.centerLeft,
                //         end: Alignment.centerRight,
                //       ),
                //     ),
                //     child: const Image(
                //         image: AssetImage('assets/images/ic-effect.png')),
                //   ),
                // ),
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        details.globalPosition.dx,
                        details.globalPosition.dy + 20,
                        details.globalPosition.dx,
                        details.globalPosition.dy + 20,
                      ),
                      items: <PopupMenuEntry<int>>[
                        const PopupMenuItem<int>(
                          value: 0,
                          child: ListTile(
                            title: Text(
                              'Cập nhật nội dung mã QR',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.blue),
                            ),
                          ),
                        ),
                        const PopupMenuItem<int>(
                          value: 1,
                          child: ListTile(
                            title: Text(
                              'Tuỳ chỉnh giao diện mã QR',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.blue),
                            ),
                          ),
                        ),
                        const PopupMenuItem<int>(
                          value: 2,
                          child: ListTile(
                            title: Text(
                              'Xoá QR',
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ).then((int? result) {
                      if (result != null) {
                        switch (result) {
                          case 0:
                            Navigator.of(context)
                                .pushNamed(Routes.QR_UPDATE_SCREEN);
                            // Handle "Cập nhật nội dung mã QR"
                            break;
                          case 1:
                            // Handle "Tuỳ chỉnh giao diện mã QR"
                            break;
                          case 2:
                            // Handle "Xoá QR"
                            break;
                        }
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: LinearGradient(
                        colors: _gradients[0],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: const Image(
                      image: AssetImage('assets/images/ic-effect.png'),
                    ),
                  ),
                ),
                // InkWell(
                //   onTap: () {},
                //   child: Container(
                //     padding: const EdgeInsets.all(4),
                //     height: 40,
                //     width: 40,
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(100),
                //         gradient: LinearGradient(
                //             colors: _gradients[0],
                //             begin: Alignment.centerLeft,
                //             end: Alignment.centerRight)),
                //     child:
                //         const XImage(imagePath: 'assets/images/ic-effect.png'),
                //   ),
                // ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    DialogWidget.instance.showModelBottomSheet(
                      borderRadius: BorderRadius.circular(16),
                      widget: PopUpQrDetail(),
                      // height: MediaQuery.of(context).size.height * 0.6,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: LinearGradient(
                            colors: _gradients[0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight)),
                    child:
                        const XImage(imagePath: 'assets/images/ic-i-black.png'),
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
