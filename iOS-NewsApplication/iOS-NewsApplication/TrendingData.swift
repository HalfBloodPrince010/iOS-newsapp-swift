//
//  TrendingData.swift
//  iOS-NewsApplication
//
//  Created by Prashanth Pujar on 4/19/20.
//  Copyright © 2020 Prashanth Pujar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol TrendingModelDelegate {
    // Set of function definations
    func trendingDataObtained()
}

class TrendingData: NSObject {
    var trending_data = [Int]()
    var delegate:TrendingModelDelegate?
    
    func getTrendingData(searchWord:String){
        let url = "http://newsmobileapplication-env.eba-akj22arf.us-east-1.elasticbeanstalk.com/googletrends/"+searchWord
        var data_array = [Int]()
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if let results = response.result.value{
                let result = JSON(results)
                for value in result["values"].arrayValue{
                    data_array.append(value.intValue)
                }
                self.trending_data = data_array
                if self.delegate != nil{
                    print("Inside Delegate")
                    self.delegate?.trendingDataObtained()
                }
            }
        }
        
    }
    

}
