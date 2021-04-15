//
//  Color.swift
//  ColorPicker
//
//  Created by pythias on 2020/4/15.
//  Copyright © 2020 pythias. All rights reserved.
//

import Cocoa

extension NSColor {
    static func random() -> NSColor {
        return NSColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
    }
    
    static func from(hex: String) -> NSColor {
        var colorCode : UInt64 = 0
        var hex6 = hex

        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex6 = String(hex[index...])
        }
        
        let scanner = Scanner(string: hex6)
        let success = scanner.scanHexInt64(&colorCode)
        
        if success == true {
            return NSColor.init(red: CGFloat((colorCode & 0xFF0000) >> 16) / 255.0, green: CGFloat((colorCode & 0xFF00) >> 8) / 255.0, blue: CGFloat((colorCode & 0xFF)) / 255.0, alpha: 1.0)
        }
        
        return NSColor()
    }
}
