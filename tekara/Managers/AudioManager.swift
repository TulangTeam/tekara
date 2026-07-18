//
//  AudioManager.swift
//  tekara
//
//  Created by Claude on 18/07/26.
//

import AVFoundation

@Observable
class AudioManager {
    static let shared = AudioManager()

    private var backgroundMusicPlayer: AVAudioPlayer?
    private var currentSong: String?
    var isMuted: Bool = false {
        didSet {
            if isMuted {
                backgroundMusicPlayer?.volume = 0
            } else {
                backgroundMusicPlayer?.volume = 0.5
            }
            UserDefaults.standard.set(isMuted, forKey: "isMuted")
        }
    }

    private init() {
        isMuted = UserDefaults.standard.bool(forKey: "isMuted")
        setupAudioSession()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }

    func playBackgroundMusic(named filename: String) {
        // If same song is already loaded, do nothing
        if currentSong == filename {
            return
        }

        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Audio file not found: \(filename)")
            return
        }

        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1
            backgroundMusicPlayer?.volume = isMuted ? 0 : 0.5
            backgroundMusicPlayer?.prepareToPlay()
            backgroundMusicPlayer?.play()
            currentSong = filename
        } catch {
            print("Failed to play background music: \(error)")
        }
    }

    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
        currentSong = nil
    }

    func pauseBackgroundMusic() {
        backgroundMusicPlayer?.pause()
    }

    func resumeBackgroundMusic() {
        if !isMuted {
            backgroundMusicPlayer?.play()
        }
    }

    func toggleMute() {
        isMuted.toggle()
    }
}
