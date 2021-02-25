import SwiftUI

@available(OSX 11.0, *)
struct ContentView: View {
    
    @EnvironmentObject var appState: MyAppState


    @State private var dragOver = false;
    private let pendingExports = DispatchGroup();

    var body: some View {
        VStack {
            if(appState.filesToConvert.count == 0) {
                Text("Drag And Drop your files !")
            } else
            {
                List(appState.filesToConvert) { fileToConvert in
                    Text("\(fileToConvert.url.absoluteString)\n \(fileToConvert.convertMessage)\n \(fileToConvert.convertProgress*100) %" )

                    Button("Convert") {
                        let index = appState.filesToConvert.firstIndex(of:fileToConvert)!;
                        let mediaFile = fileToConvert;
                        let inputUrl = mediaFile.url;
                        let urlWithoutExtension = inputUrl.deletingPathExtension()
                        let fileName = urlWithoutExtension.lastPathComponent
                        let fileNameWithExtra = fileName+"_hevc.mov"
                        let destinationHEVCWithAlpha = inputUrl.deletingLastPathComponent().appendingPathComponent(fileNameWithExtra)
                        print(destinationHEVCWithAlpha)

                        try? FileManager.default.removeItem(at: destinationHEVCWithAlpha)
                        appState.filesToConvert[index].convertMessage = "Converting...";
                        self.pendingExports.enter()
                        exportToHEVCWithAlphaAsynchronously(sourceURL: inputUrl, destinationURL: destinationHEVCWithAlpha, handleExportCompletion: { status in
                            if status == .completed {
                                appState.filesToConvert[index].convertMessage = "Exported \(inputUrl) to \(destinationHEVCWithAlpha) successfully";
                                print ("Exported \(inputUrl) to \(destinationHEVCWithAlpha) successfully")
                            } else {
                                appState.filesToConvert[index].convertMessage = "Export from \(inputUrl) to \(destinationHEVCWithAlpha) failed with status: \(status)";
                                print ("Export from \(inputUrl) to \(destinationHEVCWithAlpha) failed with status: \(status)")
                            }
                            self.pendingExports.leave()
                        }, handleProgress: { progress in
                            
                            
                            appState.filesToConvert[index].convertProgress = progress;
                           
//                            appState.fileToConvert.convertProgress = progress;
//                            print("CLOSURE Progress: \(progress*100)%" );
                        })
                        
                    }
                }
            }
        }
        .frame(width: 640, height: 720)
        .onDrop(of: ["public.file-url"], isTargeted: $dragOver) { providers -> Bool in
            providers.first?.loadDataRepresentation(forTypeIdentifier: "public.file-url", completionHandler: { (data, error) in
//                    NSLog("helo %@", data ?? <#default value#>);
                if let data = data, let path = NSString(data: data, encoding: 4), let url = URL(string: path as String) {
                    NSLog(path as String);

                    appState.filesToConvert.append(MediaFile(url:url))

                    }
            })
            return true
        }
//        .onDrag {
//            let data = self.image?.tiffRepresentation
//            let provider = NSItemProvider(item: data as NSSecureCoding?, typeIdentifier: kUTTypeTIFF as String)
//            provider.previewImageHandler = { (handler, _, _) -> Void in
//                handler?(data as NSSecureCoding?, nil)
//            }
//            return provider
//        }
        .border(dragOver ? Color.red : Color.blue)
    }
}


@available(OSX 11.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
