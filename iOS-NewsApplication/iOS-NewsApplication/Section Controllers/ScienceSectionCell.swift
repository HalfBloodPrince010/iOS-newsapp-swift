//
//  ScienceSectionCell.swift
//  iOS-NewsApplication
//
//  Created by Prashanth Pujar on 4/19/20.
//  Copyright © 2020 Prashanth Pujar. All rights reserved.
//

import UIKit

class ScienceSectionCell: UITableViewCell {
    var sciencelink: ScienceController?
    @IBOutlet weak var sectionDuration: UILabel!
    @IBOutlet weak var sectionNewsSection: UILabel!
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var sectionImage: UIImageView!
    
    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBAction func bookmarkButton(_ sender: UIButton) {
        print("Clicked-Science")
        print(sciencelink!)
        sciencelink?.handleBookmark(cell:self)
        print(bookmarkButton!)
    }
    
}
