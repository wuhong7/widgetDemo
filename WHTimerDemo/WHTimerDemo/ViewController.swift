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
    
    var timer: WHTimer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default
            .addObserver(self, selector: #selector(ViewController.applicationWillResignActive),name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(ViewController.taskFinishedInWidget), name: NSNotification.Name(rawValue: taskDidFinishedInWidgetNotification), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    @IBAction func btnStartPressed(_ sender: Any) {
        
        if timer == nil {
            timer = WHTimer(timeInteral: defaultTimeInterval)
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
                print("error: \(realError.code)")
            }
        }
        
    }
    
    
    @IBAction func btnStopPressed(_ sender: Any) {
        
        if let realTimer = timer {
            let (stopped, error) = realTimer.stop(interrupt: true)
            if !stopped {
                if let realError = error {
                    print("error: \(realError.code)")
                }
            }
        }
        
    }

    
    
    
}

extension ViewController{
    
    fileprivate func updateLabel() {
        timerLabel.text = timer.leftTimeString
    }
    
    dynamic func applicationWillResignActive() {
        if timer == nil {
            clearDefaults()
        } else {
            if timer.running {
                saveDefaults()
            } else {
                clearDefaults()
            }
        }
    }
    
    dynamic func taskFinishedInWidget() {
        if let realTimer = timer {
            let (stopped, error) = realTimer.stop(interrupt: false)
            if !stopped {
                if let realError = error {
                    print("error: \(realError.code)")
                }
            }
        }
    }
    
    private func saveDefaults() {
        if let userDefault = UserDefaults(suiteName: "group.simpleTimerSharedDefaults") {
            userDefault.set(Int(timer.leftTime), forKey: keyLeftTime)
            userDefault.set(Int(NSDate().timeIntervalSince1970), forKey: keyQuitDate)
            
            userDefault.synchronize()
        }
    }
    
    private func clearDefaults() {
        if let userDefault = UserDefaults(suiteName: "group.simpleTimerSharedDefaults") {
            userDefault.removeObject(forKey: keyLeftTime)
            userDefault.removeObject(forKey: keyQuitDate)
            
            userDefault.synchronize()
        }
    }
    
    fileprivate func showFinishAlert(finished: Bool) {
        let ac = UIAlertController(title: nil , message: finished ? "Finished" : "Stopped", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak ac] action in ac!.dismiss(animated: true, completion: nil)}))
        
        present(ac, animated: true, completion: nil)
    }


}
