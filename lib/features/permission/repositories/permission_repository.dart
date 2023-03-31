import 'package:permission_handler/permission_handler.dart';
import 'package:vierqr/commons/utils/log.dart';

class PermissionRepository {
  const PermissionRepository();
  //Request permissions
  Future<bool> requestPermissions() async {
    bool result = false;
    try {
      // PermissionStatus smsPermission = await Permission.sms.status;
      PermissionStatus cameraPermission = await Permission.camera.status;
      // if (!smsPermission.isGranted) {
      //   await Permission.sms.request();
      // }

      LOG.info('CAMERA PERMISSION: $cameraPermission');
      if (!cameraPermission.isGranted) {
        await Permission.camera.request();
      }
      // smsPermission = await Permission.sms.status;
      cameraPermission = await Permission.camera.status;
      // if (smsPermission.isGranted && cameraPermission.isGranted) {
      //   result = true;
      // }
    } catch (e) {
      print('Error at requestPermissions - PermissionRepository: $e');
    }
    return result;
  }

  //Check permissions
  Future<Map<String, PermissionStatus>> checkPermissions() async {
    Map<String, PermissionStatus> result = {};
    try {
      // PermissionStatus smsPermission = await Permission.sms.status;
      PermissionStatus cameraPermission = await Permission.camera.status;
      // result['sms'] = smsPermission;
      result['camera'] = cameraPermission;
    } catch (e) {
      print('Error at checkPermissions - PermissionRepository: $e');
    }
    return result;
  }
}
