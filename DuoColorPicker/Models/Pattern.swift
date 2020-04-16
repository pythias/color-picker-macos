//
//  Pattern.swift
//  ColorPicker
//
//  Created by pythias on 2020/4/15.
//  Copyright © 2020 pythias. All rights reserved.
//

import Cocoa

struct Pattern: Codable {
    // MARK: Properties
    let id: String
    let name: String
    let colors: [Color]
}
