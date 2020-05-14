import UIKit
import XLPagerTabStrip


class HeadlinesView: ButtonBarPagerTabStripViewController, UISearchControllerDelegate,searchword {
    func sendSearchWord(word: String) {
        print("The word sent through delegate\(word)")
        var encoded_word = word.replacingOccurrences(of: " ", with: "%20")
        let storyBoard : UIStoryboard = UIStoryboard(name: "SearchResults", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SearchResultsStory") as! SearchResults
        nextViewController.clickedWord = encoded_word
        self.navigationController?.pushViewController(nextViewController, animated: true)
//        self.resultsTableView?.dismiss(animated: true, completion: nil)
    }


    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    
    override func viewDidLoad() {
    // Styling
    self.buttonCustomization()
    super.viewDidLoad()
        self.navigationController?.view.backgroundColor = UIColor.white
//        self.extendedLayoutIncludesOpaqueBars = true
        resultsTableView = UIStoryboard(name: "ASSearchBar", bundle: nil).instantiateViewController(withIdentifier: "searchresultcontoller") as? ASSearchViewController
        resultsTableView?.delegate = self
//        self.automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 13, *)
        {
            let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
           // ADD THE STATUS BAR AND SET A CUSTOM COLOR
           let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
           if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
              statusBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
           }
           UIApplication.shared.statusBarStyle = .lightContent
        }
    navigationBar()
        print("Navigation controller\(String(describing: self.navigationController))")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // Navigation and Search Bar
    var resultsTableView : ASSearchViewController?
    func navigationBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        let search = UISearchController(searchResultsController: resultsTableView)
        self.navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        search.delegate = resultsTableView as? UISearchControllerDelegate
        search.searchResultsUpdater = resultsTableView
        self.definesPresentationContext = false
        search.obscuresBackgroundDuringPresentation = true
        search.loadViewIfNeeded()
        // We Usually create a Search Bar and then assign Delegate, but for Navigation Search Controller it comes inbuilt, so we just assign the delegate
        search.searchBar.delegate = resultsTableView
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.placeholder = "Enter Keyword .."
    }


    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let child_1 = UIStoryboard(name: "Headlines", bundle: nil).instantiateViewController(withIdentifier: "world")
    let child_2 = UIStoryboard(name: "Headlines", bundle: nil).instantiateViewController(withIdentifier: "business")
    let child_3 = UIStoryboard(name: "Headlines", bundle: nil).instantiateViewController(withIdentifier: "politics")
    let child_4 = UIStoryboard(name: "Headlines", bundle: nil).instantiateViewController(withIdentifier: "sports")
    let child_5 = UIStoryboard(name: "Headlines", bundle: nil).instantiateViewController(withIdentifier: "technology")
    let child_6 = UIStoryboard(name: "Headlines", bundle: nil).instantiateViewController(withIdentifier: "science")
    return [child_1, child_2, child_3, child_4, child_5, child_6]
    }

    func buttonCustomization(){
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = .link
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 16)
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .link
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
        guard changeCurrentIndex == true else { return }
        oldCell?.label.textColor = .gray
//        newCell?.label.textColor = self?.purpleInspireColor
            newCell?.label.textColor = .link

        }
    }


}


