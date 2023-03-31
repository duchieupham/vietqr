import 'package:flutter/material.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/layouts/box_layout.dart';

class TransactionHistoryView extends StatelessWidget {
  const TransactionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          SubHeader(title: 'Lịch sử giao dịch'),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                  width: width,
                  child: Row(
                    children: [
                      Text('Phân loại theo'),
                      const Spacer(),
                      BoxLayout(
                        width: 200,
                        borderRadius: 10,
                        child: Text('TK ngân hàng'),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                  width: width,
                  child: Row(
                    children: [
                      Text('Lọc theo'),
                      const Spacer(),
                      BoxLayout(
                        width: 200,
                        borderRadius: 10,
                        child: Text('Không'),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
