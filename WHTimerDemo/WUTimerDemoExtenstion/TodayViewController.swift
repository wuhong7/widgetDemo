//
//  TodayViewController.swift
//  WUTimerDemoExtenstion
//
//  Created by 盖特 on 2017/3/27.
//  Copyright © 2017年 盖特. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var lblTimer: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let userDefaults = UserDefaults(suiteName: "group.WHTimerDemo")
        let leftTimeWhenQuit = userDefaults?.integer(forKey: "com.onevcat.simpleTimer.lefttime")
        let quitDate = userDefaults?.integer(forKey: "com.onevcat.simpleTimer.quitdate")
        
        let passedTimeFromQuit = NSDate().timeIntervalSince(NSDate(timeIntervalSince1970: TimeInterval(quitDate!)) as Date)
        
        let leftTime = leftTimeWhenQuit! - Int(passedTimeFromQuit)
        
        lblTimer.text = "\(leftTime)"
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
