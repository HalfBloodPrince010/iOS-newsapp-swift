import UIKit
import SwiftSpinner
import Toast_Swift

class SearchResults: UIViewController, UITableViewDelegate, UITableViewDataSource, NewsModelDelegate, UIContextMenuInteractionDelegate {

    @IBOutlet weak var searchResultTableView: UITableView!
    
    var clickedWord:String = "tesla"

    // Data
    
    var news:[News] = [News]()
    var newsData:NewsModel = NewsModel()
    var selectedNews:String?
    var stringNews:[Array] = [Array<Any>]()
    var cellSpacingHeight:CGFloat = 1.0
        
        // Defaults
        let defaults = UserDefaults.standard

        // Handling Bookmarks
        
        func handleBookmark(cell:UITableViewCell){
            // Getting the index of the news clicked
            let newsClicked = searchResultTableView.indexPath(for:cell)
            let newsClickedIndex = newsClicked!.row
            let data = self.stringNews[newsClickedIndex]
            let data_id = data[0] as! String
            // reading Data from the UserDefaults
            var isThere = false
            var count = 0
            var index:Int?
            
            let bookmark_data = UserDefaults.standard.array(forKey: "Bookmarks") as Array?
            // Loop through user Defaults to check if it already exists
            bookmark_data?.forEach{ myArrayElement in
                count = count + 1
                let news:Array = myArrayElement as! Array<Any>
                let news_id = news[0] as! String
                if data_id == news_id{
                    isThere = true
                    index = count-1
                }
            }
            print("Checking if exists")
            // If its false, then it doesnt, so append and write to userDefaults
            if isThere == false{
                if var write_bookmark = UserDefaults.standard.array(forKey: "Bookmarks") as Array?{
                    write_bookmark.append(data)
                    // If its not available, write the data to the userDefaults
                    defaults.set(write_bookmark, forKey: "Bookmarks")
                    let bookmark_data = UserDefaults.standard.array(forKey: "Bookmarks") as Array?
                    print("Bool False 1")
                    print(bookmark_data!)
                    let ucell = searchResultTableView.cellForRow(at: newsClicked!) as! SearchResultCell
                    let Bimage:UIImage! = UIImage(systemName: "bookmark.fill")
                    ucell.bookmarkButton.setImage(Bimage, for: .normal)
                    self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0, position: .bottom)
                }
                else{
                    var data_array = [Array<Any>]()
                    data_array.append(data)
                    defaults.set(data_array, forKey: "Bookmarks")
                    let bookmark_data = UserDefaults.standard.array(forKey: "Bookmarks") as Array?
                    print("Bool False 2")
                    print(bookmark_data!)
                    let ucell = searchResultTableView.cellForRow(at: newsClicked!) as! SearchResultCell
                    let Bimage:UIImage! = UIImage(systemName: "bookmark.fill")
                    ucell.bookmarkButton.setImage(Bimage, for: .normal)
                    self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0, position: .bottom)
            }
        }
            // Its its exits, remove and rewrite it to userDefaults
            else{
                print("Bool True")
                print(bookmark_data!)
                var write_bookmark:Array = UserDefaults.standard.array(forKey: "Bookmarks")! as Array
                write_bookmark.remove(at: index!)
                defaults.set(write_bookmark, forKey: "Bookmarks")
                let ucell = searchResultTableView.cellForRow(at: newsClicked!) as! SearchResultCell
                let Bimage:UIImage! = UIImage(systemName: "bookmark")
                ucell.bookmarkButton.setImage(Bimage, for: .normal)
                self.view.makeToast("Article removed from Bookmarks", duration: 2.0, position: .bottom)
            }
        }
    
    @objc func refreshPage(refreshControl: UIRefreshControl) {
        self.newsData.getSearchResults(keyword: self.clickedWord)
        refreshControl.endRefreshing()
    }
    
        override func viewDidLoad() {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
            searchResultTableView.refreshControl = refreshControl
            // News Related Data
            self.newsData.delegate = self
            SwiftSpinner.show("Loading Search Results..")
            print("Searching the word")
            self.newsData.getSearchResults(keyword: self.clickedWord)
            self.searchResultTableView.dataSource = self
            self.searchResultTableView.delegate = self
            super.viewDidLoad()
            navigationController?.navigationBar.sizeToFit()
        }
    
    var requireReload = false
    override func loadViewIfNeeded() {
        if requireReload == true{
            requireReload = false
            print("Back from Detailed Page so reloading..")
            self.searchResultTableView.reloadData()
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
                            searchResultTableView.refreshControl = refreshControl
        super.viewDidAppear(animated)
        self.newsData.delegate = self
        print("Searching the word")
        navigationController?.navigationBar.sizeToFit()
        self.newsData.getSearchResults(keyword: self.clickedWord)
        self.searchResultTableView.dataSource = self
        self.searchResultTableView.delegate = self
    }
    
        
        // DataNewsObtained
        
        func newsdataObtained(){
            self.news = self.newsData.news_data_array
            self.stringNews = self.newsData.string_news_data_array
            SwiftSpinner.hide()
            self.searchResultTableView.reloadData()
        }
        
        func weatherdataObtained(){
            self.searchResultTableView.reloadData()
        }
        
        // Table View Delegate Methods
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 130
        }

        // Two Sections -> Weather and Data
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        // There is just one row in every section
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.news.count
        }

        // Set the spacing between sections
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return self.cellSpacingHeight
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                self.selectedNews = self.news[indexPath.row].newsId
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                requireReload = true
                self.performSegue(withIdentifier:"detailedPage", sender: self)
        }
        
        // Segue
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let detailedNews = segue.destination as! DetailedViewController
            detailedNews.articleId = self.selectedNews
        }
        
        // Context Menu

        func contextMenu(cellRow:IndexPath) -> UIMenu {
        let twitterShare = UIAction(title: "Share with Twitter", image: UIImage(named:"twitter")) { _ in
            let checkText = "Check out this Article!"
            let newsClickedIndex = cellRow.row
            let data = self.stringNews[newsClickedIndex]
            let data_url = data[0] as! String
            let newsurlAndHastag = "https://theguardian.com/"  + data_url + "\n" + "#CSCI_571_NewsApp"
            let twitterDataString = "https://twitter.com/intent/tweet?text=\(checkText)&url=\(newsurlAndHastag)"
            let twitterUrlEncoded = twitterDataString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let twitterUrl = URL(string: twitterUrlEncoded)
            UIApplication.shared.open(twitterUrl!,options: [:], completionHandler: nil)
            
        }
        let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { _ in
            let ucell = self.searchResultTableView.cellForRow(at: cellRow) as! SearchResultCell
            self.handleBookmark(cell: ucell)
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
        
        func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { _ -> UIMenu? in
                return self.contextMenu(cellRow:indexPath)
                    }
        }
        
        
        // Data for each cell, accessing index through indexPath.row
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let news_data = news[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "searchresultcell") as! SearchResultCell
                cell.searchResultTitle.text = news_data.newsTitle
                cell.searchResultDuration.text = news_data.newsDuration
                cell.searchResultSection.text = news_data.newsSection
                cell.searchResultView.layer.borderColor = UIColor.lightGray.cgColor
                cell.searchResultView.layer.borderWidth = 0.5
                cell.searchResultView.layer.cornerRadius = 7
                cell.searchResultImage.layer.cornerRadius = 7
                cell.searchResultImage.image = news_data.newsImage
                // Keeping Bookmarks intact..
                let data_id = news_data.newsId
                var isThere = false
                let bookmark_data = UserDefaults.standard.array(forKey: "Bookmarks") as Array?
                bookmark_data?.forEach{ myArrayElement in
                    let news:Array = myArrayElement as! Array<Any>
                    let news_id = news[0] as! String
                    if data_id == news_id{
                        isThere = true
                    }
                }
                if isThere == false{
                    let Bimage:UIImage! = UIImage(systemName: "bookmark")
                    cell.bookmarkButton.setImage(Bimage, for: .normal)
                }
                else{
                    let Bimage:UIImage! = UIImage(systemName: "bookmark.fill")
                    cell.bookmarkButton.setImage(Bimage, for: .normal)
                }
                cell.link = self
                return cell
        }
    

}
