import UIKit
import XLPagerTabStrip
import SwiftSpinner
import Toast_Swift

class ScienceController: UIViewController, IndicatorInfoProvider, NewsModelDelegate, UIContextMenuInteractionDelegate {
    @IBOutlet weak var worldTableView: UITableView!
        var news:[News] = [News]()
        var newsData:NewsModel = NewsModel()
        var selectedNews:String?
        var stringNews:[Array] = [Array<Any>]()
    
        // Defaults
        let defaults = UserDefaults.standard
    
        // Handling Bookmarks
        
        func handleBookmark(cell:UITableViewCell){
            print("==========================================================================")
            print("Bookmark call from the controller")
            // Gettong the index of the news clicked
            let newsClicked = worldTableView.indexPath(for:cell)
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
                    let ucell = worldTableView.cellForRow(at: newsClicked!) as! ScienceSectionCell
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
                    let ucell = worldTableView.cellForRow(at: newsClicked!) as! ScienceSectionCell
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
                let ucell = worldTableView.cellForRow(at: newsClicked!) as! ScienceSectionCell
                let Bimage:UIImage! = UIImage(systemName: "bookmark")
                ucell.bookmarkButton.setImage(Bimage, for: .normal)
                self.view.makeToast("Article removed from Bookmarks", duration: 2.0, position: .bottom)
            }
        }

    
    // Refresh
    
    @objc func refreshPage(refreshControl: UIRefreshControl) {
        print("Hello World!science")
        self.newsData.getSectionHeadlines(section: "science")
        refreshControl.endRefreshing()
    }
    
    var showSpinner = true
    var isInitial = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        worldTableView.refreshControl = refreshControl
        if showSpinner == true{
            showSpinner = false
            SwiftSpinner.show("Loading SCIENCE Headlines..")
        }
        self.newsData.delegate = self
        if isInitial == true{
            isInitial = false
            self.newsData.getSectionHeadlines(section: "science")
        }
        else{
            self.worldTableView.reloadData()
        }
        self.worldTableView.dataSource = self
        self.worldTableView.delegate = self
    }
        
        // DataNewsObtained
        
        func newsdataObtained(){
            SwiftSpinner.hide()
            self.news = self.newsData.news_data_array
            self.stringNews = self.newsData.string_news_data_array
            self.worldTableView.reloadData()
        }
    
    
        func weatherdataObtained() {
            self.worldTableView.reloadData()
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                self.selectedNews = self.news[indexPath.row].newsId
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                self.performSegue(withIdentifier:"detailedPage", sender: self)
        }
        
        // Segue
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let detailedNews = segue.destination as! DetailedViewController
            detailedNews.articleId = self.selectedNews
        }
        
        
        func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
            return IndicatorInfo(title: "SCIENCE")
        }
    

        // Context Menu

        func contextMenu(cellRow:IndexPath) -> UIMenu {
        let twitterShare = UIAction(title: "Share with Twitter", image: UIImage(named:"twitter")) { _ in
            let checkText = "Check out this Article!"
            let newsClickedIndex = cellRow.row
            let data = self.stringNews[newsClickedIndex]
            let data_url = data[0] as! String
            let newsurlAndHastag = "https://theguardian.com/" + data_url + "\n" + "#CSCI_571_NewsApp"
            let twitterDataString = "https://twitter.com/intent/tweet?text=\(checkText)&url=\(newsurlAndHastag)"
            let twitterUrlEncoded = twitterDataString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let twitterUrl = URL(string: twitterUrlEncoded)
            UIApplication.shared.open(twitterUrl!,options: [:], completionHandler: nil)
        print(cellRow)
        }
        let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { _ in
            let ucell = self.worldTableView.cellForRow(at: cellRow) as! ScienceSectionCell
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

    }

    extension ScienceController : UITableViewDataSource, UITableViewDelegate{
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 130
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.news.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let news_data = news[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "scsectioncell") as! ScienceSectionCell
            cell.sectionDuration.text = news_data.newsDuration
            cell.sectionTitle.text = news_data.newsTitle
            cell.sectionNewsSection.text = news_data.newsSection
            cell.sectionImage.image = news_data.newsImage
            cell.sectionView.layer.borderColor = UIColor.lightGray.cgColor
            cell.sectionView.layer.borderWidth = 0.5
            cell.sectionView.layer.cornerRadius = 7
            cell.sectionImage.layer.cornerRadius = 7
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
            cell.sciencelink =  self
            return cell
        }
    }


