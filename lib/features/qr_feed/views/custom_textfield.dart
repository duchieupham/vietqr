import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final Color borderColor;
  final Color hintTextColor;
  final VoidCallback onClear;
  final ValueChanged<String> onChanged;
  final bool isActive;

  CustomTextField({
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.borderColor,
    required this.hintTextColor,
    required this.onClear,
    required this.onChanged,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Container(
          decoration: BoxDecoration(
            color: isActive ? Colors.transparent : const Color(0xFFF0F4FA),
            border: Border(
              bottom: BorderSide(
                color: borderColor,
                width: 1.0,
              ),
            ),
          ),
          child: TextField(
            controller: controller,
            enabled: isActive,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: hintTextColor),
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              suffixIcon: isActive && controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                      ),
                      onPressed: onClear,
                    )
                  : null,
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
