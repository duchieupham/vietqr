import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/models/ecommerce_request_dto.dart';

class ConnectionInfoView extends StatelessWidget {
  final EcommerceRequest dto;
  const ConnectionInfoView({super.key, required this.dto});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      physics: const ClampingScrollPhysics(),
      children: [
        const Text(
          'Thông tin kết nối',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 18),
        _buildItem(title: 'Tên đại lý:', name: dto.fullName),
        _buildItem(title: 'Tên rút gọn:', name: dto.name),
        _buildItem(
            title: 'Loại hình:',
            name: dto.businessType == 0 ? 'Cá nhân' : 'Doanh nghiệp'),
        _buildItem(
            title: 'TK liên kết:',
            name: '${dto.bankCode} - ${dto.bankAccount}'),
        _buildItem(
            title: 'CCCD/CMND/ĐKKD:',
            name: dto.nationalId.isNotEmpty ? dto.nationalId : '-'),
        _buildItem(
            title: 'Địa chỉ:',
            name: dto.address.isNotEmpty ? dto.address : '-'),
        _buildItem(
            title: 'Ngành nghề:',
            name: dto.career.isNotEmpty ? dto.career : '-'),
        _buildItem(
            title: 'Email:', name: dto.email.isNotEmpty ? dto.email : '-'),
        _buildItem(
            title: 'SĐT liên hệ:',
            name: dto.phoneNo.isNotEmpty ? dto.phoneNo : '-'),
      ],
    );
  }

  Widget _buildItem({required String title, required String name}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 15)),
              SizedBox(
                width: 180,
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 15),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const MySeparator(color: AppColor.GREY_DADADA),
      ],
    );
  }
}
