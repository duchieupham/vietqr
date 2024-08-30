import 'package:flutter/services.dart';

class VietnameseNameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final RegExp regExp = RegExp(
      r'^[a-zA-ZÀ-ỹẠ-ỵ0-9\s]*$',
    );
    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class VietnameseNameOnlyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final RegExp regExp = RegExp(
      r'^[a-zA-ZÀ-ỹẠ-ỵ\s]*$',
    );
    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class VietnameseNameLongTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final RegExp regExp = RegExp(
      r'^[a-zA-ZÀ-ỹẠ-ỵ0-9\s,.]*$',
    );
    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class NationalIdInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text;

    // Check for alphanumeric and length up to 10 characters
    if (newText.length <= 20 && RegExp(r'^[a-zA-Z0-9]*$').hasMatch(newText)) {
      String newText = newValue.text.toUpperCase();
      return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    } else {
      return oldValue; // If invalid input, return the old value
    }
  }
}

class EmailInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9\s@.]*$',
    );
    if (emailRegExp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class UrlInputFormatter extends TextInputFormatter {
  final RegExp _urlRegExp = RegExp(
    r'(http|https):\/\/([\w.]+\/?)\S*',
    caseSensitive: false,
  );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (_urlRegExp.hasMatch(newValue.text)) {
      // Apply custom formatting if needed
      return newValue;
    }
    return oldValue;
  }
}

class UppercaseBankNameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all characters except letters and spaces, and convert to uppercase
    String newText =
        newValue.text.replaceAll(RegExp(r'[^A-Za-z\s]'), '').toUpperCase();

    // Return the formatted value with the cursor at the correct position
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class BankAccountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all characters except digits
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Group the digits as per a bank account format (e.g., "xxxx xxxx xxxx xxxx")
    String formattedText = _formatBankAccount(newText);

    // Maintain the selection position
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  // Format the bank account number (e.g., 4 digits separated by spaces)
  String _formatBankAccount(String input) {
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write('');
      }
      buffer.write(input[i]);
    }
    return buffer.toString();
  }
}
