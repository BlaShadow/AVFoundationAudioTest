//
//  RecordView.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/14/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit

class RecordView: UIView {
  let recordButton: UIView = {
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false
    container.isUserInteractionEnabled = true
    container.backgroundColor = UIColor.red
    container.layer.cornerRadius = 75.0
    container.layer.shadowOffset = CGSize(width: 2, height: 2)
    container.layer.shadowRadius = 1.0
    container.layer.shadowOpacity = 0.3
    
    let recordImage = UIImageView(image: UIImage(named: "record"))
    recordImage.translatesAutoresizingMaskIntoConstraints = false
    recordImage.highlightedImage = UIImage(named: "pause")
    
    container.addSubview(recordImage)
    
    NSLayoutConstraint.activate([
      recordImage.widthAnchor.constraint(equalToConstant: 40),
      recordImage.heightAnchor.constraint(equalToConstant: 40),
      recordImage.centerXAnchor.constraint(equalTo: container.centerXAnchor),
      recordImage.centerYAnchor.constraint(equalTo: container.centerYAnchor)
    ])

    return container
  }()
  
  let timerLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "00:00:00.000"
    label.font = UIFont(name: FontNames.Montserrat.light, size: 18)
    label.textAlignment = .center

    return label
  }()

  let gradientBackground = CAGradientLayer()
  let playerView = PlayerView(frame: .zero)
  var playerViewBottomConstraint: NSLayoutConstraint?
  
  var playPauseButton: UIView {
    return self.playerView.playButton
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.translatesAutoresizingMaskIntoConstraints = false

    self.setupViews()

    self.setupGradient()
  }

  public func setupGradient() {
    gradientBackground.colors = [
      UIColor.init(rgb: 0xFFFFFF).cgColor,
      UIColor.init(rgb: 0xF0F4FE).cgColor
    ]

    gradientBackground.startPoint = CGPoint(x: 0.0, y: 0.0)
    gradientBackground.endPoint = CGPoint(x: 0.0, y: 1.0)
    gradientBackground.locations = [0.0, 1.0]
    gradientBackground.frame = self.bounds
    
    self.layer.insertSublayer(gradientBackground, at: 0)
  }
  
  override func layoutSubviews() {
      super.layoutSubviews()

      gradientBackground.frame = bounds
  }
  
  private func setupViews() {
    self.addSubview(self.recordButton)

    NSLayoutConstraint.activate([
      self.recordButton.widthAnchor.constraint(equalToConstant: 150),
      self.recordButton.heightAnchor.constraint(equalToConstant: 150),
      self.recordButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.recordButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
    
    self.addSubview(self.timerLabel)
    
    NSLayoutConstraint.activate([
      self.timerLabel.widthAnchor.constraint(equalToConstant: 200),
      self.timerLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
      self.timerLabel.centerXAnchor.constraint(equalTo: self.recordButton.centerXAnchor),
      self.timerLabel.topAnchor.constraint(equalTo: self.recordButton.bottomAnchor, constant: 20)
    ])
    
    self.addSubview(self.playerView)

    self.playerViewBottomConstraint = self.playerView.bottomAnchor
      .constraint(equalTo: self.bottomAnchor, constant: 200)
    self.playerViewBottomConstraint?.isActive = true

    NSLayoutConstraint.activate([
      self.playerView.widthAnchor.constraint(equalTo: self.widthAnchor),
      self.playerView.heightAnchor.constraint(equalToConstant: 200),
      self.playerView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func isRecording(_ value: Bool) {
    if let imageView = self.recordButton.subviews.first as? UIImageView {
      imageView.isHighlighted = value
    }
  }
  
  public func isPlaying(_ value: Bool) {
    if let imageView = self.playPauseButton as? UIImageView {
      imageView.isHighlighted = value
    }
  }
  
  public func showPlayerView() {
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.3) {
        self.playerView.updateProgressPlaying(progress: 0.0)
        self.playerViewBottomConstraint?.constant = 10
        self.layoutIfNeeded()
      }
    }
  }
  
  public func hidePlayerView() {
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.3) {
        self.playerViewBottomConstraint?.constant = 200
        self.layoutIfNeeded()
      }
    }
  }
  
  public func updateProgressPlaying(progress: Float) {
    self.playerView.updateProgressPlaying(progress: progress)
  }
}
