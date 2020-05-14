import UIKit
import Toast_Swift

class BookmarksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIContextMenuInteractionDelegate {
    var selectedNews:String?
    var bookmarks:[Bookmark] = [Bookmark]()
    let bookmark_data = UserDefaults.standard.array(forKey: "Bookmarks") as Array?
    let bookmarkModel = BookmarkModel()
    let emptyArray = [Array<Any>]()
    @IBOutlet weak var bookmarkCollectionView: UICollectionView!
    
    // Defaults
    let defaults = UserDefaults.standard
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookmarkCollectionView.dataSource = self
        bookmarkCollectionView.delegate = self
        let layout = self.bookmarkCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 7
//        layout.itemSize = CGSize(width:(self.bookmarkCollectionView.frame.size.width-60)/2, height: 250)
        layout.itemSize = CGSize(width: 179, height: 250)
        print(self.bookmarkCollectionView.frame.size.width-60)
        self.loadData()
    }
    
    let noBookmarks = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    func loadData(){
        let bookmark_data = UserDefaults.standard.array(forKey: "Bookmarks") as Array?
        if bookmark_data != nil{
           print("Calling function")
            let write_bookmark:Array = UserDefaults.standard.array(forKey: "Bookmarks")! as Array
            if write_bookmark.count == 0{
                bookmarks = [Bookmark]()
                noBookmarks.center = self.view.center
                noBookmarks.textAlignment = .center
                noBookmarks.text = "No bookmarks added."
                self.view.addSubview(noBookmarks)
                self.noBookmarks.isHidden = false
                self.bookmarkCollectionView.reloadData()
                print("Empty Inside")
            }
            else{
                self.noBookmarks.isHidden = true
           bookmarks =  bookmarkModel.getBookmarks(data: bookmark_data as? [Array<Any>] ?? emptyArray)
            self.bookmarkCollectionView.reloadData()
            }
        }
        else{
            print("Emptyyyy")
            bookmarks = [Bookmark]()
            self.bookmarkCollectionView.reloadData()
        }
    }
    
        func deleteBookmark(cell:UICollectionViewCell){
                print("Deleting the cell:")
                print(cell)
                // Getting the index of the news clicked
                let newsClicked = bookmarkCollectionView.indexPath(for:cell)
                let newsClickedIndex = newsClicked!.row
                print(newsClickedIndex)
                var write_bookmark:Array = UserDefaults.standard.array(forKey: "Bookmarks")! as Array
                write_bookmark.remove(at: newsClickedIndex)
                defaults.set(write_bookmark, forKey: "Bookmarks")
                self.view.makeToast("Article removed from Bookmarks", duration: 2.0, position: .bottom)
                print("Deleted")
                self.loadData()
            }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func contextMenu(cellRow:IndexPath) -> UIMenu {
    let twitterShare = UIAction(title: "Share with Twitter", image: UIImage(named:"twitter")) { _ in
        let checkText = "Check out this Article!"
        let newsClickedIndex = cellRow.row
        let data = self.bookmarks[newsClickedIndex]
        let data_url = data.articleId
        let newsurlAndHastag = "https://theguardian.com/"  + data_url + "\n" + "#CSCI_571_NewsApp"
        let twitterDataString = "https://twitter.com/intent/tweet?text=\(checkText)&url=\(newsurlAndHastag)"
        let twitterUrlEncoded = twitterDataString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let twitterUrl = URL(string: twitterUrlEncoded)
        UIApplication.shared.open(twitterUrl!,options: [:], completionHandler: nil)
        print(cellRow)
    }
    let bookmark = UIAction(title: "Remove Bookmark", image: UIImage(systemName: "bookmark")) { _ in
        let ucell = self.bookmarkCollectionView!.cellForItem(at: cellRow)
        self.deleteBookmark(cell: ucell!)
        print(cellRow)
    }
    return UIMenu(title: "Menu", children: [twitterShare, bookmark])
    }

    // Context Menu Delegate Method

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
        return self.contextMenu(cellRow: [0,0] as IndexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { _ -> UIMenu? in
            return self.contextMenu(cellRow:indexPath)
        }
    }
    
    
    var requireReload = false
    
    override func loadViewIfNeeded() {
        if requireReload == true{
            requireReload = false
            print("Back from Detailed Page so reloading..")
            self.loadData()
        }

    }
    
    var selectedArticle:String?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = bookmarks[indexPath.item]
        let articleId = data.articleId
        self.selectedArticle = articleId
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.performSegue(withIdentifier:"bookmarksegue", sender: self)
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailedNews = segue.destination as! DetailedViewController
        requireReload = true
        detailedNews.articleId = self.selectedArticle
        }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bookmark_data = bookmarks[indexPath.row]
        let cell = bookmarkCollectionView.dequeueReusableCell(withReuseIdentifier: "bookmarkcell", for: indexPath) as! BookmarkCell
        let Bimage:UIImage! = UIImage(systemName: "bookmark.fill")
        cell.bookmarkButton.setImage(Bimage, for: .normal)
        cell.bookmarkDate.text = bookmark_data.articleDuration
        cell.bookmarkTitle.text = bookmark_data.articleTitle
        cell.bookmarkImage.image = bookmark_data.articleImage
        cell.bookmarkSection.text = bookmark_data.articleSection
        cell.bookmarkView.layer.borderColor = UIColor.lightGray.cgColor
        cell.bookmarkView.layer.borderWidth = 0.5
        cell.bookmarkView.layer.cornerRadius = 7
        cell.bookmarkImage.layer.cornerRadius = 7
        cell.collectionlink = self
        return cell
    }
    
}
