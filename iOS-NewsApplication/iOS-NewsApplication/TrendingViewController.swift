import UIKit
import Charts

class TrendingViewController: UIViewController, UITextFieldDelegate, TrendingModelDelegate {
    @IBOutlet weak var lineChartTrending: LineChartView!
    @IBOutlet weak var searchWord: UITextField!
    var trending = TrendingData()
    var trendingData = [Int]()
    var currentWord:String = "Coronavirus"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchWord.delegate = self
        self.trending.delegate = self
        trending.getTrendingData(searchWord:"Coronavirus")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if searchWord.text!.count != 0 {
            let word = searchWord.text
            self.currentWord = word!
            trending.getTrendingData(searchWord:word!)
            print(searchWord.text!)
        }
        return true
    }
    
    func trendingDataObtained() {
        self.trendingData = trending.trending_data
        var chartvalues:[ChartDataEntry] = [ChartDataEntry]()
        // Dataset for chart
        for (counter, value) in self.trendingData.enumerated() {
            let x = Double(counter)
            let y = Double(value)
          let point = ChartDataEntry(x: x, y: y)
            chartvalues.append(point)
        }
        let label_ = "Trending data for "+self.currentWord
        let set1 = LineChartDataSet(entries: chartvalues, label: label_)
        let data = LineChartData(dataSet: set1)
        set1.colors = [NSUIColor.link]
        set1.circleColors = [NSUIColor.link]
        set1.circleHoleColor = NSUIColor.link
        set1.circleRadius = 4.5
        self.lineChartTrending.data = data
    }
        
}
