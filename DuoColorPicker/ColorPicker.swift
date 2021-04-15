//
//  ColorPicker.swift
//  ColorPicker
//
//  Created by pythias on 2020/4/15.
//  Copyright © 2020 pythias. All rights reserved.
//

import Cocoa

final class ColorPicker: NSColorPicker {
    private static let minContentSize = NSSize(width: 300.0, height: 400.0)
    private let bundle = Bundle(for: ColorPicker.self)
    private lazy var colorPickerViewController = ColorPickerViewController()
    
    public override var provideNewButtonImage: NSImage {
        let icon = bundle.image(forResource: "colors")!
        return icon
    }
    
    override var buttonToolTip: String {
        return NSLocalizedString("title", comment: "Color Palettes")
    }
        
    override var minContentSize: NSSize {
        return ColorPicker.minContentSize
    }
    
    override func viewSizeChanged(_ sender: Any?) {
        
    }
}

extension ColorPicker: NSColorPickingCustom {
    func supportsMode(_ mode: NSColorPanel.Mode) -> Bool {
        return mode == .RGB
    }

    func currentMode() -> NSColorPanel.Mode {
        return .RGB
    }

    func provideNewView(_ initialRequest: Bool) -> NSView {
        if (initialRequest) {
            colorPickerViewController.colorSelectedDelegate = self
        }

        return colorPickerViewController.view
    }

    func setColor(_ newColor: NSColor) {
        
    }
}

extension ColorPicker: ColorPickerViewControllerDelegate {
    func colorPickerViewController(_ colorPickerViewController: ColorPickerViewController, didSelectColor color: NSColor) {
        self.colorPanel.color = color
        NSLog("DuoColorPicker, color selected %@", color)
    }
}
