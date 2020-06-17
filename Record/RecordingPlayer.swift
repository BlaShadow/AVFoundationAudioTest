//
//  RecordingPlayer.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/14/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

class RecordingPlayer: NSObject {
  let disposeBag = DisposeBag()
  var lastRecordingUrl: URL?
  var lastRecording: Recording?
  var statusTimer: Disposable?
  
  var audioRecorder: AVAudioRecorder?
  var playerStatusReactive = BehaviorRelay<RecordingPlayerStatus>(value: .iddle)
  var currentRecordingTime: ((_ time: Int) -> Void)?

  override init() {
    super.init()

    self.setupRecorder()

    self.playerStatusReactive
    .subscribe(onNext: { (status) in
      if status == .startRecording || status == .startPlaying {
        self.statusTimer = Observable<Int>.interval(DispatchTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
          .subscribe(onNext: { (thousandMilliSeconds) in
            if let handler = self.currentRecordingTime {
              handler(thousandMilliSeconds * 100)
            }
          })
      } else {
        self.statusTimer?.dispose()
        self.statusTimer = nil
      }
    })
    .disposed(by: self.disposeBag)
  }
  
  private func setupRecorder() {
    let recordSettings: [String: Any] = [
      AVFormatIDKey: Int(kAudioFormatLinearPCM),
      AVSampleRateKey: 44100.0,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]

    do {
      guard let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return
      }
      
      self.lastRecordingUrl = documentsPathURL.appendingPathComponent("\(Date.timeIntervalSinceReferenceDate).pcm")

      audioRecorder = try AVAudioRecorder(url: self.lastRecordingUrl!, settings: recordSettings)
      audioRecorder?.delegate = self
      audioRecorder?.isMeteringEnabled = true
      audioRecorder?.prepareToRecord()
    } catch {
    }
  }
  
  func startRecording() {
    self.setupRecorder()
    self.playerStatusReactive.accept(.startRecording)
    
    audioRecorder?.record()
  }
  
  private func meter() -> Float {
    self.audioRecorder?.updateMeters()

    return ((self.audioRecorder?.averagePower(forChannel: 0) ?? 0) + Float(160.0)) / Float(160) * Float(1.5)
  }
  
  func stopRecording() {
    self.playerStatusReactive.accept(.stopRecording)
    self.playerStatusReactive.accept(.iddle)

    self.audioRecorder?.stop()
  }
  
  func clearLastRecording() {
    self.lastRecording = nil
    self.lastRecordingUrl = nil

    self.playerStatusReactive.accept(.iddle)
  }
}

extension RecordingPlayer: AVAudioRecorderDelegate {
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if flag, let url = self.lastRecordingUrl {
      
      do {
        let player = try? AVAudioPlayer(contentsOf: recorder.url)
        let duration = player?.duration ?? 0.0
        let name = "Recording"

        self.lastRecording = Recording()

        self.lastRecording?.name = name
        self.lastRecording?.path = url.absoluteString
        self.lastRecording?.duration = duration
      } catch {
        print("Error finish recording \(error)")
      }
    }
  }
}
