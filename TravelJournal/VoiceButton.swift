//
//  VoiceButton.swift
//  TravelJournal
//
//  Created by kimia asadzadeh on 15/10/24.
//
//
//  VoiceRecorder.swift
//  TravelJournal
//
//  Created by kimia asadzadeh on 15/10/24.
//

import Foundation
import AVFoundation

class VoiceButton: ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    @Published var isRecording = false

    func startRecording() {
        let fileURL = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("Failed to start recording: \(error)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


