//
//  Pattern.swift
//  ColorPicker
//
//  Created by pythias on 2020/4/15.
//  Copyright © 2020 pythias. All rights reserved.
//

import Cocoa

class Pattern: NSObject, NSCoding {
    var _id: String = ""
    var name: String = ""
    var colors: [NSColor]!
    var usage: Int32 = 0
    var favor: Bool = false
    
    override init() {
        
    }
    
    convenience init(name: String, colors: [NSColor], usage: Int32, favor: Bool) {
        self.init()
        
        self.name = name
        self.colors = colors
        self.usage = usage
        self.favor = favor
    }
    
    convenience init(id: String, name: String, colors: [NSColor], usage: Int32, favor: Bool) {
        self.init()
        
        self._id = id
        self.name = name
        self.colors = colors
        self.usage = usage
        self.favor = favor
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(usage, forKey: "usage")
        coder.encode(favor, forKey: "favor")
        coder.encode(colors, forKey: "colors")
    }
    
    required init?(coder: NSCoder) {
        super.init()
        
        self.name = coder.decodeObject(forKey: "name") as! String
        self.usage = coder.decodeInt32(forKey: "usage")
        self.favor = coder.decodeBool(forKey: "favor")
        self.colors = coder.decodeObject(forKey: "colors") as? [NSColor]
    }
    
    override var description: String {
        return "parttern, id:\(id), name:\(name), usage:\(usage), favor:\(favor), colors:\(colors)"
    }
    
    var id: String {
        set {
            _id = newValue
        } get {
            if _id == "" {
                _id = "\(colors)".md5Value
            }
            
            return _id
        }
    }
    
    func use() {
        self.usage += 1
    }
}
