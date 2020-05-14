import UIKit
import SwiftSpinner
import Toast_Swift

class DetailedViewController: UIViewController, ArticleModelDelegate {
    var articleId:String? = ""
    var articleData:detailedArticleData = detailedArticleData()
    var article_Data:[Article] = [Article]()
    var stringNews:[Array] = [Array<Any>]()
    
    // Defaults
    let defaults = UserDefaults.standard

    @IBOutlet weak var articleSection: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    
    @IBOutlet weak var articleDate: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    
    @IBAction func viewFullNews(_ sender: Any) {
        if article_Data.count>0{
            let data = self.article_Data[0]
            openUrl(url: data.articleUrl)
        }
        
    }
    @IBOutlet weak var articleContent: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        print(articleId!)
        SwiftSpinner.show("Loading Detailed article..")
        self.articleData.delegate = self
        articleData.getArticleDetails(articleId: articleId!)
        // Button Items
    }
    
    var articleBookmarked = false
    
    func loadButton(){
        print("Loading Buttons")
        // Twitter
        let twitterButton = UIButton(type: .system)
        twitterButton.setImage(UIImage(named: "twitter"), for: .normal)
        twitterButton.addTarget(self, action: #selector(twitterShare), for: .touchUpInside)
        let share = UIBarButtonItem(customView: twitterButton)
        // Bookmark
        let bookmarkButton = UIButton(type: .system)
        bookmarkButton.addTarget(self, action: #selector(handleBookmark), for: .touchUpInside)
        //------------ Button Image -----------------
        let data = self.stringNews[0]
        let data_id = data[0] as! String
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
                bookmarkButton.setImage(Bimage, for: .normal)
                }
            // Its its exits, remove and rewrite it to userDefaults
            else{
                let Bimage:UIImage! = UIImage(systemName: "bookmark.fill")
                bookmarkButton.setImage(Bimage, for: .normal)
            
            }
        //-------------------End---------------------
        let add = UIBarButtonItem(customView: bookmarkButton)
        let fixedSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 36.0
        navigationItem.rightBarButtonItems = [share, fixedSpace ,add]
    }
    
    @objc func twitterShare(){
        print("Twitter Share")
        let checkText = "Check out this Article!"
        let data = self.article_Data[0]
        let data_url = data.articleUrl
        let newsurlAndHastag = data_url + "\n" + "#CSCI_571_NewsApp"
        let twitterDataString = "https://twitter.com/intent/tweet?text=\(checkText)&url=\(newsurlAndHastag)"
        let twitterUrlEncoded = twitterDataString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let twitterUrl = URL(string: twitterUrlEncoded)
        UIApplication.shared.open(twitterUrl!,options: [:], completionHandler: nil)
        
    }
    
    @objc func handleBookmark(){
        print("Bookmark Clicked")
        let data = self.stringNews[0]
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
        // If its false, then it doesnt, so append and write to userDefaults
        if isThere == false{
            self.articleBookmarked = true
            if var write_bookmark = UserDefaults.standard.array(forKey: "Bookmarks") as Array?{
                write_bookmark.append(data)
                // If its not available, write the data to the userDefaults
                defaults.set(write_bookmark, forKey: "Bookmarks")
                self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0, position: .bottom)
                }
                else{
                    var data_array = [Array<Any>]()
                    data_array.append(data)
                    defaults.set(data_array, forKey: "Bookmarks")
                    self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0, position: .bottom)
            }
        }
            // Its its exits, remove and rewrite it to userDefaults
            else{
                self.articleBookmarked = false
                var write_bookmark:Array = UserDefaults.standard.array(forKey: "Bookmarks")! as Array
                write_bookmark.remove(at: index!)
                defaults.set(write_bookmark, forKey: "Bookmarks")
                self.view.makeToast("Article removed from Bookmarks", duration: 2.0, position: .bottom)
            }
        self.loadButton()
    }
    
    func openUrl(url:String!){
        if let URL = URL(string:url), !URL.absoluteString.isEmpty {
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        }
    }
        
    func articleDataObtained(){
        self.article_Data = self.articleData.articleData
        self.stringNews = self.articleData.string_news_data_array
        self.loadButton()
        let data = self.article_Data[0]
        SwiftSpinner.hide()
        self.navigationItem.title = data.articleTitle
        self.articleImage.image = data.articleImage
        self.articleTitle.text = data.articleTitle
        self.articleSection.text = data.articleSection
        self.articleDate.text = data.articleDate
        let htmlContent = data.articleContent
        self.articleContent.attributedText = htmlContent.htmlToAttributedString
    }
    
}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
