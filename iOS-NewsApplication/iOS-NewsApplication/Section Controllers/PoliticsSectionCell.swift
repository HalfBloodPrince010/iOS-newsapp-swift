//
//  PoliticsSectionCell.swift
//  iOS-NewsApplication
//
//  Created by Prashanth Pujar on 4/19/20.
//  Copyright © 2020 Prashanth Pujar. All rights reserved.
//

import UIKit

class PoliticsSectionCell: UITableViewCell {
    var politicslink: PoliticsController?
    @IBOutlet weak var sectionImage: UIImageView!
    @IBOutlet weak var sectionNewsSection: UILabel!
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var sectionDuration: UILabel!
    @IBOutlet weak var sectionTitle: UILabel!
    
    @IBAction func bookmarkButton(_ sender: UIButton) {
        print("Clicked-Politics")
        print(politicslink!)
        politicslink?.handleBookmark(cell:self)
        print(bookmarkButton!)
    }
    
    @IBOutlet weak var bookmarkButton: UIButton!
    
}
