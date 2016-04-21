//
//  GameTimer.swift
//  Tangram2
//
//  Created by Iggy Drougge on 2016-04-20.
//  Copyright © 2016 Iggy Drougge. All rights reserved.
//

/*

This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike
4.0 International License, by Yong Bakos.

*/

import UIKit


import Foundation

class GameTimer {
    
    private var timer:NSDate=NSDate()
    var seconds:Int
    
    init(withTime time:Int){
        seconds=time
    }
    func start(){
        timer = NSDate()
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "goBack", userInfo: nil, repeats: false)
    }
    func stop(){
        //timer = nil
    }
    func reset()
    {
        timer=NSDate()
    }
}





