//
//  PatternView.swift
//  DuoColorPicker
//
//  Created by 陈杰 on 2021/4/8.
//  Copyright © 2021 pythias. All rights reserved.
//

import Cocoa

protocol PatternViewDelegate: class {
    func patternView(_ patternView: PatternView, selected pattern: Pattern, with color: NSColor)
}

class PatternView: NSView {
    static let size = 36.0
    static let spacing = 2.0
    static let id = NSUserInterfaceItemIdentifier(rawValue: "PatternView")
    
    weak var patternViewDelegate: PatternViewDelegate?
    
    var _pattern: Pattern = Pattern()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let colors = _pattern.colors else {
            return
        }
        
        // Drawing code here.
        var x = 0.0
        for color in colors {
            let path = NSBezierPath()
            path.appendRect(NSRect(x: x, y: 0.0, width: PatternView.size, height: PatternView.size))
            color.setFill()
            path.fill()
            path.close()
            x += PatternView.size + PatternView.spacing
        }
    }
    
    public func setPattern(_ pattern: Pattern) {
        _pattern = pattern
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        let localPoint = self.convert(event.locationInWindow, from: NSApplication.shared.mainWindow?.contentView)
        let index = Int(floor(localPoint.x / CGFloat(PatternView.size + PatternView.spacing)))
        
        guard let colors = _pattern.colors else {
            return
        }
        
        if index >= colors.count {
            return
        }
                
        if (self.patternViewDelegate != nil) {
            self.patternViewDelegate?.patternView(self, selected: _pattern, with: colors[index])
        }
    }
}
