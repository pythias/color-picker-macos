//
//  NameView.swift
//  t1
//
//  Created by 陈杰 on 2021/4/13.
//

import Cocoa

class NameView: NSView {
    static let id = NSUserInterfaceItemIdentifier(rawValue: "NameView")
    
    var _pattern: Pattern = Pattern()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        let font = NSFont.systemFont(ofSize: 16)
        let layoutManager = NSLayoutManager()
        let height = layoutManager.defaultLineHeight(for: font)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
        ]
        
        let attributeString = NSAttributedString(string: _pattern.name, attributes: attributes)
        attributeString.draw(at: NSPoint(x: 8, y: (self.bounds.height - height) / 2))
    }
    
    public func setPattern(_ pattern: Pattern) {
        self._pattern = pattern
    }
}
