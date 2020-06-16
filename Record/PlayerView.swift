//
//  PlayerView.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/14/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit

class PlayerView: UIView {
  
  let saveButton: UIView = {
    let view = UILabel(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor(rgb: 0x5E69D2)
    view.text = "Save"
    view.textAlignment = .center
    view.font = UIFont(name: FontNames.Montserrat.medium, size: 18)
    view.textColor = UIColor.white
    view.isUserInteractionEnabled = true
    view.layer.cornerRadius = 20.0
    view.clipsToBounds = true

    return view
  }()
  
  let deleteButton: UIView = {
    let view = UILabel(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.text = "Delete"
    view.textAlignment = .center
    view.font = UIFont(name: FontNames.Montserrat.medium, size: 18)
    view.textColor = UIColor.red
    view.isUserInteractionEnabled = true

    return view
  }()
  
  let playingContainer: UIView = {
    let view = UIView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false

    return view
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
    self.backgroundColor = UIColor.white
    
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

    self.addSubview(self.deleteButton)

    NSLayoutConstraint.activate([
      self.deleteButton.widthAnchor.constraint(equalToConstant: 100),
      self.deleteButton.heightAnchor.constraint(equalToConstant: 36),
      self.deleteButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
      self.deleteButton.topAnchor.constraint(equalTo: self.playingContainer.bottomAnchor, constant: 2)
    ])

    self.addSubview(self.saveButton)

    NSLayoutConstraint.activate([
      self.saveButton.widthAnchor.constraint(equalToConstant: 140),
      self.saveButton.heightAnchor.constraint(equalToConstant: 40),
      self.saveButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
      self.saveButton.topAnchor.constraint(equalTo: self.playingContainer.bottomAnchor, constant: 2)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func updateProgressPlaying(progress: Float) {
    self.playingTrack.updateProgress(progress: progress)
   }
}
