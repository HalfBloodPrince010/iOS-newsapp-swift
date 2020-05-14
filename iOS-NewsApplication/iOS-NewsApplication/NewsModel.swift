import UIKit
import Alamofire
import SwiftyJSON


// To notify when the data is data, we create a protocol
protocol NewsModelDelegate {
    // Set of function definations
    func newsdataObtained()
    func weatherdataObtained()
}


class NewsModel: NSObject {
    
    var news_data_array = [News]()
    var string_news_data_array = [Array<Any>]()
    
    var temperature:String?
    var summary:String?
    var weather_data_obj = [Weather]()
    var delegate:NewsModelDelegate?
    
    // Function to fetch News Details
    func getWeatherDeatails(location:String){
        let url="https://api.openweathermap.org/data/2.5/weather?q="+location+"&units=metric&appid=[OPENWEATHER-API-KEY]"
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if let weatherData = response.result.value {
                var weather_data = [Weather]()
                let weather_obj = Weather()
                let weather = JSON(weatherData)
//                print("Getting Weather Data")
                let main = weather["main"]
                let temp_main = JSON(main)
                let temperature = temp_main["temp"].stringValue
//                print(" Temparature \(temperature)")
                weather_obj.weatherTemp = temperature
                let summary = weather["weather"].arrayValue
                for sum in summary {
                    let sum1 = JSON(sum)
                    let weather_summary = sum1["main"].stringValue
//                    print("Weather Summary\(weather_summary)")
                    weather_obj.weatherType = weather_summary
                }
                weather_data.append(weather_obj)
                self.weather_data_obj = weather_data
//                print("Weather data inisde object\(self.weather_data_obj[0].weatherType)")
                if self.delegate != nil{
                    self.delegate?.weatherdataObtained()
                }
            }
        }
    }

    
    // Function to fetch News
    func getNewsHeadlines(){
        Alamofire.request("http://newsmobileapplication-env.eba-akj22arf.us-east-1.elasticbeanstalk.com/headlines", method: .get).responseJSON { (response) in
            if let results = response.result.value{
                var arrayOfNews = [News]()
                var stringArrayOfNews = [Array<Any>]()
                for news in results as! NSArray{
                    let news_obj = News()
                    var string_news = [String]()
                    let news_data = JSON(news)
                    // String Data
                    string_news.append(news_data["id"].stringValue)
                    string_news.append(news_data["title"].stringValue)
                    string_news.append(news_data["section"].stringValue)
                    string_news.append(news_data["image"].stringValue)
                    string_news.append(news_data["bdate"].stringValue)
                    stringArrayOfNews.append(string_news)
                    // ------------------------------------------------
                    news_obj.newsDuration = news_data["duration"].stringValue
                    news_obj.newsId = news_data["id"].stringValue
                    news_obj.newsTitle = news_data["title"].stringValue
                    news_obj.newsSection = news_data["section"].stringValue
                    if news_data["image"].stringValue == "No"{
                        news_obj.newsImage = UIImage(named: "default-guardian")
                    }
                    else{
                        let img_url = news_data["image"].stringValue
                        let url = URL(string: img_url)
                        let data = try? Data(contentsOf: url!)
                        if let imageData = data {
                            news_obj.newsImage = UIImage(data: imageData)
                        }
                        else{
                            news_obj.newsImage = UIImage(named: "default-guardian")
                        }
                    }
                    arrayOfNews.append(news_obj)
                }
                self.news_data_array = arrayOfNews
                self.string_news_data_array = stringArrayOfNews
                if self.delegate != nil{
                    self.delegate?.newsdataObtained()
                }
            }
        }
    }
    
    // Getting Search Results
    
    func getSearchResults(keyword:String){
        let url = "http://newsmobileapplication-env.eba-akj22arf.us-east-1.elasticbeanstalk.com/searchresults/" + keyword
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if let results = response.result.value{
                var arrayOfNews = [News]()
                var stringArrayOfNews = [Array<Any>]()
                for news in results as! NSArray{
                    let news_obj = News()
                    var string_news = [String]()
                    let news_data = JSON(news)
                    // String Data
                    string_news.append(news_data["id"].stringValue)
                    string_news.append(news_data["title"].stringValue)
                    string_news.append(news_data["section"].stringValue)
                    string_news.append(news_data["image"].stringValue)
                    string_news.append(news_data["bdate"].stringValue)
                    stringArrayOfNews.append(string_news)
                    // ------------------------------------------------
                    news_obj.newsDuration = news_data["duration"].stringValue
                    news_obj.newsId = news_data["id"].stringValue
                    news_obj.newsTitle = news_data["title"].stringValue
                    news_obj.newsSection = news_data["section"].stringValue
                    if news_data["image"].stringValue == "No"{
                        news_obj.newsImage = UIImage(named: "default-guardian")
                    }
                    else{
                        let img_url = news_data["image"].stringValue
                        let url = URL(string: img_url)
                        let data = try? Data(contentsOf: url!)
                        if let imageData = data {
                            news_obj.newsImage = UIImage(data: imageData)
                        }
                        else{
                            news_obj.newsImage = UIImage(named: "default-guardian")
                        }
                    }
                    arrayOfNews.append(news_obj)
                }
                self.news_data_array = arrayOfNews
                self.string_news_data_array = stringArrayOfNews
                if self.delegate != nil{
                    self.delegate?.newsdataObtained()
                }
            }
        }
    }
    
    
    
    // Getting Section Data
    
    func getSectionHeadlines(section:String){
        let url = "http://newsmobileapplication-env.eba-akj22arf.us-east-1.elasticbeanstalk.com/guardian/" + section
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if let results = response.result.value{
                var arrayOfNews = [News]()
                var stringArrayOfNews = [Array<Any>]()
                for news in results as! NSArray{
                    let news_obj = News()
                    var string_news = [String]()
                    let news_data = JSON(news)
                    // String Data
                    string_news.append(news_data["id"].stringValue)
                    string_news.append(news_data["title"].stringValue)
                    string_news.append(news_data["section"].stringValue)
                    string_news.append(news_data["image"].stringValue)
                    string_news.append(news_data["bdate"].stringValue)
                    stringArrayOfNews.append(string_news)
                    // ------------------------------------------------
                    news_obj.newsDuration = news_data["duration"].stringValue
                    news_obj.newsId = news_data["id"].stringValue
                    news_obj.newsTitle = news_data["title"].stringValue
                    news_obj.newsSection = news_data["section"].stringValue
                    if news_data["image"].stringValue == "No"{
                        news_obj.newsImage = UIImage(named: "default-guardian")
                    }
                    else{
                        let img_url = news_data["image"].stringValue
                        let url = URL(string: img_url)
                        let data = try? Data(contentsOf: url!)
                        if let imageData = data {
                            news_obj.newsImage = UIImage(data: imageData)
                        }
                        else{
                            news_obj.newsImage = UIImage(named: "default-guardian")
                        }
                    }
                    arrayOfNews.append(news_obj)
                }
                self.news_data_array = arrayOfNews
                self.string_news_data_array = stringArrayOfNews
                
                // Only if someone is assigned to the delegate we call the function
                // Assigned to delegate in other controller like self.obj.delegate = self
                
                if self.delegate != nil{
                    self.delegate?.newsdataObtained()
                }
            }
        }
    }
    
    
    
}
