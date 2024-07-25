import UIKit
import Flutter
//Config voice
// import AVFoundation // Thêm import AVFoundation

// This is required for calling FlutterLocalNotificationsPlugin.setPluginRegistrantCallback method.
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // This is required to make any communication available in the action isolate.
        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
            GeneratedPluginRegistrant.register(with: registry)
        }
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        }
        
        let controller = window?.rootViewController as! FlutterViewController
        
        let CHANNEL = "scan_qr_code"
        
        let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "processQRImage" {
                
                let qrController = ViewController()
                
                guard let args = call.arguments as? [String: Any],
                      let base64Image = args["imageData"] as? String,
                      let imageBytes = Data(base64Encoded: base64Image) else {
                    result(FlutterError(code: "invalid_argument", message: "Invalid arguments", details: nil))
                    return
                }
                
                // Giải mã mã QR từ ảnh
                let qrResult = qrController.decodeQRImage(imageBytes: imageBytes)
                result(qrResult)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        //Config voice
        // Thiết lập AVAudioSession để phát âm thanh ngay cả khi ở chế độ im lặng
        // do {
        //     try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        //     try AVAudioSession.sharedInstance().setActive(true)
        // } catch {
        //     print("Failed to set audio session category: \(error)")
        // }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}


class ViewController: UIViewController {
    let CHANNEL = "scan_qr_code"
    var flutterViewController: FlutterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let flutterAppDelegate = UIApplication.shared.delegate as? FlutterAppDelegate {
            flutterViewController = flutterAppDelegate.window?.rootViewController as? FlutterViewController
        }
        
        let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: flutterViewController!.binaryMessenger)
        
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "processQRImage" {
                guard let args = call.arguments as? [String: Any],
                      let base64Image = args["imageData"] as? String,
                      let imageBytes = Data(base64Encoded: base64Image) else {
                    result(FlutterError(code: "invalid_argument", message: "Invalid arguments", details: nil))
                    return
                }
                
                // Giải mã mã QR từ ảnh
                let qrResult = self?.decodeQRImage(imageBytes: imageBytes)
                result(qrResult)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    public func decodeQRImage(imageBytes: Data)-> String {
        guard let ciImage = CIImage(data: imageBytes) else {
            print("Failed to create CIImage from UIImage.")
            return "-1"
        }
        
        let options: [String: Any] = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: options) else {
            print("Failed to create QR code detector.")
            return "-1"
        }
        
        let features = detector.features(in: ciImage)
        for feature in features {
            if let qrCodeFeature = feature as? CIQRCodeFeature {
                let qrCodeContent = qrCodeFeature.messageString
                return qrCodeContent ?? ""
            }else {
                return "-1"
            }
        }
        return "-1"
    }

    //    public func decodeQRImage(imageBytes: Data) -> String {
    //        guard let ciImage = CIImage(data: imageBytes) else {
    //            return "-1"
    //        }
    //
    //        // Tạo CIFilter cho việc giải mã mã QR
    //        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
    //        let features = detector?.features(in: ciImage)
    //
    //        if let firstFeature = features?.first as? CIQRCodeFeature,
    //           let qrText = firstFeature.messageString {
    //            return qrText
    //        } else {
    //            return "-1"
    //        }
    //    }
}
