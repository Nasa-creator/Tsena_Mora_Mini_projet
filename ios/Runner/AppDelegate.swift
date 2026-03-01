import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    <!-- GOOGLE MAPS API KEY -->
    GMSServices.provideAPIKey("AIzaSyD4Pg0bGOWNdm5W66RI6bTNACf-YQv4bnQ")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
