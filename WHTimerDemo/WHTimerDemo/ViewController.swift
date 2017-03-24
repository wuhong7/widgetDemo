//
//  ViewController.swift
//  WHTimerDemo
//
//  Created by 盖特 on 2017/3/24.
//  Copyright © 2017年 盖特. All rights reserved.
//

import UIKit

let defaultTimeInterval: TimeInterval = 10
let taskDidFinishedInWidgetNotification: String = "com.onevcat.simpleTimer.TaskDidFinishedInWidgetNotification"

class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default
            .addObserver(self, selector: Selector("applicationWillResignActive"),name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: "taskFinishedInWidget", name: NSNotification.Name(rawValue: taskDidFinishedInWidgetNotification), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    @IBAction func btnStartPressed(_ sender: Any) {
        
        if timer == nil {
            timer = Timer(timeInteral: defaultTimeInterval)
        }
        
        let (started, error) = timer.start(updateTick: {
            [weak self] leftTick in self!.updateLabel()
            }, stopHandler: {
                [weak self] finished in
                self!.showFinishAlert(finished: finished)
                self!.timer = nil
        })
        
        if started {
            updateLabel()
        } else {
            if let realError = error {
                println("error: \(realError.code)")
            }
        }

        
        
        
    }

    
    
    
}


