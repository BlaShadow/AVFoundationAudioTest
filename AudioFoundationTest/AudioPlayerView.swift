//
//  AudioPlayerView.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/8/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit

class AudioPlayerView: UIView {

  var controlsContainer: UIView = {
    let view = UIView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.gray
    view.layer.cornerRadius = 10

    return view
  }()

  var recordbutton: UIView = {
    let imageView = UIImageView(image: UIImage(named: "stop"))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.highlightedImage = UIImage(named: "loop")

    let container = UIView(frame: .zero)
    container.addSubview(imageView)
    container.translatesAutoresizingMaskIntoConstraints = false
    container.isUserInteractionEnabled = true

    NSLayoutConstraint.activate([
      imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
      imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor)
    ])

    return container
  }()

  var playPauseButton: UIView = {
    let imageView = UIImageView(image: UIImage(named: "play"))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.highlightedImage = UIImage(named: "pause")

    let container = UIView(frame: .zero)
    container.addSubview(imageView)
    container.translatesAutoresizingMaskIntoConstraints = false
    container.isUserInteractionEnabled = true

    NSLayoutConstraint.activate([
      imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
      imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor)
    ])

    return container
  }()

  var statusLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.backgroundColor = UIColor.blue
    label.numberOfLines = 0

    return label
  }()

  var recordings = RecordingsCollectionView(frame: .zero)

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.translatesAutoresizingMaskIntoConstraints = false

    setupViews()
  }

  private func setupViews() {
    self.addSubview(controlsContainer)

    let guide = self.safeAreaLayoutGuide

    NSLayoutConstraint.activate([
      controlsContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
      controlsContainer.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20),
      controlsContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      guide.bottomAnchor.constraint(equalTo: self.controlsContainer.bottomAnchor, constant: 20)
    ])

    self.controlsContainer.addSubview(self.playPauseButton)

    NSLayoutConstraint.activate([
      self.playPauseButton.widthAnchor.constraint(equalTo: self.controlsContainer.widthAnchor,
                                                  multiplier: 0.5,
                                                  constant: -10),
      self.playPauseButton.heightAnchor.constraint(equalToConstant: 100),
      self.playPauseButton.leftAnchor.constraint(equalTo: self.controlsContainer.leftAnchor, constant: 10),
      self.playPauseButton.topAnchor.constraint(equalTo: self.controlsContainer.topAnchor, constant: 10),
      self.playPauseButton.bottomAnchor.constraint(equalTo: self.controlsContainer.bottomAnchor, constant: -10)
    ])

    self.controlsContainer.addSubview(self.recordbutton)

    NSLayoutConstraint.activate([
      self.recordbutton.widthAnchor.constraint(equalTo: self.controlsContainer.widthAnchor,
                                               multiplier: 0.5,
                                               constant: -10),
      self.recordbutton.heightAnchor.constraint(equalToConstant: 100),
      self.recordbutton.rightAnchor.constraint(equalTo: self.controlsContainer.rightAnchor, constant: 10),
      self.recordbutton.topAnchor.constraint(equalTo: self.controlsContainer.topAnchor, constant: 10),
      self.recordbutton.bottomAnchor.constraint(equalTo: self.controlsContainer.bottomAnchor, constant: -10)
    ])

    self.addSubview(self.statusLabel)

    NSLayoutConstraint.activate([
      self.statusLabel.widthAnchor.constraint(equalTo: self.controlsContainer.widthAnchor),
      self.statusLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
      self.statusLabel.centerXAnchor.constraint(equalTo: self.controlsContainer.centerXAnchor),
      self.statusLabel.bottomAnchor.constraint(equalTo: self.controlsContainer.topAnchor, constant: -10)
    ])

    self.addSubview(self.recordings)

    NSLayoutConstraint.activate([
      self.recordings.widthAnchor.constraint(equalTo: self.widthAnchor),
      self.recordings.topAnchor.constraint(equalTo: self.topAnchor),
      self.recordings.bottomAnchor.constraint(equalTo: self.statusLabel.topAnchor),
      self.recordings.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
  }

  func recordButtonHighlighted(value: Bool) {
    if let imageView = self.recordbutton.subviews.first as? UIImageView {
      imageView.isHighlighted = value
    }
  }

  func scaleRecordbutton(value: Float) {
    self.recordbutton.transform = CGAffineTransform.init(scaleX: CGFloat(value), y: CGFloat(value))
  }

  func startAnimatingRecordButton() {
    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotationAnimation.toValue = 2 * Double.pi
    rotationAnimation.duration = 2.0
    rotationAnimation.repeatCount = Float.infinity

    self.recordbutton.layer.add(rotationAnimation, forKey: "rotationAnimation")
  }

  func stopAnimatingRecordButton() {
    self.recordbutton.layer.removeAnimation(forKey: "rotationAnimation")
  }

  func updateStatus(value: String) {
    self.statusLabel.text = value
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
