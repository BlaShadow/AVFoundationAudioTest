//
//  ViewController.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/8/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa
import RxGesture

enum PlayerStatus: String {
  case iddle
  case recording
  case playing
}

class ViewController: UIViewController {
  var audioRecorder: AVAudioRecorder?
  var audioPlayer: AVAudioPlayer?
  var lastRecordingUrl: URL?
  
  var playerView: AudioPlayerView?
  let disposeBag = DisposeBag()
  let recordingsDataSource = RecordingsDataSource()
  let layoutDelegate = RecordingsCollectionLayout()

  var playerStatusReactive = BehaviorRelay<PlayerStatus>(value: .iddle)
  var statusTimer: Disposable?
  var recordings: [Recording] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setupView()

    self.setupEvents()
  }
  
  private func setupEvents() {
    self.playerStatusReactive
      .subscribe(onNext: { (status) in
        if status == PlayerStatus.recording {
          self.playerView?.recordButtonHighlighted(value: true)
          self.playerView?.startAnimatingRecordButton()
        } else {
          self.playerView?.recordButtonHighlighted(value: false)
          self.playerView?.stopAnimatingRecordButton()
        }
        
        self.playerView?.updateStatus(value: "Current status \(status.rawValue)")
      })
      .disposed(by: self.disposeBag)
  }
  
  private func reloadData() {
    self.recordingsDataSource.items = self.recordings
    self.playerView?.recordings.collectionView.reloadData()
  }
  
  private func setupView() {
    let view = AudioPlayerView(frame: .zero)
    self.view.addSubview(view)
    
    NSLayoutConstraint.activate([
      view.widthAnchor.constraint(equalTo: self.view.widthAnchor),
      view.heightAnchor.constraint(equalTo: self.view.heightAnchor),
      view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
    ])

    view.recordings.collectionView.register(RecordingCollectionViewCell.self, forCellWithReuseIdentifier: "CELL")
    view.recordings.collectionView.dataSource = self.recordingsDataSource
    view.recordings.collectionView.delegate = self.layoutDelegate
    view.recordings.collectionView.reloadData()
    
    view.playPauseButton
      .rx
      .tapGesture()
      .when(.recognized).subscribe(onNext: { (gesture) in
        if self.playerStatusReactive.value != .iddle {
          return
        }

        self.animateView(view: view.playPauseButton)

        self.playLastRecording()
      })
      .disposed(by: self.disposeBag)
    
    view.recordbutton
      .rx
      .tapGesture()
      .when(.recognized)
      .subscribe(onNext: { (gesture) in
        self.animateView(view: view.recordbutton)
        
        let value = self.playerStatusReactive.value

        if value == .iddle {
          self.startRecording()
        } else if value == .recording {
          self.stopRecording()
        }
      })
      .disposed(by: self.disposeBag)
    
    
    self.playerStatusReactive
      .subscribe(onNext: { (status) in
        if status == .recording || status == .playing {
          self.statusTimer = Observable<Int>.interval(DispatchTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (thousandMilliSeconds) in
              
              self.playerView?.scaleRecordbutton(value: self.meter())
              self.playerView?.updateStatus(value: "\(self.playerStatusReactive.value.rawValue)\n\(self.parseTime(milliSeconds: thousandMilliSeconds * 100))")
            })
        } else {
          self.statusTimer?.dispose()
          self.statusTimer = nil
        }

      })
      .disposed(by: self.disposeBag)

    self.playerView = view
  }
  
  private func parseTime(milliSeconds: Int) -> String {
    let seconds = milliSeconds / 1000
    let remainMilliSeconds = milliSeconds % 1000
    
    return "\(seconds).\(String(remainMilliSeconds).padding(toLength: 3, withPad: "000", startingAt: 0))"
  }
  
  private func animateView(view: UIView) {
    UIView.animate(withDuration: 0.3, animations: {
      view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }) { (completed) in
      UIView.animate(withDuration: 0.2) {
        view.transform = CGAffineTransform.identity
      }
    }
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
        print("Unable to init audio recorder")
        return
      }
      
      self.lastRecordingUrl = documentsPathURL.appendingPathComponent("\(Date.timeIntervalSinceReferenceDate).pcm")

      audioRecorder = try AVAudioRecorder(url: self.lastRecordingUrl!, settings: recordSettings)
      audioRecorder?.delegate = self
      audioRecorder?.isMeteringEnabled = true
      audioRecorder?.prepareToRecord()

      print("Recorder created")
    } catch {
      print("Error creating audio recorder", error)
    }
  }
  
  private func startRecording() {
    self.setupRecorder()
    self.playerStatusReactive.accept(.recording)
    
    audioRecorder?.record()
  }
  
  private func meter() -> Float {
    self.audioRecorder?.updateMeters()

    return ((self.audioRecorder?.averagePower(forChannel: 0) ?? 0) + Float(160.0)) / Float(160) * Float(1.5)
  }
  
  private func stopRecording() {
    self.playerStatusReactive.accept(.iddle)
    
    audioRecorder?.stop()
  }
  
  private func playLastRecording() {
    do {
      if let url = lastRecordingUrl {
        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer?.delegate = self
        
        if (audioPlayer?.duration ?? 0.0) > 0.0 {
          self.playerStatusReactive.accept(.playing)

          audioPlayer?.play()
        }
      }
    } catch {
    }
  }
}

extension ViewController: AVAudioRecorderDelegate {
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if flag, let url = self.lastRecordingUrl {
      let seconds = recorder.currentTime
      let name = "Recording"

      self.recordings.append(Recording(name: name, path: url, duration: seconds))
      self.reloadData()
    }
  }
}

extension ViewController: AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    self.playerStatusReactive.accept(.iddle)
  }
}
