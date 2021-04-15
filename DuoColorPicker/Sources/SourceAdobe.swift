//
//  SourceAdobe.swift
//  DuoColorPicker
//
//  Created by pythias on 2021/3/4.
//  Copyright © 2021 pythias. All rights reserved.
//

import Foundation

class SourceAdobe: Source {
    override var name: String {
        return "src-adobe"
    }
    
    override var url: String {
        return "https://color.adobe.com/"
    }
    
    override func fetch() {
        if self.fetchWillBegin() == false {
            return
        }
        
        self.load(from: "adobe")
        
        self.fetchDidEnd()
    }
}
