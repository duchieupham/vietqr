import 'package:flutter/material.dart';
import 'package:vierqr/models/branch_filter_dto.dart';
import 'package:vierqr/models/branch_filter_insert_dto.dart';

class BusinessTransProvider extends ChangeNotifier {
  List<BranchFilterDTO> filters = [];

  BranchFilterInsertDTO? brandDTO;

  BranchFilterDTO? filterSelected;

  updateFilters(List<BranchFilterDTO> value) {
    filters.clear();
    if (filters.where((element) => element.branchId == 'all').isEmpty) {
      filters.add(const BranchFilterDTO(
          branchId: 'all', branchName: 'Tất cả chi nhánh'));
    }
    if (filters.length <= 1 && value.isNotEmpty) {
      filters.addAll(value);
      updateFilterSelected(filters.first);
    }
    notifyListeners();
  }

  void updateFilterSelected(value) {
    filterSelected = value;
    notifyListeners();
  }

  void updateBranchFilter(value) {
    brandDTO = value;
    notifyListeners();
  }
}
