//
//  TechnologySectionCell.swift
//  iOS-NewsApplication
//
//  Created by Prashanth Pujar on 4/19/20.
//  Copyright © 2020 Prashanth Pujar. All rights reserved.
//

import UIKit

class TechnologySectionCell: UITableViewCell {
    var technologylink: TechnologyController?
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var sectionNewsSection: UILabel!
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var sectionDuration: UILabel!
    @IBOutlet weak var sectionImage: UIImageView!
    @IBAction func bookmarkButton(_ sender: UIButton) {
        print("Clicked-Technology")
        print(technologylink!)
        technologylink?.handleBookmark(cell:self)
        print(bookmarkButton!)
    }
    
    @IBOutlet weak var bookmarkButton: UIButton!
    
}
