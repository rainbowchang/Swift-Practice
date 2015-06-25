//
//  Timer.swift
//  practice01
//
//  Created by 张长虹 on 15/6/24.
//  Copyright (c) 2015年 张长虹. All rights reserved.
//

import Foundation

class MyTimer: NSObject {
    var timer:NSTimer?
    func doTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("timerFireMethod:"), userInfo: nil, repeats:true);
        timer!.fire()
    }
    
    func timerFireMethod(timer: NSTimer) {
        var formatter = NSDateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        var strNow = formatter.stringFromDate(NSDate())
        println("\(strNow)")
    }
    
    func suspend(){
        timer?.invalidate()
        timer = nil
    }
    
}