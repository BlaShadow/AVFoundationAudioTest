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

    self.recordingPlayer?.playerStatusReactive.subscribe(onNext: { (status) in
      if status == .initial {
        self.recordView?.hidePlayerView()
        self.recordView?.resetTimer()
      }
    })
    .disposed(by: self.disposeBag)
    
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

          if self.recordingPlayer?.playerStatusReactive.value == RecordingPlayerStatus.initial {
            self.attempSaveLastRecording()
            self.recordingPlayer?.startRecording()
            self.recordView?.hidePlayerView()
            self.recordView?.isRecording(true)
          } else if self.recordingPlayer?.playerStatusReactive.value == RecordingPlayerStatus.startRecording {
            self.recordingPlayer?.stopRecording()

            // Prepare player to play
            if let url = self.recordingPlayer?.lastRecordingUrl {
              self.audioPlayer.prepare(url: url)
            }

            self.recordView?.showPlayerView(totalTime: self.audioPlayer.playerDuration())
            self.recordView?.isRecording(false)
          }
        })
        .disposed(by: self.disposeBag)
      
      view.playPauseButton.rx.tapGesture()
        .when(.recognized)
        .subscribe { (_) in
          switch self.audioPlayer.playerStatus.value {
          case .iddle:
            self.audioPlayer.play()
          case .pause:
            self.audioPlayer.resume()
          case .playing:
            self.audioPlayer.pause()
          }
      }
      .disposed(by: self.disposeBag)
      
      // Delete Current recording action
      view.deleteButton.rx.tapGesture()
        .when(.recognized)
        .subscribe { (_) in
          self.recordingPlayer?.clearLastRecording()
      }
      .disposed(by: self.disposeBag)
      
      // Save recording action
      view.saveButton.rx.tapGesture()
        .when(.recognized)
        .subscribe { (_) in
          self.attempSaveLastRecording()
          self.recordingPlayer?.clearLastRecording()
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
  
  private func attempSaveLastRecording() {
    if let recording = self.recordingPlayer?.lastRecording {
      // Last last recording
      DataBaseAcess.saveRecording(recording: recording)

      // Clear last recording references
      self.recordingPlayer?.clearLastRecording()
    }
  }

  private func updateRecordingTime(_ recordingTime: Int) {
    self.recordView?.timerLabel.text = Double(recordingTime).parseTime()
  }
  
  private func playingStatus(_ currentTime: TimeInterval, _ totalTime: TimeInterval) {
    self.recordView?.updateProgressPlaying(total: totalTime, currentTime: currentTime)
  }
}
