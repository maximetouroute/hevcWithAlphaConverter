import AppKit
import Foundation
import AVFoundation
import VideoToolbox
import CoreImage

// Extension to convert status enums to strings for printing.
extension AVAssetExportSession.Status: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown: return "unknown"
        case .waiting: return "waiting"
        case .exporting: return "exporting"
        case .completed: return "completed"
        case .failed: return "failed"
        case .cancelled: return "cancelled"
        @unknown default: return "\(rawValue)"
        }
    }
}

func exportToHEVCWithAlphaAsynchronously(sourceURL: URL,
                                         destinationURL: URL,
                                         handleExportCompletion:
                                            @escaping (_ status: AVAssetExportSession.Status) -> Void,
                                         handleProgress: @escaping (_ progress: Float ) -> Void) {
    let asset = AVAsset(url: sourceURL)
    print(asset.duration)
    AVAssetExportSession.determineCompatibility(ofExportPreset: AVAssetExportPresetHEVCHighestQualityWithAlpha, with: asset, outputFileType: .mov) {
        compatible in if compatible {
            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHEVCHighestQualityWithAlpha) else {
                print("Failed to create export session to HEVC with alpha")
                handleExportCompletion(.failed)
                return
            }
            DispatchQueue.main.async {
             let t = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                // Get Progress
                    let progress = Float((exportSession.progress));

                print("Progress: ", progress*100,"%", exportSession.status );
                if (progress < 0.99) {
                    handleProgress(progress)

                } else {
                    timer.invalidate()
                }
                if(exportSession.status == .failed) {
                    timer.invalidate()
                }
              }
            }
            // Export
            exportSession.outputURL = destinationURL
            exportSession.outputFileType = .mov
            exportSession.exportAsynchronously {
                print("completed??")
                handleExportCompletion(exportSession.status)
                print(exportSession.error)

            }
        } else {
            print("Export Session failed compatibility check")
            handleExportCompletion(.failed)
        }
    }
}
