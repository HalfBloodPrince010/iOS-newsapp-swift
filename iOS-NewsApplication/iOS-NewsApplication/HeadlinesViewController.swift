
import UIKit
import XLPagerTabStrip

class HeadlinesViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        self.buttonBarCustomization()
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        // Add Nodes here ..
        let child_1 = UIStoryboard(name: "Headlines", bundle: nil).instantiateViewController(identifier:"worldSID")
        let child_2 = UIStoryboard(name: "Headlines", bundle: nil).instantiateViewController(identifier:"businessSID")
        let child_3 = UIStoryboard(name: "Headlines", bundle: nil).instantiateViewController(identifier:"politicsSID")
        let child_4 = UIStoryboard(name: "Headlines", bundle: nil).instantiateViewController(identifier:"technologySID")
        let child_5 = UIStoryboard(name: "Headlines", bundle: nil).instantiateViewController(identifier:"scienceSID")
        return [child_1, child_2, child_3, child_4, child_5]
    }
    
    func buttonBarCustomization(){
        self.settings.style.selectedBarHeight = 2
        self.settings.style.buttonBarBackgroundColor = UIColor.black
        self.settings.style.buttonBarMinimumInteritemSpacing = 3.0
        self.settings.style.buttonBarMinimumLineSpacing = 0
        self.settings.style.buttonBarLeftContentInset = 0
        self.settings.style.buttonBarRightContentInset = 0
        self.settings.style.selectedBarBackgroundColor = .white
        self.settings.style.buttonBarItemBackgroundColor = .black
        self.settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 18)
        self.settings.style.buttonBarItemLeftRightMargin = 8
        self.settings.style.buttonBarItemTitleColor = .black
        self.settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
        guard changeCurrentIndex == true else { return }

        oldCell?.label.textColor = UIColor(white: 1, alpha: 0.6)
        newCell?.label.textColor = UIColor.white
        
    }
}

}
