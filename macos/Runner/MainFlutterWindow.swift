import Cocoa
import FlutterMacOS
import bitsdojo_window_macos
import macos_window_utils

class MainFlutterWindow: BitsdojoWindow {
  override func bitsdojo_window_configure() -> UInt {
    return BDW_CUSTOM_FRAME | BDW_HIDE_ON_STARTUP
  }
  
  override func awakeFromNib() {
      let windowFrame = self.frame
      let macOSWindowUtilsViewController = MacOSWindowUtilsViewController()
      self.contentViewController = macOSWindowUtilsViewController
      self.setFrame(windowFrame, display: true)

      /* Initialize the macos_window_utils plugin */
      MainFlutterWindowManipulator.start(mainFlutterWindow: self)

      RegisterGeneratedPlugins(registry: macOSWindowUtilsViewController.flutterViewController)
    super.awakeFromNib()
  }
}
