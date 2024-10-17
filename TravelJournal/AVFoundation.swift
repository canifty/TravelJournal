//
//  AVFoundation.swift
//  TravelJournal
//
//  Created by kimia asadzadeh on 17/10/24.
//

import AVFoundation
import SwiftUI
import UIKit

var audioPlayer: AVAudioPlayer?
func playAudio(filename: String, fileType: String) {
    guard let url = Bundle.main.url(forResource: filename, withExtension: fileType) else {
        print("Audio file not found")
        return
    }

    do {
        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    } catch {
        print("Error playing audio: \(error.localizedDescription)")
    }
}
import SwiftUI
import UIKit

struct DocumentPicker: UIViewControllerRepresentable {
    var onPick: (URL?) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.onPick(urls.first)
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.onPick(nil)
        }
    }
}
