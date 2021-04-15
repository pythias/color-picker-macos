//
//  Source.swift
//  ColorPicker
//
//  Created by pythias on 2020/4/15.
//  Copyright © 2020 pythias. All rights reserved.
//

import Cocoa

class Source {
    private let bundle = Bundle(for: ColorPicker.self)
    private let defaults = UserDefaults.standard
    private var lastFetched: Double = 0
    private var fetching: Bool = false
    private var saving: Bool = false
    
    var name: String {
        return "src"
    }
    
    var title: String {
        return bundle.localizedString(forKey: self.name, value: "", table: "Localization")
    }
    
    private var _patterns: [String: Pattern] = [:]
    var patterns: [String: Pattern] {
        get {
            let last = defaults.integer(forKey: "last-\(self.name)")
            let lastDate = Date.init(timeIntervalSince1970: TimeInterval(last))
            if !NSCalendar.current.isDateInToday(lastDate) {
                self.fetch()
            }
            
            return _patterns
        }
    }
    
    var url: String {
        return ""
    }
    
    init() {
        self.load()
    }
    
    func append( _ pattern: Pattern) {
        _patterns[pattern.id] = pattern
    }
    
    func remove( _ pattern: Pattern) {
        if self._patterns[pattern.id] != nil {
            self._patterns.removeValue(forKey: pattern.id)
        }
    }
    
    func save() {
        do {
            if saving {
                return
            }
            saving = true
            
            let patternsData = try NSKeyedArchiver.archivedData(withRootObject: self.patterns, requiringSecureCoding: false)
            defaults.setValue(patternsData, forKey: self.name)
        } catch {
            NSLog("DuoColorPicker can't save patterns: \(error)")
        }
        
        saving = false
    }
    
    func load() {
        do {
            NSLog("DuoColorPicker load: \(self.name)")
            
            let patternsData = defaults.data(forKey: self.name)
            if patternsData == nil {
                return
            }
            
            guard let patterns = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(patternsData!) as? [String:Pattern] else {
                return
            }
            
            self._patterns = patterns
        } catch {
            NSLog("DuoColorPicker can't load patterns: \(error)")
        }
    }
    
    func fetch() {
        
    }
    
    func fetchWillBegin() -> Bool {
        if self.fetching {
            return false
        }
        
        self._patterns = [:]
        self.fetching = true
        return true
    }
    
    func fetchDidEnd() {
        self.fetching = false
        self.lastFetched = Date.init().timeIntervalSince1970
        defaults.setValue(self.lastFetched, forKey: "last-\(self.name)")
    }
    
    func load(from json: String) {
        guard let assets = NSDataAsset(name: json, bundle: bundle) else {
            NSLog("DuoColorPicker can't find '\(json).json'")
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: assets.data, options: .allowFragments)
            let items = json as? [[String: Any]]
            if items!.isEmpty {
                return
            }
            
            if items![0]["name"] == nil || items![0]["colors"] == nil {
                return
            }
            
            for i in 0..<items!.count {
                let item = items![i]
                let pattern = Pattern()
                pattern.colors = []
                pattern.name = item["name"] as! String
                
                let colors = item["colors"] as! [String]
                for j in 0..<colors.count {
                    pattern.colors.append(NSColor.from(hex: colors[j]))
                }
                
                self.append(pattern)
            }
            
        } catch {
            NSLog("DuoColorPicker error:\(error)")
        }
    }
    
    func loadColors(from json: String) {
        guard let assets = NSDataAsset(name: json, bundle: bundle) else {
            NSLog("DuoColorPicker can't find '\(json).json'")
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: assets.data, options: .allowFragments)
            var colors = json as? [[String: Any]]
            if colors!.isEmpty {
                return
            }
            
            if colors![0]["name"] == nil || colors![0]["hex"] == nil {
                return
            }
            
            colors?.shuffle()
            
            let pattern = Pattern()
            pattern.name = colors![0]["name"] as! String
            pattern.colors = []
            
            let count = min(6, colors!.count)
            for i in 0..<count {
                pattern.colors.append(NSColor.from(hex: colors![i]["hex"] as! String))
            }
            
            self.append(pattern)
        } catch {
            NSLog("DuoColorPicker error:\(error)")
        }
    }
}
