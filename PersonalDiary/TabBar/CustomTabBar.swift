//
//  CustomTabBar.swift
//  PersonalDiary
//
//  Created by Karen Khachatryan on 22.11.24.
//

import UIKit

protocol CustomTabBarDelegate: AnyObject {
    func addRecord()
}

class CustomTabBar: UITabBar {
    let centerButton = UIButton()
    private var shapeLayer: CALayer?
    weak var baseDelegate: CustomTabBarDelegate?
    
    override func draw(_ rect: CGRect) {
        let buttonSize: CGFloat = rect.width / 3
        let buttonRadius = buttonSize / 2
        centerButton.frame = CGRect(x: (bounds.width / 3),
                                    y: -25,
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
        baseDelegate?.addRecord()
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
