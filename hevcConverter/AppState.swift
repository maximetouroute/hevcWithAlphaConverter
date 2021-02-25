import Foundation

class MyAppState: ObservableObject {
    @Published var filesToConvert = [MediaFile]()
}

struct MediaFile: Identifiable, Equatable {
    let id = UUID()
    let url: URL
    var convertProgress: Float = 0.0
    var convertMessage: String = "none"
    
    static func ==(lhs: MediaFile, rhs: MediaFile) -> Bool {
        return lhs.id == rhs.id
    }
}

let NOTIFICATION_KEY_CONVERT_PROGRESSION = Notification.Name("ConvertProgression")
