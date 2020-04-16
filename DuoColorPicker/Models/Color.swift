//
//  Color.swift
//  ColorPicker
//
//  Created by pythias on 2020/4/15.
//  Copyright © 2020 pythias. All rights reserved.
//

import Cocoa

struct Color: Codable {
    // MARK: Properties
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double

    // MARK: Public

    func nsColor(with colorSpace: NSColorSpace) -> NSColor? {
        let components = [
            CGFloat(red) / 255.0,
            CGFloat(green) / 255.0,
            CGFloat(blue) / 255.0,
            CGFloat(alpha)
        ]

        return NSColor(colorSpace: colorSpace, components: components, count: components.count)
    }

    func isSame(with color: NSColor, using colorSpace: NSColorSpace) -> Bool {
        guard
            let nsColor = self.nsColor(with: colorSpace),
            let adjustedColor = color.usingColorSpace(colorSpace)
        else {
            return false
        }

        return nsColor.redComponent.isEqual(to: adjustedColor.redComponent) &&
               nsColor.greenComponent.isEqual(to: adjustedColor.greenComponent) &&
               nsColor.blueComponent.isEqual(to: adjustedColor.blueComponent) &&
               nsColor.alphaComponent.isEqual(to: adjustedColor.alphaComponent)
    }
}
