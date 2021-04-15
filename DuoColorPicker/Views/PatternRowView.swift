//
//  PatternRowView.swift
//  t1
//
//  Created by 陈杰 on 2021/4/9.
//

import Cocoa

class PatternRowView: NSTableRowView {
    override func drawSelection(in dirtyRect: NSRect) {
        let selectionPath = NSBezierPath.init(roundedRect: self.bounds, xRadius: 2, yRadius: 2)
        NSColor.systemGray.setStroke()
        selectionPath.stroke()
    }
}
