//
//  LayoutConstraintHelper.swift
//  AudioFoundationTest
//
//  Created by Luis Romero on 6/17/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
  static func fillAndCenterInParent(parent: UIView, view: UIView) {
    parent.addSubview(view)

    NSLayoutConstraint.activate([
      view.widthAnchor.constraint(equalTo: parent.widthAnchor),
      view.heightAnchor.constraint(equalTo: parent.heightAnchor),
      view.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
      view.centerYAnchor.constraint(equalTo: parent.centerYAnchor)
    ])
  }
}
