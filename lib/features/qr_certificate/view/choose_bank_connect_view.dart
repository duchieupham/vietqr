import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/providers/connect_gg_chat_provider.dart';

class ChooseBankConnectView extends StatefulWidget {
  final Function(BankAccountDTO) onSelectBank;
  final BankAccountDTO? bankSelect;
  const ChooseBankConnectView(
      {super.key, required this.onSelectBank, this.bankSelect});

  @override
  State<ChooseBankConnectView> createState() => _ChooseBankConnectViewState();
}

class _ChooseBankConnectViewState extends State<ChooseBankConnectView> {
  List<BankAccountDTO> get listIsOwnerBank =>
      Provider.of<ConnectMediaProvider>(context, listen: false).listIsOwnerBank;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 20),
              // Container(
              //   height: 50,
              //   width: 50,
              //   child: Image.asset(url),
              // ),
              const SizedBox(height: 20),
              const Text(
                'Chọn tài khoản ngân hàng\nđể kích hoạt dịch vụ mã',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              ShaderMask(
                shaderCallback: (bounds) => VietQRTheme
                    .gradientColor.brightBlueLinear
                    .createShader(bounds),
                child: const Text(
                  'VietQR',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColor.WHITE),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                listIsOwnerBank.isNotEmpty
                    ? 'Tất cả tài khoản đã liên kết'
                    : 'Chưa liên kết tài khoản',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 10),
              const MySeparator(
                color: AppColor.GREY_DADADA,
              ),
            ],
          ),
        ),
        ...listIsOwnerBank.map(
          (e) => _itemBank(e),
        )
      ],
    );
  }

  Widget _itemBank(BankAccountDTO dto) {
    return InkWell(
      onTap: () => widget.onSelectBank(dto),
      child: Container(
        color:
            widget.bankSelect == dto ? AppColor.BLUE_BGR : AppColor.TRANSPARENT,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 75,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 0.5, color: Colors.grey),
                    image: DecorationImage(
                      image: ImageUtils.instance.getImageNetWork(dto.imgId),
                    ),
                  ),
                  // Placeholder for bank logo
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dto.bankAccount,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      Text(dto.userBankName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
