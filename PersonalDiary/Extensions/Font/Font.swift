//
//  Font.swift
//  Prompt_Keeper
//
//  Created by Karen Khachatryan on 19.11.24.
//

import Foundation

import UIKit

extension UIFont {
    static func regular(size: CFloat) -> UIFont? {
        return UIFont(name: "SFProText-Regular", size: CGFloat(size))
    }
    
    static func medium(size: CFloat) -> UIFont? {
        return UIFont(name: "SFProText-Medium", size: CGFloat(size))
    }
    
    static func semibold(size: CFloat) -> UIFont? {
        return UIFont(name: "SFProText-Semibold", size: CGFloat(size))
    }
}
