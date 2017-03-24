//
//  WHTimer.swift
//  WHTimerDemo
//
//  Created by 盖特 on 2017/3/24.
//  Copyright © 2017年 盖特. All rights reserved.
//

import UIKit

public let keyLeftTime = "com.onevcat.simpleTimer.lefttime"
public let keyQuitDate = "com.onevcat.simpleTimer.quitdate"

let timerErrorDomain = "SimpleTimerError"

public enum SimperTimerError: Int {
    case AlreadyRunning = 1001
    case NegativeLeftTime = 1002
    case NotRunning = 1003
}

extension TimeInterval {
    func toString() -> String {
        let totalSecond = Int(self)
        let minute = totalSecond / 60
        let second = totalSecond % 60
        
        switch (minute, second) {
        case (0...9, 0...9):
            return "0\(minute):0\(second)"
        case (0...9, _):
            return "0\(minute):\(second)"
        case (_, 0...9):
            return "\(minute):0\(second)"
        default:
            return "\(minute):\(second)"
        }
    }
}
class WHTimer: NSObject {
    
    public var running: Bool = false
    
    public var leftTime: TimeInterval {
        didSet {
            if leftTime < 0 {
                leftTime = 0
            }
        }
    }
    
    public var leftTimeString: String {
        get {
            return leftTime.toString()
        }
    }
    
    private var timerTickHandler: ((TimeInterval) -> ())? = nil
    private var timerStopHandler: ((Bool) ->())? = nil
    private var timer: Timer!
    
    public init(timeInteral: TimeInterval) {
        leftTime = timeInteral
    }

    
    public func start(updateTick: ((TimeInterval) -> Void)?, stopHandler: ((Bool) -> Void)?) -> (start: Bool, error: NSError?) {
        if running {
            return (false, NSError(domain: timerErrorDomain, code: SimperTimerError.AlreadyRunning.rawValue, userInfo:nil))
        }
        
        if leftTime < 0 {
            return (false, NSError(domain: timerErrorDomain, code: SimperTimerError.NegativeLeftTime.rawValue, userInfo:nil))
        }
        
        timerTickHandler = updateTick
        timerStopHandler = stopHandler
        
        running = true
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(WHTimer.countTick), userInfo: nil, repeats: true)
        
        return (true, nil)
    }

    public func stop(interrupt: Bool) -> (stopped: Bool, error: NSError?) {
        if !running {
            return (false, NSError(domain: timerErrorDomain, code: SimperTimerError.NotRunning.rawValue, userInfo:nil))
        }
        
        running = false
        timer.invalidate()
        timer = nil
        
        if let stopHandler = timerStopHandler {
            stopHandler(!interrupt)
        }
        
        timerStopHandler = nil
        timerTickHandler = nil
        
        return (true, nil)
    }
    
    
    dynamic private func countTick() {
        leftTime = leftTime - 1
        if let tickHandler = timerTickHandler {
            tickHandler(leftTime)
        }
        if leftTime <= 0 {
           let _ = stop(interrupt: false)
        }
        
    }
    
    
    
    
    
    

}
