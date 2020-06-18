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
      view.heightAnchor.constraint(equalTo: parent.heightAnchor)
    ])

    NSLayoutConstraint.centerInParent(view: view)
  }

  static func size(view: UIView, width: CGFloat, height: CGFloat) {
    NSLayoutConstraint.activate([
      view.widthAnchor.constraint(equalToConstant: width),
      view.heightAnchor.constraint(equalToConstant: height)
    ])
  }

  static func centerInParent(view: UIView) {
    guard let parent = view.superview else {
      return
    }

    NSLayoutConstraint.activate([
      view.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
      view.centerYAnchor.constraint(equalTo: parent.centerYAnchor)
    ])
  }
}
