//
//  PatternCell.swift
//  DuoColorPicker
//
//  Created by pythias on 2020/4/16.
//  Copyright © 2020 pythias. All rights reserved.
//

import Cocoa

class PatternCell: NSCollectionViewItem {
    static let height: CGFloat = 20.0
    static let width: CGFloat = 46.0
    static let reuseIdentifier = NSUserInterfaceItemIdentifier(rawValue: "PatternCell")

    override func loadView() {
        self.view = NSView()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = CGColor.white
        self.view.frame = NSRect(x: 0, y: 0, width: PatternCell.width, height: PatternCell.height)
    }
    
    public var color: NSColor? {
       didSet {
           self.view.layer?.backgroundColor = color?.cgColor
       }
    }
}
