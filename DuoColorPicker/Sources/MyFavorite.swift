//
//  MyFavorite.swift
//  DuoColorPicker
//
//  Created by pythias on 2021/3/4.
//  Copyright © 2021 pythias. All rights reserved.
//

import Foundation

class MyFavorite: Source {
    private let bundle = Bundle(for: ColorPicker.self)
    
    override var name: String {
        return "my-favorite"
    }
}
