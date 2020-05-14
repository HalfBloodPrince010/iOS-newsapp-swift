import UIKit
import Alamofire
import SwiftyJSON


protocol ArticleModelDelegate {
    func articleDataObtained()
}

class detailedArticleData: NSObject {
    var delegate:ArticleModelDelegate?
    var articleData = [Article]()
    var string_news_data_array = [Array<Any>]()
    // Get Data ..
    func getArticleDetails(articleId:String){
        let url = "http://newsmobileapplication-env.eba-akj22arf.us-east-1.elasticbeanstalk.com/article/"+articleId
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if let results = response.result.value{
                var articleNews = [Article]()
                var stringArrayOfNews = [Array<Any>]()
                    let article_obj = Article()
                    let news_data = JSON(results)
                    // Copy it to a string
                    var string_news = [String]()
                    string_news.append(articleId)
                    string_news.append(news_data["title"].stringValue)
                    string_news.append(news_data["section"].stringValue)
                    string_news.append(news_data["image"].stringValue)
                    string_news.append(news_data["bdate"].stringValue)
                    stringArrayOfNews.append(string_news)
                    //-----------------------------------------------
                    article_obj.articleDate = news_data["date"].stringValue
                    article_obj.articleTitle = news_data["title"].stringValue
                    article_obj.articleUrl = news_data["weburl"].stringValue
                    article_obj.articleSection = news_data["section"].stringValue
                    article_obj.articleContent = news_data["content"].stringValue
                    if news_data["image"].stringValue == "No"{
                        article_obj.articleImage = UIImage(named: "default-guardian")
                    }
                    else{
                        let img_url = news_data["image"].stringValue
                        let url = URL(string: img_url)
                        // Handle nil case
                        let data = try? Data(contentsOf: url!)
                        if data != nil{
                        if let imageData = data {
                            article_obj.articleImage = UIImage(data: imageData)
                        }
                        else{
                            article_obj.articleImage = UIImage(named: "default-guardian")
                        }
                    }
                        else{
                            article_obj.articleImage = UIImage(named: "default-guardian")
                        }
                }
                    articleNews.append(article_obj)
                self.articleData = articleNews
                self.string_news_data_array = stringArrayOfNews
                if self.delegate != nil{
                    self.delegate?.articleDataObtained()
                }
            }
        }
    }
    

}
