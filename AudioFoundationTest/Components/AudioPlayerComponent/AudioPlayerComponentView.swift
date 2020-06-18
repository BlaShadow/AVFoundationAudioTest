//
//  AudioPlayerComponentView.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/17/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit

class AudioPlayerComponentView: UIView {
  let playingContainer: UIView = {
    let view = UIView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false

    return view
  }()
  
  let playingLabelStatus: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .right
    label.font = UIFont(name: FontNames.Montserrat.light, size: 12)

    return label
  }()
  
  let playButton: UIView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.image = UIImage(named: "play")
    view.highlightedImage = UIImage(named: "pause")
    view.isUserInteractionEnabled = true

    return view
  }()

  let playingTrack: PlayingTrack = PlayingTrack()
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    self.translatesAutoresizingMaskIntoConstraints = false

    self.setupView()
  }

  private func setupView() {
    self.layer.cornerRadius = 10
    self.clipsToBounds = true
    self.backgroundColor = UIColor.green
    
    self.addSubview(self.playingContainer)
    
    NSLayoutConstraint.activate([
      self.playingContainer.widthAnchor.constraint(equalTo: self.widthAnchor),
      self.playingContainer.heightAnchor.constraint(equalToConstant: 50),
      self.playingContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.playingContainer.topAnchor.constraint(equalTo: self.topAnchor)
    ])
    
    self.playingContainer.addSubview(self.playButton)
    
    NSLayoutConstraint.activate([
      self.playButton.widthAnchor.constraint(equalToConstant: 20),
      self.playButton.heightAnchor.constraint(equalToConstant: 20),
      self.playButton.centerYAnchor.constraint(equalTo: self.playingContainer.centerYAnchor),
      self.playButton.leftAnchor.constraint(equalTo: self.playingContainer.leftAnchor, constant: 10)
    ])
    
    self.playingContainer.addSubview(self.playingTrack)
    
    NSLayoutConstraint.activate([
      self.playingTrack.leftAnchor.constraint(equalTo: self.playButton.rightAnchor, constant: 10),
      self.playingTrack.heightAnchor.constraint(equalToConstant: 8),
      self.playingTrack.centerYAnchor.constraint(equalTo: self.playingContainer.centerYAnchor),
      self.playingTrack.rightAnchor.constraint(equalTo: self.playingContainer.rightAnchor, constant: -10)
    ])
    
    self.playingContainer.addSubview(self.playingLabelStatus)
    
    NSLayoutConstraint.activate([
      self.playingLabelStatus.widthAnchor.constraint(equalToConstant: 100),
      self.playingLabelStatus.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
      self.playingLabelStatus.topAnchor.constraint(equalTo: self.playingTrack.bottomAnchor, constant: 0),
      self.playingLabelStatus.rightAnchor.constraint(equalTo: self.playingTrack.rightAnchor, constant: 0)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func updateProgressPlaying(total: TimeInterval, currentTime: TimeInterval) {
    let progress = currentTime == 0 ? Float(0.0) : Float(currentTime / total)
    let currentTime = currentTime.parseTimeSeconds()
    let totalTime = total.parseTimeSeconds()

    self.playingLabelStatus.text = "\(currentTime) / \(totalTime)"
    self.playingTrack.updateProgress(progress: progress)
   }
}
