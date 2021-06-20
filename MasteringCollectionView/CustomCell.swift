//
//  CustomCell.swift
//  MasteringCollectionView
//
//  Created by 山本響 on 2021/06/20.
//

import UIKit

class CustomCell: UICollectionViewCell {
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var selectedLabel: UILabel!
    
    var isEditing: Bool = false {
        didSet {
            selectedLabel.isHidden = !isEditing
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isEditing {
                selectedLabel.text = isSelected ? "✓" : ""
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectedLabel.layer.cornerRadius = 15
        self.selectedLabel.layer.masksToBounds = true
        self.selectedLabel.layer.borderColor = UIColor.white.cgColor
        self.selectedLabel.layer.borderWidth = 1.0
        self.selectedLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
    }
    
}
