import Flutter
import UIKit
import SceneKit
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
            GeneratedPluginRegistrant.register(with: registry)
        }

        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        }
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.example.usdz_renderer", binaryMessenger: controller.binaryMessenger)

        channel.setMethodCallHandler { [weak self] call, result in
          if call.method == "renderUsdToPng",
             let args = call.arguments as? [String:Any],
             let urlString = args["url"] as? String {
            self?.renderUsdToPng(urlString: urlString) { path, error in
              if let path = path {
                result(path) // returns file path string to Flutter
              } else {
                result(FlutterError(code: "RENDER_ERROR", message: error?.localizedDescription, details: nil))
              }
            }
          } else {
            result(FlutterMethodNotImplemented)
          }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      }

       func renderUsdToPng(urlString: String, completion: @escaping (String?, Error?)->Void) {
          guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "InvalidURL", code: -1, userInfo: nil)); return
          }

          // 1) Download
          URLSession.shared.downloadTask(with: url) { localURL, _, err in
            if let err = err { completion(nil, err); return }
            guard let localURL = localURL else { completion(nil, NSError(domain:"Download",code:-2,userInfo:nil)); return }

            // copy to temp with .usdz extension
            let tmp = FileManager.default.temporaryDirectory
            let dest = tmp.appendingPathComponent("temp.usdz")
            try? FileManager.default.removeItem(at: dest)
            do {
              try FileManager.default.copyItem(at: localURL, to: dest)
            } catch {
              completion(nil, error); return
            }

            // 2) Render on main thread using SceneKit
            DispatchQueue.main.async {
              do {
                // load the USDZ (SceneKit can load .usdz directly)
                let scene = try SCNScene(url: dest, options: nil)

                // create an off-screen SCNView
                let size = CGSize(width: 1024, height: 1024) // adjust resolution
                let scnView = SCNView(frame: CGRect(origin: .zero, size: size))
                scnView.scene = scene
                scnView.backgroundColor = UIColor.white
                scnView.autoenablesDefaultLighting = true
                scnView.allowsCameraControl = false

                // ensure there is a camera (if model lacks one)
                if scene.rootNode.childNodes.first(where: { $0.camera != nil }) == nil {
                  let cameraNode = SCNNode()
                  cameraNode.camera = SCNCamera()
                  cameraNode.position = SCNVector3(0, 0, 5) // tweak as needed
                  scene.rootNode.addChildNode(cameraNode)
                }

                // snapshot
                let image = scnView.snapshot()
                guard let png = image.pngData() else {
                  completion(nil, NSError(domain:"PNG",code:-3,userInfo:nil)); return
                }

                let out = tmp.appendingPathComponent("astronaut.png")
                try? FileManager.default.removeItem(at: out)
                try png.write(to: out)

                completion(out.path, nil)
              } catch {
                completion(nil, error)
              }
            }
          }.resume()
        }
    }
