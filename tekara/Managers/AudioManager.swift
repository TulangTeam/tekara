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
    var isMusicMuted: Bool = false {
        didSet {
            if isMusicMuted {
                backgroundMusicPlayer?.volume = 0
            } else {
                backgroundMusicPlayer?.volume = 0.5
            }
            UserDefaults.standard.set(isMusicMuted, forKey: "isMusicMuted")
        }
    }
    var isSFXMuted: Bool = false {
        didSet {
            UserDefaults.standard.set(isSFXMuted, forKey: "isSFXMuted")
        }
    }

    var isMuted: Bool {
        get { isMusicMuted }
        set { isMusicMuted = newValue }
    }

    private init() {
        isMusicMuted = UserDefaults.standard.bool(forKey: "isMusicMuted")
        isSFXMuted = UserDefaults.standard.bool(forKey: "isSFXMuted")
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
            backgroundMusicPlayer?.volume = isMusicMuted ? 0 : 0.5
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
        if !isMusicMuted {
            backgroundMusicPlayer?.play()
        }
    }

    func toggleMusicMute() {
        isMusicMuted.toggle()
    }

    func toggleSFXMute() {
        isSFXMuted.toggle()
    }

    // MARK: - Sound Effects

    private var sfxPlayers: [String: AVAudioPlayer] = [:]

    func playSFX(named filename: String) {
        guard !isSFXMuted else { return }

        // Reuse existing player if available
        if let existingPlayer = sfxPlayers[filename] {
            existingPlayer.currentTime = 0
            existingPlayer.play()
            return
        }

        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("SFX file not found: \(filename)")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = 0.5
            player.prepareToPlay()
            player.play()
            sfxPlayers[filename] = player
        } catch {
            print("Failed to play SFX: \(error)")
        }
    }
}
