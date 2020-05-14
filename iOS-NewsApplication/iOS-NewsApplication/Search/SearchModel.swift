import UIKit
import Alamofire
import SwiftyJSON

protocol SearchModelDelegate {
    func searchResultsObtained()
}

class SearchModel: NSObject {
    var delegate:SearchModelDelegate?
    
    var suggestionWordList = [String]()
    
    func searchSuggestions(searchWord:String){
        print("Got called\(searchWord)")
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json",
            "Ocp-Apim-Subscription-Key":"[AUTO-SUGGEST-API-KEY]"
        ]
        let url = "https://api.cognitive.microsoft.com/bing/v7.0/suggestions?q=" + searchWord
        var suggestionList = [String]()
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            if let results = response.result.value as? [String: Any]{
                let suggestions = results["suggestionGroups"] as! NSArray?
                print("Suggestions are:")
                print(suggestions![0] as? [String: Any])
                let searches = suggestions![0] as? [String: Any]
                for searchObj in searches!["searchSuggestions"] as! NSArray{
                    let word = JSON(searchObj)
                    let suggestedWord = word["displayText"].stringValue
                    suggestionList.append(suggestedWord)
                }
            }
            print(suggestionList)
            self.suggestionWordList = suggestionList
            if self.delegate != nil{
                self.delegate?.searchResultsObtained()
        }
        }
    }

}
