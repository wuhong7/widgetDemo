//
//  TodayViewController.swift
//  WUTimerDemoExtenstion
//
//  Created by 盖特 on 2017/3/27.
//  Copyright © 2017年 盖特. All rights reserved.
//

import UIKit
import NotificationCenter
import SimpleTimerKit

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var lblTimer: UILabel!
    
    var timer: WHTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userDefaults = UserDefaults(suiteName: "group.WHTimerDemo")
        let leftTimeWhenQuit = userDefaults?.integer(forKey: "com.onevcat.simpleTimer.lefttime")
        let quitDate = userDefaults?.integer(forKey: "com.onevcat.simpleTimer.quitdate")
        
        let passedTimeFromQuit = NSDate().timeIntervalSince(NSDate(timeIntervalSince1970: TimeInterval(quitDate!)) as Date)
        
        let leftTime = leftTimeWhenQuit! - Int(passedTimeFromQuit)
        
        if (leftTime > 0) {
            timer = WHTimer(timeInteral: TimeInterval(leftTime))
            let _ = timer.start(updateTick: {
                [weak self] leftTick in self!.updateLabel()
                }, stopHandler: {
                    [weak self] finished in self!.showOpenAppButton()
            })
        } else {
            showOpenAppButton()
        }
        
        
    }
    
    
    fileprivate func updateLabel() {
        lblTimer.text = timer.leftTimeString
    }
    
    fileprivate func showOpenAppButton() {
        lblTimer.text = "Finished"
        preferredContentSize = CGSize(width: 0, height: 100)
        
        let button = UIButton(frame: CGRect(x: 0, y: 50, width: 50, height: 63))
        button.setTitle("Open", for: UIControlState())
        button.addTarget(self, action: #selector(TodayViewController.buttonPressed(_:)), for: UIControlEvents.touchUpInside)
        
        view.addSubview(button)
        
    }
    
    dynamic fileprivate func buttonPressed(_ sender: AnyObject!) {
        extensionContext?.open(URL(string: "simpleTimer://finished")!, completionHandler: nil)
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
