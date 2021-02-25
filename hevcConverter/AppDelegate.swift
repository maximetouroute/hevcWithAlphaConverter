import Cocoa
import SwiftUI

@available(OSX 11.0, *)
@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let appState = MyAppState();
        let contentView = ContentView().environmentObject(appState)

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        
//        NSLog("go for a run");
//        // Here, run an hevc job ?
//        // Export Use-cases
//        let pendingExports = DispatchGroup()
//
//        // 1.From Apple ProRes 4444 to HEVC-with-Alpha
//
//        let sourceProRes = Bundle.main.url(forResource: "puppets_with_alpha_prores", withExtension: "mov")! // This works
//
////        let sourceProRes = URL(fileURLWithPath: "puppets_with_alpha_prores.mov") // this doesn't
//        print(sourceProRes)
//        
////    let sourceProRes = URL(fileURLWithPath: "/tmp/puppets_with_alpha_prores.mov")
//        print(sourceProRes)
//        let destinationHEVCWithAlpha = URL(fileURLWithPath: "/tmp/test.mov")
//        try? FileManager.default.removeItem(at: destinationHEVCWithAlpha)
//        pendingExports.enter()
//        exportToHEVCWithAlphaAsynchronously(sourceURL: sourceProRes, destinationURL: destinationHEVCWithAlpha) { status in
//            if status == .completed {
//                print ("Exported \(sourceProRes) to \(destinationHEVCWithAlpha) successfully")
//            } else {
//                print ("Export from \(sourceProRes) to \(destinationHEVCWithAlpha) failed with status: \(status)")
//            }
//            pendingExports.leave()
//        }
//    pendingExports.wait()
//    print("All Done.")
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

