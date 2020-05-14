//
//  NewsCell.swift
//  iOS-NewsApplication
//
//  Created by Prashanth Pujar on 4/14/20.
//  Copyright © 2020 Prashanth Pujar. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    var link: HomeViewController?
    
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsCellView: UIView!
    @IBOutlet weak var newsDuration: UILabel!
    @IBOutlet weak var newsSection: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    @IBAction func bookmarkButton(_ sender: UIButton) {
        print("Clicked")
        print(link!)
        link?.handleBookmark(cell:self)
        print(bookmarkButton!)
    }
    
}
