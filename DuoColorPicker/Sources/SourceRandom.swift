//
//  SourceRandom.swift
//  t1
//
//  Created by 陈杰 on 2021/4/13.
//

import Foundation

class SourceRandom: Source {
    override var name: String {
        return "src-random"
    }
    
    override var url: String {
        return ""
    }
    
    override func fetch() {
        if self.fetchWillBegin() == false {
            return
        }
        
        self.loadColors(from: "zhongguose")
        self.loadColors(from: "nipponcolors")
        
        self.fetchDidEnd()
    }
    
    override func load() {
        self.fetch()
    }
}
