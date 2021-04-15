//
//  FavoriteView.swift
//  DuoColorPicker
//
//  Created by 陈杰 on 2021/4/8.
//  Copyright © 2021 pythias. All rights reserved.
//

import Cocoa

protocol FavoriteViewDelegate: class {
    func favoriteViewClicked(_ favoriteView: FavoriteView, with pattern: Pattern)
}

class FavoriteView: NSView {
    weak var favoriteViewDelegate: FavoriteViewDelegate?
    
    static let id = NSUserInterfaceItemIdentifier(rawValue: "FavoriteView")
    
    var _pattern: Pattern = Pattern()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
        let centerX = Double(self.bounds.size.width / 2)
        let centerY = Double(self.bounds.size.height / 2)
        let r = Double(self.bounds.size.width / 2) - 4
        let theta = 2.0 * Double.pi * (2.0 / 5.0)
        
        var points: [NSPoint] = []
        for i in 1...5 {
            let x = centerX + r * sin(Double(i) * theta)
            let y = centerY + r * cos(Double(i) * theta)
            points.append(NSPoint(x: x, y: y))
        }
        
        let path = NSBezierPath()
        path.move(to: points[0])
        path.line(to: points[1])
        path.line(to: points[2])
        path.line(to: points[3])
        path.line(to: points[4])
        path.line(to: points[0])
        
        if _pattern.favor {
            NSColor.systemBlue.setFill()
        } else {
            NSColor.init(deviceWhite: 0.1, alpha: 0.1).setFill()
        }
        
        path.fill()
        path.close()
    }
    
    public func setPattern(_ pattern: Pattern) {
        _pattern = pattern
    }

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        _pattern.favor = !_pattern.favor
        needsDisplay = true
        
        if self.favoriteViewDelegate != nil {
            self.favoriteViewDelegate?.favoriteViewClicked(self, with: _pattern)
        }
    }
}
