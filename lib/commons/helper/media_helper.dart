import 'package:just_audio/just_audio.dart';

import '../../features/home/repostiroties/home_repository.dart';
import '../../models/response_message_dto.dart';

class MediaHelper {
  MediaHelper._privateConsrtructor();

  static MediaHelper _instance = MediaHelper._privateConsrtructor();

  static MediaHelper get instance => _instance;

  AudioPlayer _player = AudioPlayer();
  HomeRepository homeRepository = HomeRepository();

  playAudio(Map<String, dynamic> param) async {
    ResponseMessageDTO messageDTO =
        await homeRepository.voiceTransaction(param);

    if (messageDTO.status == 'SUCCESS') {
      await _player.setUrl(// Load a URL
          messageDTO.message);
      _player.play();
    }
  }
}
