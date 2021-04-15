//
//  SourceCoolors.swift
//  DuoColorPicker
//
//  Created by pythias on 2021/3/4.
//  Copyright © 2021 pythias. All rights reserved.
//

import Foundation

class SourceCoolors: Source {
    override var name: String {
        return "src-coolors"
    }
    
    override var url: String {
        return "https://coolors.co/"
    }
    
    override func fetch() {
        if self.fetchWillBegin() == false {
            return
        }
        
        self.load(from: "coolors")
        
        self.fetchDidEnd()
    }
}
