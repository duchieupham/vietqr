import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class QrFeedRepository {
  const QrFeedRepository();

  String get userId => SharePrefUtils.getProfile().userId;
}
