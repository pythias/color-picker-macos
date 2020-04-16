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

    private var patterns: [Pattern]? {
        didSet {
            if patterns != nil {
                collectionView.reloadData()
            }
        }
    }
    
    private let collectionView: NSCollectionView = {
        let layout = NSCollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 1
        layout.itemSize = NSSize(width: PatternCell.width, height: PatternCell.height)
        layout.sectionInset = NSEdgeInsets(top: 1.0, left: 4.0, bottom: 1.0, right: 4.0)
        
        let collectionView = NSCollectionView()
        collectionView.collectionViewLayout = layout
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColors = [.clear]
        collectionView.isSelectable = true
        collectionView.register(
            PatternCell.self,
            forItemWithIdentifier: PatternCell.reuseIdentifier
        )
        return collectionView
    }()
        
    // MARK: Initializers
    deinit {
        collectionView.delegate = nil
        collectionView.dataSource = nil
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
            let scrollView = NSScrollView()
            scrollView.documentView = collectionView
            return scrollView
        }()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        reload()
    }
        
    @objc private func reload() {
        let coolors = Coolors()
        let hunt = ColorHunt()

        patterns = []
        patterns?.append(contentsOf:coolors.popular())
        patterns?.append(contentsOf:hunt.popular())
        patterns?.append(contentsOf:coolors.random())
        patterns?.append(contentsOf:hunt.random())
        
        if (patterns != nil) {
            NSLog("DuoColorPicker, %d patterns", patterns!.count)
        } else {
            NSLog("DuoColorPicker, empty patterns")
        }
        
        collectionView.reloadData()
    }
    
    private func getColor(by indexPath: IndexPath) -> NSColor? {
        if (indexPath.section >= patterns!.count) || (indexPath.item >= patterns![indexPath.section].colors.count) {
            return nil
        }
        
        return patterns![indexPath.section].colors[indexPath.item].nsColor(with: NSColorSpace.sRGB)
    }
}

// MARK: NSCollectionViewDataSource

extension ColorPickerViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        if (patterns == nil || patterns!.count < section) {
            return 0
        }
        
        return patterns![section].colors.count
    }

    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return patterns!.count
    }
}

// MARK: NSCollectionViewDelegate

extension ColorPickerViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: PatternCell.reuseIdentifier, for: indexPath) as! PatternCell
        guard let color = getColor(by: indexPath) else {
            return item
        }
        
        item.color = color
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        let indexPath = indexPaths.first!
        guard let color = getColor(by: indexPath) else {
            return
        }
        
        if (self.colorSelectedDelegate != nil) {
            self.colorSelectedDelegate?.colorPickerViewController(self, didSelectColor: color)
        }
    }
}

// MARK: ColorPickerViewControllerDelegate

protocol ColorPickerViewControllerDelegate: class {
    func colorPickerViewController(_ colorPickerViewController: ColorPickerViewController, didSelectColor color: NSColor)
}
