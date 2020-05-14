import UIKit
import Alamofire
import CoreLocation
import SwiftSpinner
import Toast_Swift

class HomeViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, NewsModelDelegate, CLLocationManagerDelegate, UIContextMenuInteractionDelegate, UISearchControllerDelegate, searchword {

    func sendSearchWord(word: String) {
        print("The word sent through delegate\(word)")
        var encoded_word = word.replacingOccurrences(of: " ", with: "%20")
        let storyBoard : UIStoryboard = UIStoryboard(name: "SearchResults", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SearchResultsStory") as! SearchResults
        nextViewController.clickedWord = encoded_word
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }


    @IBOutlet weak var headlineTableView: UITableView!
    var cellSpacingHeight:CGFloat = 1.0

    var news:[News] = [News]()
    var newsData:NewsModel = NewsModel()
    var selectedNews:String?
    var stringNews:[Array] = [Array<Any>]()

    // Defaults
    let defaults = UserDefaults.standard

    // Weather
    var state:String = "California"
    var city:String = ""
    var weather:[Weather] = [Weather]()
    let myLocation = CLLocationManager()

    // Handling Bookmarks

    func handleBookmark(cell:UITableViewCell){
        // Getting the index of the news clicked
        let newsClicked = headlineTableView.indexPath(for:cell)
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
                let ucell = headlineTableView.cellForRow(at: newsClicked!) as! NewsCell
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
                let ucell = headlineTableView.cellForRow(at: newsClicked!) as! NewsCell
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
            let ucell = headlineTableView.cellForRow(at: newsClicked!) as! NewsCell
            let Bimage:UIImage! = UIImage(systemName: "bookmark")
            ucell.bookmarkButton.setImage(Bimage, for: .normal)
            self.view.makeToast("Article removed from Bookmarked", duration: 2.0, position: .bottom)
        }
    }

        @objc func refreshPage(refreshControl: UIRefreshControl) {
            print("Hello World!")
            self.newsData.getNewsHeadlines()
            refreshControl.endRefreshing()
        }

    // Initializing different view controller for search Results

    var resultsTableView : ASSearchViewController?


    // View Loading
    var showSpinner = true
    var isInitial = true
    override func viewDidLoad() {
    super.viewDidLoad()
//        self.extendedLayoutIncludesOpaqueBars = true
        // Refresh
        let refreshControl = UIRefreshControl()
        headlineTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        self.newsData.delegate = self
        if showSpinner == true{
            showSpinner = false
            SwiftSpinner.show("Loading Homepage..")
            }
        self.headlineTableView.dataSource = self
        self.headlineTableView.delegate = self
        myLocation.delegate = self
        self.newsData.getNewsHeadlines()
        // Weather
        myLocation.desiredAccuracy = kCLLocationAccuracyBest
        myLocation.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
        myLocation.startUpdatingLocation()
        }
        resultsTableView = UIStoryboard(name: "ASSearchBar", bundle: nil).instantiateViewController(withIdentifier: "searchresultcontoller") as? ASSearchViewController
        resultsTableView?.delegate = self
        navigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.headlineTableView.reloadSections([1], with: .none)
    }

//    var prevdata = UserDefaults.standard.array(forKey: "Bookmarks") as? String
    override func loadViewIfNeeded() {
        if requireReload == true{
            requireReload = false
            print("Back from Detailed Page so reloading..")
            self.headlineTableView.reloadData()
        }
    }


    // Navigation and Search Bar

    func navigationBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        let search = UISearchController(searchResultsController: resultsTableView)
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.sizeToFit()
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        // Search Delegate is self
        search.delegate = resultsTableView as? UISearchControllerDelegate
        // ResultUpdater and SearchBar Delegates are the assigned Controller
        search.searchResultsUpdater = resultsTableView
        definesPresentationContext = true
    // We Usually create a Search Bar and then assign Delegate, but for Navigation Search Controller it comes inbuilt, so we just assign the delegate
        search.searchBar.delegate = resultsTableView
        search.hidesNavigationBarDuringPresentation = true
        // PlaceHolder
        search.searchBar.placeholder = "Enter Keyword .."
    }

    // Methods confirming to location delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location_coordinates:CLLocation = locations[0] as CLLocation
        let location_name = CLGeocoder()
        location_name.reverseGeocodeLocation(location_coordinates){ (placemarks, error) in
            let location_mark = placemarks! as [CLPlacemark]
            if location_mark.count>0{
                let location_mark = placemarks![0]
                print(location_mark.locality!)
                print(location_mark.administrativeArea!)
                print(location_mark.country!)
                self.city = location_mark.locality!
                self.state = location_mark.administrativeArea!
                let encoded_city = self.city.replacingOccurrences(of: " ", with: "%20")
                self.newsData.getWeatherDeatails(location: encoded_city)
    }
  }
}

    // DataNewsObtained

    func newsdataObtained(){
        print("loading data..")
        self.news = self.newsData.news_data_array
        self.stringNews = self.newsData.string_news_data_array
        self.headlineTableView.reloadData()
    }

    func weatherdataObtained(){
        SwiftSpinner.hide()
        self.weather = self.newsData.weather_data_obj
        self.headlineTableView.reloadData()
    }

    // Table View Delegate Methods

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 110
        }
        else{
            return 130
        }
    }

    // Two Sections -> Weather and Data
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if weather.count>0{
            return 1
            }
            else{
                return 0
            }
        }
        else{
            return self.news.count
        }
    }

    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.cellSpacingHeight
    }

    var requireReload = false
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            self.selectedNews = self.news[indexPath.row].newsId
            requireReload = true
            self.performSegue(withIdentifier:"detailedPage", sender: self)

        }
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
        print(cellRow)
    }
    let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { _ in
        let ucell = self.headlineTableView.cellForRow(at: cellRow) as! NewsCell
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
        if indexPath.section == 0{
            let weather_data = weather[indexPath.row]
            let cell =  tableView.dequeueReusableCell(withIdentifier: "weatherdetails") as! Weathercell
            cell.weatherCity.text = self.city
            cell.weatherState.text = self.state
            cell.weatherType.text = weather_data.weatherType
            let temperature:Float? = Float(weather_data.weatherTemp)
            let temp = NSString(format: "%.0f", temperature!)
            let display_temp:String = temp as String
            cell.weatherTemp.text = display_temp + "°C"
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 7
            if weather_data.weatherType == "Clouds"{
                cell.backgroundView = UIImageView(image: UIImage(named: "cloudy_weather")!)
            }
            else if weather_data.weatherType == "Clear"{
                cell.backgroundView = UIImageView(image: UIImage(named: "clear_weather")!)
            }
            else if weather_data.weatherType == "Snow"{
                cell.backgroundView = UIImageView(image: UIImage(named: "snowy_weather")!)
            }
            else if weather_data.weatherType == "Rain"{
                cell.backgroundView = UIImageView(image: UIImage(named: "rainy_weather")!)
            }
            else if weather_data.weatherType == "Thunderstorm"{
                cell.backgroundView = UIImageView(image: UIImage(named: "thunder_weather")!)
            }
            else{
                cell.backgroundView = UIImageView(image: UIImage(named: "sunny_weather")!)
            }
            return cell

        }
        else{
            let news_data = news[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "newscell") as! NewsCell
            cell.newsTitle.text = news_data.newsTitle
            cell.newsDuration.text = news_data.newsDuration
            cell.newsSection.text = news_data.newsSection
            cell.newsCellView.layer.borderColor = UIColor.lightGray.cgColor
            cell.newsCellView.layer.borderWidth = 0.5
            cell.newsCellView.layer.cornerRadius = 7
            cell.newsImage.layer.cornerRadius = 7
            cell.newsImage.image = news_data.newsImage
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

}

