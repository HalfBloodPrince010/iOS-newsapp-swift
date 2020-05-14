//
//  SectionCell.swift
//  iOS-NewsApplication
//
//  Created by Prashanth Pujar on 4/14/20.
//  Copyright © 2020 Prashanth Pujar. All rights reserved.
//

import UIKit

class SectionCell: UITableViewCell {
    var worldlink: WorldController?
    @IBOutlet weak var sectionNewsSection: UILabel!
    @IBOutlet weak var sectionDuration: UILabel!
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var sectionImage: UIImageView!
    @IBOutlet weak var sectionView: UIView!
    
    @IBAction func bookmarkButton(_ sender: UIButton) {
        print("Clicked-World")
        print(worldlink!)
        worldlink?.handleBookmark(cell:self)
        print(bookmarkButton!)
    }
    
    @IBOutlet weak var bookmarkButton: UIButton!
    
    
    
}
