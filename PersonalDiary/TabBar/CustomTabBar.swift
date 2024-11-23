//
//  CustomTabBar.swift
//  PersonalDiary
//
//  Created by Karen Khachatryan on 22.11.24.
//

import UIKit

class CustomTabBar: UITabBar {
    let centerButton = UIButton()
    private var shapeLayer: CALayer?

    override func draw(_ rect: CGRect) {
        let buttonSize: CGFloat = 100
        let buttonRadius = buttonSize / 2
        centerButton.frame = CGRect(x: (bounds.width / 2) - buttonRadius,
                                    y: -20,
                                    width: buttonSize,
                                    height: buttonSize)
        centerButton.layer.cornerRadius = buttonRadius
        centerButton.setImage(.centerAdd, for: .normal)
        centerButton.imageView?.contentMode = .center
        centerButton.tintColor = .white
        centerButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        addSubview(centerButton)
    }
    
    @objc private func centerButtonTapped() {
        print("Center button tapped")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 127
        return sizeThatFits
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if centerButton.frame.contains(point) {
            return centerButton
        }
        return super.hitTest(point, with: event)
    }
}