import 'package:flutter/material.dart';
import 'package:vierqr/models/branch_filter_dto.dart';
import 'package:vierqr/models/business_member_dto.dart';
import 'package:vierqr/models/transaction_branch_input_dto.dart';

class BusinessInformationProvider extends ChangeNotifier {
  int _indexSelected = 0;
  int _userRole = 0;
  String _businessId = '';
  BranchFilterDTO _filterSelected =
      const BranchFilterDTO(branchId: 'all', branchName: 'Tất cả chi nhánh');
  TransactionBranchInputDTO _input =
      const TransactionBranchInputDTO(branchId: '', businessId: '', offset: 0);

  final List<BusinessMemberDTO> _businessMembers = [];

  int get indexSelected => _indexSelected;

  int get userRole => _userRole;

  String get businessId => _businessId;

  BranchFilterDTO get filterSelected => _filterSelected;

  TransactionBranchInputDTO get input => _input;

  get businessMembers => _businessMembers;

  void updateBusinessMember(List<BusinessMemberDTO> value) {
    _businessMembers.clear();
    _businessMembers.addAll(value);
    notifyListeners();
  }

  void updateInput(TransactionBranchInputDTO value) {
    _input = value;
    notifyListeners();
  }

  void updateIndex(int value) {
    _indexSelected = value;
    notifyListeners();
  }

  void updateFilterSelected(BranchFilterDTO value) {
    _filterSelected = value;
    notifyListeners();
  }

  void updateBusinessId(String value) {
    _businessId = value;
    notifyListeners();
  }

  void updateUserRole(int value) {
    _userRole = value;
    notifyListeners();
  }

  void reset() {
    _indexSelected = 0;
    _userRole = 0;
    _businessId = '';
    _filterSelected =
        const BranchFilterDTO(branchId: 'all', branchName: 'Tất cả chi nhánh');
    _input = const TransactionBranchInputDTO(
        branchId: '', businessId: '', offset: 0);
  }
}
