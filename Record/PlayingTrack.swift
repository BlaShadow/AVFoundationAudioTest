//
//  PlayingTrack.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/16/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit

class PlayingTrack: UIView {
  private let progressTrack: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.red
    view.frame = CGRect.zero

    return view
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = UIColor.lightGray
    
    self.addSubview(self.progressTrack)
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    let height = self.bounds.size.height

    self.layer.cornerRadius = height / 2
  }
  
  public func updateProgress(progress: Float) {
    let width = self.bounds.width * CGFloat(progress)
    let height = self.bounds.height

    self.progressTrack.frame = CGRect(x: 0, y: 0, width: width, height: height)
    self.progressTrack.layer.cornerRadius = height / 2
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
