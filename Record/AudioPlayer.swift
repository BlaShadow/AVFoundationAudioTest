//
//  AudioPlayer.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/14/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

class AudioPlayer: NSObject {
  private var audioPlayer: AVAudioPlayer?
  private let disposeBag = DisposeBag()
  private var playingStatusInterval: Disposable?

  var playerStatus = BehaviorRelay<AudioPlayerStatus>(value: .iddle)
  var playingStatus: ((_ currentTime: TimeInterval, _ totalTime: TimeInterval) -> Void)?

  override init() {
    super.init()
    
    self.playerStatus.subscribe(onNext: { (status) in
      switch status {
      case .iddle:
        self.playingStatusInterval?.dispose()
      case .pause:
        self.playingStatusInterval?.dispose()
      case .playing:
        self.playingStatusInterval = Observable<Int>
          .interval(.milliseconds(25), scheduler: MainScheduler.instance)
          .subscribe({ (_) in
            if let completion = self.playingStatus {
              completion(self.currentTimePlaying(), self.playerDuration())
            }
          })
      }
    }).disposed(by: self.disposeBag)
  }

  func play(url: URL) {
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: url)
      audioPlayer?.delegate = self
      audioPlayer?.volume = 1.0
      audioPlayer?.prepareToPlay()
      
      if (audioPlayer?.duration ?? 0.0) > 0.0 {
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        
        self.playerStatus.accept(.playing)
      }
    } catch {
      print("Error creating audio player")
    }
  }
  
  func pause() {
    self.audioPlayer?.pause()
    self.playerStatus.accept(.pause)
  }
  
  func resume() {
    self.audioPlayer?.play()
    self.playerStatus.accept(.playing)
  }
  
  func playerDuration() -> TimeInterval {
    return self.audioPlayer?.duration ?? 0.0
  }
  
  func currentTimePlaying() -> TimeInterval {
    return self.audioPlayer?.currentTime ?? 0.0
  }
}

extension AudioPlayer: AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    self.playerStatus.accept(.iddle)

    print("Playing got stopped")
  }
}

