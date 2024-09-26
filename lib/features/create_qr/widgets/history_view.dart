import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/string_utils.dart';

class HistoryView extends StatelessWidget {
  final List<String> history;
  final String output;
  final bool isEquals;

  const HistoryView(
      {super.key, required this.history, required this.output, this.isEquals = false});

  get money {
    if (output.isNotEmpty) {
      if (output.contains('.')) {
        List<String> texts = output.split('.');
        List<String> textLast = texts.last.split('');
        List<String> data = textLast;

        int length = textLast.length;
        for (int i = length - 1; i >= 0;) {
          int value = int.parse(textLast[i].trim());
          if (value == 0) {
            data.removeAt(i);
            i--;
          } else {
            break;
          }
        }
        String textRemove = data.join('');
        if (isEquals) {
          return '${StringUtils.formatMoney(texts.first)},$textRemove';
        } else {
          if (textRemove.isNotEmpty) {
            return '${StringUtils.formatMoney(texts.first)},$textRemove';
          } else {
            return StringUtils.formatMoney(texts.first);
          }
        }
      } else {
        return StringUtils.formatMoney(output);
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (history.isNotEmpty)
            ...List.generate(history.length, (index) {
              return Text(
                history[index],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              );
            }),
          Text(
            money,
            style: const TextStyle(
              color: AppColor.BLUE_TEXT,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
