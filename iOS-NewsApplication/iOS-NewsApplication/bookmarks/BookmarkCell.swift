import UIKit

class BookmarkCell: UICollectionViewCell {
    var collectionlink:BookmarksViewController?
    
    @IBOutlet weak var bookmarkImage: UIImageView!
    @IBOutlet weak var bookmarkView: UIView!
    @IBOutlet weak var bookmarkTitle: UILabel!
    @IBAction func bookmarkButton(_ sender: UIButton) {
        print("Collection Clicked")
        print(collectionlink!)
        collectionlink?.deleteBookmark(cell:self)
        print(bookmarkButton!)
    }
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var bookmarkSection: UILabel!
    @IBOutlet weak var bookmarkDate: UILabel!
}
