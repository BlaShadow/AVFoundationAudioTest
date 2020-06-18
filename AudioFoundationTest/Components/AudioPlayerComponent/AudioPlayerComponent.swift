//
//  AudioPlayerComponent.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/17/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

class AudioPlayerComponent: UIView {
  let componentView: AudioPlayerComponentView = AudioPlayerComponentView(frame: .zero)
  var audioPlayer: AudioPlayer = AudioPlayer()
  let disposeBag = DisposeBag()

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.translatesAutoresizingMaskIntoConstraints = false

    // Setup events
    self.setupEvents()
    
    // Setup views
    self.setupView()
  }
  
  private func setupEvents() {
    self.componentView.playButton.rx
      .tapGesture()
      .when(.recognized)
      .subscribe { (_) in
        switch self.audioPlayer.playerStatus.value {
        case .iddle:
          self.audioPlayer.play()
        case .playing:
          self.audioPlayer.pause()
        case .pause:
          self.audioPlayer.resume()
        }
      }
      .disposed(by: self.disposeBag)
    
    self.audioPlayer.playingStatus = self.playingStatusCallback
  }
  
  func setupPlayer(url urlString: String) {
    if let url = URL(string: urlString) {
      self.audioPlayer.prepare(url: url)
      self.componentView.updateProgressPlaying(total: self.audioPlayer.playerDuration(), currentTime: 0)
    }
  }
  
  private func playingStatusCallback(_ currentTime: TimeInterval, _ totalTime: TimeInterval) {
    self.componentView.updateProgressPlaying(total: totalTime, currentTime: currentTime)
  }

  private func setupView() {
    NSLayoutConstraint.fillAndCenterInParent(parent: self, view: self.componentView)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
