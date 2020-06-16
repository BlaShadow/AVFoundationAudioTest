//
//  RecordViewController.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/14/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

class RecordViewController: UIViewController {
  var recordView: RecordView?
  let disposeBag = DisposeBag()
  var recordingPlayer: RecordingPlayer?
  var audioPlayer = AudioPlayer()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.recordingPlayer = RecordingPlayer()
    self.recordingPlayer?.currentRecordingTime = self.updateRecordingTime
    self.recordView = RecordView(frame: .zero)
    self.audioPlayer.playingStatus = self.playingStatus
    
    if let view = self.recordView {
      self.view.addSubview(view)

      NSLayoutConstraint.activate([
        view.widthAnchor.constraint(equalTo: self.view.widthAnchor),
        view.heightAnchor.constraint(equalTo: self.view.heightAnchor),
        view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
      ])

      view.recordButton.rx.tapGesture()
        .when(.recognized)
        .subscribe(onNext: { _ in

          if self.recordingPlayer?.playerStatusReactive.value == RecordingPlayerStatus.iddle {
            self.recordingPlayer?.startRecording()
            self.recordView?.hidePlayerView()
            self.recordView?.isRecording(true)
          } else if self.recordingPlayer?.playerStatusReactive.value == RecordingPlayerStatus.startRecording {
            self.recordView?.showPlayerView()
            self.recordingPlayer?.stopRecording()
            self.recordView?.isRecording(false)
          }
        })
        .disposed(by: self.disposeBag)
      
      view.playPauseButton.rx.tapGesture()
        .when(.recognized)
        .subscribe { (_) in
          if let url = self.recordingPlayer?.lastRecordingUrl {
            switch self.audioPlayer.playerStatus.value {
            case .iddle:
              self.audioPlayer.play(url: url)
            case .pause:
              self.audioPlayer.resume()
            case .playing:
              self.audioPlayer.pause()
            }
            
          }
      }
      .disposed(by: self.disposeBag)
    }
    
    self.audioPlayer.playerStatus
      .subscribe(onNext: { (status) in
        switch status {
        case .iddle:
          self.recordView?.isPlaying(false)
        case .pause:
          self.recordView?.isPlaying(false)
        case .playing:
          self.recordView?.isPlaying(true)
        }
      })
      .disposed(by: self.disposeBag)
  }

  private func updateRecordingTime(_ recordingTime: Int) {
    self.recordView?.timerLabel.text = self.parseTime(milliSeconds: recordingTime)
  }
  
  private func playingStatus(_ currentTime: TimeInterval, _ totalTime: TimeInterval) {
    let percentage = Float(currentTime / totalTime)

    self.recordView?.updateProgressPlaying(progress: percentage)
  }
 
  private func parseTime(milliSeconds: Int) -> String {
    let seconds = milliSeconds / 1000
    let remainMilliSeconds = milliSeconds % 1000

    return "\(seconds).\(String(remainMilliSeconds).padding(toLength: 3, withPad: "000", startingAt: 0))"
  }
}
