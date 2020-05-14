import UIKit

class BookmarkModel: NSObject {
    
    func getBookmarks(data:[Array<Any>]) -> [Bookmark]{
        var bookmarks = [Bookmark]()
        data.forEach{ myArrayElement in
            let bookmark_obj = Bookmark()
            bookmark_obj.articleDuration = myArrayElement[4] as! String
            bookmark_obj.articleId = myArrayElement[0] as! String
            bookmark_obj.articleSection = myArrayElement[2] as! String
            bookmark_obj.articleTitle = myArrayElement[1] as! String
            let image_details = myArrayElement[3] as! String
            if image_details == "No"{
                bookmark_obj.articleImage = UIImage(named: "default-guardian")
            }
            else{
                let img_url = image_details
                let url = URL(string: img_url)
                let data = try? Data(contentsOf: url!)
                if let imageData = data {
                    bookmark_obj.articleImage = UIImage(data: imageData)
                }
                else{
                    bookmark_obj.articleImage = UIImage(named: "default-guardian")
                }
            }
            bookmarks.append(bookmark_obj)
        }
        return bookmarks
    }

}
