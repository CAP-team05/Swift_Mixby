//
//  SoundManager.swift
//  mixby2
//
//  Created by Anthony on 12/11/24.
//

import AVFoundation

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    private var audioPlayer: AVAudioPlayer?
    private var completionHandler: (() -> Void)?

    func playSound(fileName: String, fileType: String, folder: String? = nil, volume: Float = 1.0, completion: (() -> Void)? = nil) {
        self.completionHandler = completion

        if let soundURL = Bundle.main.url(forResource: fileName, withExtension: fileType, subdirectory: folder) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.volume = volume
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                // print("Playing sound: \(fileName).\(fileType)")
            } catch {
                // print("Error playing sound: \(error.localizedDescription)")
            }
        } else {
            print("Sound file not found.")
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // print("Sound finished playing.")
        completionHandler?()
    }
}
