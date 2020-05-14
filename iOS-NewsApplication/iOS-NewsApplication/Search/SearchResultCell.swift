import UIKit

class SearchResultCell: UITableViewCell {
    var link:SearchResults?
    @IBOutlet weak var searchResultView: UIView!
    
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBAction func bookmarkButton(_ sender: UIButton) {
        print("Clicked-Searched Result")
        print(link!)
        link?.handleBookmark(cell:self)
        print(bookmarkButton!)
    }
    @IBOutlet weak var searchResultSection: UILabel!
    @IBOutlet weak var searchResultDuration: UILabel!
    @IBOutlet weak var searchResultImage: UIImageView!
    @IBOutlet weak var searchResultTitle: UILabel!
}
