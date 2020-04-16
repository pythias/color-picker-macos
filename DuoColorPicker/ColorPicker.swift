//
//  ColorPicker.swift
//  ColorPicker
//
//  Created by pythias on 2020/4/15.
//  Copyright © 2020 pythias. All rights reserved.
//

import Cocoa

final class ColorPicker: NSColorPicker {
    private let bundle = Bundle(for: ColorPicker.self)
    private lazy var colorPickerViewController = ColorPickerViewController()
    
    public override var provideNewButtonImage: NSImage {
        let icon = bundle.image(forResource: "colors")!
        return icon
    }
        
    override var buttonToolTip: String {
        return "颜色模板";
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
