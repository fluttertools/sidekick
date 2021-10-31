import Cocoa
import FlutterMacOS
import bitsdojo_window_macos

class MainFlutterWindow: BitsdojoWindow {
  override func bitsdojo_window_configure() -> UInt {
    return BDW_CUSTOM_FRAME | BDW_HIDE_ON_STARTUP
  }
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    RegisterGeneratedPlugins(registry: flutterViewController)
    
    // Adding a NSVisualEffectView to act as a translucent background
    let contentView = contentViewController!.view;
    let superView = contentView.superview!;

    let blurView = NSVisualEffectView(frame: superView.bounds)
    blurView.autoresizingMask = [.width, .height]
    blurView.blendingMode = NSVisualEffectView.BlendingMode.behindWindow

    // Pick the correct material for the task
    blurView.material = NSVisualEffectView.Material.underWindowBackground

    // Replace the contentView and the background view
    superView.replaceSubview(contentView, with: blurView)
    blurView.addSubview(contentView)

    super.awakeFromNib()
  }
}