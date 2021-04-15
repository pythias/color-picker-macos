//
//  ColorPickerViewController.swift
//  ColorPicker
//
//  Created by pythias on 2020/4/15.
//  Copyright © 2020 pythias. All rights reserved.
//

import Cocoa

class ColorPickerViewController: NSViewController {
    // MARK: Properties
    weak var colorSelectedDelegate: ColorPickerViewControllerDelegate?
    
    static let idColumnFavorite = NSUserInterfaceItemIdentifier(rawValue: "col-favorite")
    static let idColumnName = NSUserInterfaceItemIdentifier(rawValue: "col-name")
    static let idColumnColors = NSUserInterfaceItemIdentifier(rawValue: "col-colors")
    
    private let sourceFavorite = MyFavorite();
    private let sourceAdobe = SourceAdobe();
    private let sourceCoolors = SourceCoolors();
    private let sourceRandom = SourceRandom();
    private var sources: [Source] = []

    private var patterns: [Pattern] = []
    
    private let popupButton: NSPopUpButton = {
        let popupButton = NSPopUpButton()
        return popupButton;
    }()
    
    private let tableView: NSTableView = {
        let tableView = NSTableView()
        tableView.headerView = nil
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = false
        
        let favoriteColumn = NSTableColumn()
        favoriteColumn.identifier = idColumnFavorite
        favoriteColumn.width = 36
        favoriteColumn.resizingMask = .userResizingMask
        tableView.addTableColumn(favoriteColumn)
        
        let colorsColumn = NSTableColumn()
        colorsColumn.identifier = idColumnColors
        colorsColumn.resizingMask = .autoresizingMask
        tableView.addTableColumn(colorsColumn)
        
        let nameColumn = NSTableColumn()
        nameColumn.identifier = idColumnName
        nameColumn.width = 100
        nameColumn.resizingMask = .userResizingMask
        tableView.addTableColumn(nameColumn)
        
        tableView.intercellSpacing = NSSize(width: 0, height: 2.0)
        tableView.selectionHighlightStyle = .regular
        tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle

        return tableView
    }()
        
    // MARK: Initializers
    deinit {
        tableView.delegate = nil
        tableView.dataSource = nil
        DistributedNotificationCenter.default().removeObserver(self)
    }
    
    required init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    override func loadView() {
        view = {
            sources = [sourceFavorite, sourceAdobe, sourceCoolors, sourceRandom]
            for src in sources {
                popupButton.addItem(withTitle: src.title)
            }
            popupButton.target = self
            popupButton.action = #selector(sourceChanged(pop:))
            
            let scrollView = NSScrollView()
            scrollView.documentView = tableView
            
            let stackView = NSStackView()
            stackView.orientation = .vertical
            stackView.addView(popupButton, in: .top)
            stackView.addView(scrollView, in: .bottom)
            
            let constraints = [
                popupButton.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 8.0),
                popupButton.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -8.0),
                popupButton.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 8.0)]
            NSLayoutConstraint.activate(constraints)
            
            return stackView
        }()
        
        view.frame = NSRect(x: 10, y: 10, width: 400, height: 400)
        view.wantsLayer = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadPatterns()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        sourceFavorite.save()
    }
            
    @objc private func loadPatterns() {
        let source = self.sources[popupButton.indexOfSelectedItem]

        if source.patterns.isEmpty {
            source.fetch()
        }
        
        let sorted = source.patterns.sorted { $0.value.name < $1.value.name }
        
        patterns = [];
        for kv in sorted {
            let pattern = kv.value
            if sourceFavorite.patterns[pattern.id] != nil {
                pattern.favor = true
            }
            patterns.append(pattern)
        }
        
        tableView.reloadData()
    }
        
    private func getPattern(at section: Int) -> Pattern? {
        if (section >= patterns.count) {
            return nil
        }
        
        return patterns[section]
    }
    
    @objc func sourceChanged(pop: NSPopUpButton) {
        loadPatterns()
    }
}

// MARK: NSTableViewDataSource

extension ColorPickerViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return patterns.count
    }
}

// MARK: NSTableViewDelegate

extension ColorPickerViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return PatternRowView()
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let pattern = patterns[row]
        if tableColumn?.identifier == ColorPickerViewController.idColumnFavorite {
            let favoriteView = FavoriteView()
            favoriteView.setPattern(pattern)
            favoriteView.favoriteViewDelegate = self
            return favoriteView
        }
        
        if tableColumn?.identifier == ColorPickerViewController.idColumnName {
            let nameView = NameView()
            nameView.setPattern(pattern)
            return nameView
        }
        
        let patternView = PatternView()
        patternView.setPattern(pattern)
        patternView.patternViewDelegate = self
        return patternView
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 36.0
    }
}

extension ColorPickerViewController: FavoriteViewDelegate {
    func favoriteViewClicked(_ favoriteView: FavoriteView, with pattern: Pattern) {
        if pattern.favor {
            sourceFavorite.append(pattern)
        } else {
            sourceFavorite.remove(pattern)
        }
        
        sourceFavorite.save()
    }
}

extension ColorPickerViewController: PatternViewDelegate {
    func patternView(_ patternView: PatternView, selected pattern: Pattern, with color: NSColor) {
        pattern.usage += pattern.usage
        
        if self.colorSelectedDelegate != nil {
            self.colorSelectedDelegate?.colorPickerViewController(self, didSelectColor: color)
        }
    }
}

// MARK: ColorPickerViewControllerDelegate

protocol ColorPickerViewControllerDelegate: class {
    func colorPickerViewController(_ colorPickerViewController: ColorPickerViewController, didSelectColor color: NSColor)
}
