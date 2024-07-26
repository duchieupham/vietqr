import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/create_store/widgets/header_store_widget.dart';
import 'package:vierqr/features/search_user/search_user_screen.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/detail_group_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class ShareNotifyMemberView extends StatefulWidget {
  final Function(List<AccountMemberDTO>) callBack;
  final String nameStore;
  final List<AccountMemberDTO> members;

  const ShareNotifyMemberView(
      {super.key,
      required this.callBack,
      required this.nameStore,
      required this.members});

  @override
  State<ShareNotifyMemberView> createState() => _ShareNotifyMemberViewState();
}

class _ShareNotifyMemberViewState extends State<ShareNotifyMemberView> {
  bool isEnableButton = true;
  List<AccountMemberDTO> _members = [];

  final AccountMemberDTO dtoAdmin = AccountMemberDTO(
      firstName: SharePrefUtils.getProfile().firstName,
      middleName: SharePrefUtils.getProfile().middleName,
      lastName: SharePrefUtils.getProfile().lastName,
      phoneNo: SharePrefUtils.getPhone(),
      isOwner: true,
      imgId: SharePrefUtils.getProfile().imgId);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.members.isNotEmpty) {
        _members = [...widget.members];
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderStoreWidget(
          title: 'Chia sẻ thông báo giao dịch\ncho nhân viên cửa hàng',
          desTitle:
              'Khi có khách hàng thanh toán qua mã VietQR cửa hàng, chúng tôi sẽ thông báo cho cả bạn và nhân viên.',
          nameStore: widget.nameStore,
        ),
        _buildItemMember(dtoAdmin),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _onInsertMember,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 4, 20, 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColor.BLUE_TEXT.withOpacity(0.35),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/ic-add-member-white.png',
                  height: 30,
                  color: AppColor.BLUE_TEXT,
                ),
                const Text(
                  'Thêm thành viên',
                  style: TextStyle(color: AppColor.BLUE_TEXT),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: _members.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Danh sách nhân viên',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          margin: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppColor.BLUE_TEXT.withOpacity(0.35),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${_members.length}',
                                style: const TextStyle(color: AppColor.BLUE_TEXT),
                              ),
                              Image.asset(
                                'assets/images/ic-member-bdsd-blue.png',
                                height: 24,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _members.length,
                        itemBuilder: (BuildContext context, int index) {
                          AccountMemberDTO e = _members[index];
                          return _buildItemMember(e);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        if (isEnableButton)
          MButtonWidget(
            title: 'Tiếp tục',
            margin: EdgeInsets.zero,
            isEnable: true,
            onTap: () => widget.callBack.call(_members),
          ),
      ],
    );
  }

  void _onInsertMember() async {
    FocusManager.instance.primaryFocus?.unfocus();
    isEnableButton = false;
    setState(() {});
    await DialogWidget.instance.showModelBottomSheet(
      isDismissible: true,
      height: MediaQuery.of(context).size.height * 0.6,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 40),
      borderRadius: BorderRadius.circular(16),
      widget: SearchUserScreen(
        listMember: _members,
        onSelected: (dto) async {
          _members = [..._members, dto];
          updateState();
        },
      ),
    );
    setState(() {
      isEnableButton = true;
    });
  }

  Widget _buildItemMember(AccountMemberDTO dto) {
    return GestureDetector(
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
            color: AppColor.WHITE,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey, width: 0.5)),
        child: Row(
          children: [
            const SizedBox(
              width: 12,
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(44),
                image: dto.imgId.isNotEmpty
                    ? DecorationImage(
                        image: ImageUtils.instance.getImageNetWork(dto.imgId),
                        fit: BoxFit.cover)
                    : const DecorationImage(
                        image: AssetImage('assets/images/ic-avatar.png')),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dto.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    dto.phoneNo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              ),
            ),
            if (dto.isOwner)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                    color: AppColor.BLUE_TEXT.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30)),
                child: const Text(
                  'Quản lý',
                  style: TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
                ),
              )
            else
              GestureDetector(
                onTap: () {
                  _members.remove(dto);
                  updateState();
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.remove_circle_outline,
                    size: 18,
                    color: AppColor.RED_TEXT,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void updateState() {
    setState(() {});
  }
}
