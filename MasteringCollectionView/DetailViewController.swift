//
//  DetailViewController.swift
//  MasteringCollectionView
//
//  Created by 山本響 on 2021/06/19.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedData: String?
    
    @IBOutlet weak var dataLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(selectedData!) details"
        dataLabel.text = selectedData
    }

}
