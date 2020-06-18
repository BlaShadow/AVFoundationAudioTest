//
//  RecordingsCollectionView.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/8/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit

class RecordingsCollectionView: UIView {
  private let playerHeight: CGFloat = CGFloat(70)
  private var audioPlayerbottomConstraint: NSLayoutConstraint?

  var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical

    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor(rgb: 0xEEEFF0)
    view.showsVerticalScrollIndicator = false

    return view
  }()

  let playerView = AudioPlayerComponent(frame: .zero)

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.translatesAutoresizingMaskIntoConstraints = false

    self.setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {
    self.addSubview(self.collectionView)

    NSLayoutConstraint.activate([
      self.collectionView.widthAnchor.constraint(equalTo: self.widthAnchor),
      self.collectionView.heightAnchor.constraint(equalTo: self.heightAnchor),
      self.collectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      self.collectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])

    self.addSubview(self.playerView)

    self.audioPlayerbottomConstraint = self.playerView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                                               constant: self.playerHeight)
    self.audioPlayerbottomConstraint?.isActive = true

    NSLayoutConstraint.activate([
      self.playerView.heightAnchor.constraint(equalToConstant: self.playerHeight),
      self.playerView.widthAnchor.constraint(equalTo: self.widthAnchor),
      self.playerView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
  }

  public func displayAudioPlayer() {
    UIView.animate(withDuration: 0.3) {
      self.audioPlayerbottomConstraint?.constant = 0
      self.layoutIfNeeded()
    }
  }

  public func hideAudioPlayer() {
    UIView.animate(withDuration: 0.3) {
      self.audioPlayerbottomConstraint?.constant = self.playerHeight
      self.layoutIfNeeded()
    }
  }
}
