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
    view.image = UIImage(named: "play")?.withRenderingMode(.alwaysTemplate)
    view.tintColor = UIColor.white
    view.highlightedImage = UIImage(named: "pause")?.withRenderingMode(.alwaysTemplate)
    
    let container = UIView(frame: .zero)
    container.translatesAutoresizingMaskIntoConstraints = false
    container.isUserInteractionEnabled = true
    container.backgroundColor = UIColor(rgb: 0x7641ca)
    container.layer.cornerRadius = 20

    container.addSubview(view)
    NSLayoutConstraint.size(view: view, width: 20, height: 20)
    NSLayoutConstraint.centerInParent(view: view)
    

    return container
  }()

  let playingTrack: PlayingTrack = PlayingTrack()
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    self.translatesAutoresizingMaskIntoConstraints = false

    self.setupView()
  }

  private func setupView() {
    self.clipsToBounds = true
    self.backgroundColor = UIColor(rgb: 0xcde6a5)
    
    self.addSubview(self.playingContainer)
    
    NSLayoutConstraint.activate([
      self.playingContainer.widthAnchor.constraint(equalTo: self.widthAnchor),
      self.playingContainer.heightAnchor.constraint(equalToConstant: 50),
      self.playingContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.playingContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
    
    self.playingContainer.addSubview(self.playButton)
    
    NSLayoutConstraint.activate([
      self.playButton.widthAnchor.constraint(equalToConstant: 40),
      self.playButton.heightAnchor.constraint(equalToConstant: 40),
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
    var progress = currentTime == 0 ? Float(0.0) : Float(currentTime / total)
    
    if progress > Float(0.98) {
      progress = Float(1.0)
    }
    
    let currentTime = currentTime.parseTimeSeconds()
    let totalTime = total.parseTimeSeconds()

    self.isPlaying(value: progress > Float(0) && progress < Float(0.98))
    self.playingLabelStatus.text = "\(currentTime) / \(totalTime)"
    self.playingTrack.updateProgress(progress: progress)
   }

  public func isPlaying(value: Bool) {
    if let imageView = self.playButton.subviews.first as? UIImageView {
      imageView.isHighlighted = value
    }
  }
}
