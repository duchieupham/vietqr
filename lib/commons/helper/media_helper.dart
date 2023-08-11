import 'package:just_audio/just_audio.dart';

import '../../features/home/repostiroties/home_repository.dart';

class MediaHelper {
  MediaHelper._privateConsrtructor();

  static MediaHelper _instance = MediaHelper._privateConsrtructor();

  static MediaHelper get instance => _instance;

  AudioPlayer _player = AudioPlayer();
  HomeRepository homeRepository = HomeRepository();

  playAudio(Map<String, dynamic> param) async {
    await _player.setUrl(// Load a URL
        'http://103.141.140.202:8009/data/end2end_khanhlinh/8c7d4e03ca9c5871bb82663679398c0c_1_1.1_24.mp3');
    _player.play();
    // ResponseMessageDTO messageDTO =
    //     await homeRepository.voiceTransaction(param);
    //
    // if (messageDTO.status == 'SUCCESS') {
    //   await _player.setUrl(// Load a URL
    //       messageDTO.message);
    //   _player.play();
    //   Future.delayed(const Duration(seconds: 2), () {
    //     _player.stop();
    //   });
    // }
  }
}
