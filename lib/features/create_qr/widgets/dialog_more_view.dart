import 'package:flutter/material.dart';

class DialogMoreView extends StatefulWidget {
  const DialogMoreView({super.key});

  @override
  State<DialogMoreView> createState() => _DialogMoreViewState();
}

class _DialogMoreViewState extends State<DialogMoreView> {
  final List<DataMoreModel> list = [
    DataMoreModel(url: 'assets/images/ic-print-blue.png', text: 'In mã QR'),
    DataMoreModel(url: 'assets/images/ic-img-blue.png', text: 'Lưu ảnh QR'),
    DataMoreModel(
        url: 'assets/images/ic-copy-blue.png', text: 'Sao chép thông tin'),
    DataMoreModel(url: 'assets/images/ic-share-blue.png', text: 'Chia sẻ'),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Column(
                  children: List.generate(list.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(index);
                      },
                      child: _buildItem(
                        url: list[index].url,
                        text: list[index].text,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem({required String url, required String text}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Image.asset(url, width: 40),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class DataMoreModel {
  final String url;
  final String text;

  DataMoreModel({required this.url, required this.text});
}
