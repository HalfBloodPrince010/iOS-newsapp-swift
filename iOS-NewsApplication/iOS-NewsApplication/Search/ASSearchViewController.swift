import UIKit

protocol searchword{
    func sendSearchWord(word:String)
}

class ASSearchViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate,SearchModelDelegate {
     // Array of String that holds our suggestion
        var suggestionWordList = [String]()
        var searchmodel:SearchModel = SearchModel()
        var selectedWord:String?
    // Delegate
        var delegate:searchword?

    @IBOutlet weak var searchTableView: UITableView!
    func searchResultsObtained() {
            self.suggestionWordList = searchmodel.suggestionWordList
            searchTableView.reloadData()
        }

        // Load Function

        override func viewDidLoad() {
            super.viewDidLoad()
            searchmodel.delegate = self
            searchTableView.dataSource = self
            searchTableView.delegate = self
        }


        // Just One Section
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
    // This must include the number of keywords returned by the API
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suggestionWordList.count
    }
    // On Cell clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedWord = self.suggestionWordList[indexPath.row]
        if self.delegate != nil{
            self.delegate?.sendSearchWord(word:self.selectedWord!)
        }
    }

        // What should each cell be?
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            print("Display now - data:")
            print(self.suggestionWordList)
            let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchcell", for: indexPath)
            cell.textLabel?.text = self.suggestionWordList[indexPath.row]
            return cell
        }

        // delegate function for the SearchResultsUpdating
        // Implement a function to handle clicking of search results.
        func updateSearchResults(for searchController: UISearchController) {
            let searchword = searchController.searchBar.text
            if searchword!.count > 2{
                searchmodel.searchSuggestions(searchWord: searchword!)
            }
        }

        // User clicks Enter/Search instead of clicking the word
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            let searchword = searchBar.text
            if searchword!.count > 2{
                searchmodel.searchSuggestions(searchWord: searchword!)
            }
        }

        // What happens when User clicks Cancel
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            self.suggestionWordList.removeAll()
            searchTableView.reloadData()
        }

        // Start of Editing, when User clicks the search bar
        func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
            return true
        }

    }

