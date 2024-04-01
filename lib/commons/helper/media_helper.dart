import 'package:just_audio/just_audio.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import '../../features/home/repostiroties/home_repository.dart';
import '../../models/response_message_dto.dart';

class MediaHelper {
  MediaHelper._privateConstructor();

  static MediaHelper _instance = MediaHelper._privateConstructor();

  static MediaHelper get instance => _instance;

  AudioPlayer _player = AudioPlayer();
  HomeRepository homeRepository = HomeRepository();

  playAudio(Map<String, dynamic> data) async {
    Map<String, dynamic> param = {};
    param['userId'] = SharePrefUtils.getProfile().userId;
    param['amount'] = data['amount'];
    param['type'] = 0;
    param['transactionId'] = data['transactionReceiveId'];

    ResponseMessageDTO messageDTO =
        await homeRepository.voiceTransaction(param);

    if (messageDTO.status == 'SUCCESS') {
      await _player.setUrl(messageDTO.message); // Load a URL
      _player.play();
    }
  }
}
