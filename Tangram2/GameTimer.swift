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

class GameTimer:NSObject {
    
    //private var timer:NSDate//=NSDate()
    private var timer:NSTimer
    var seconds:Int
    var isRunning:Bool=false
    private var target:AnyObject?
    private var selector:Selector=""
    private var finalCall:Selector=""
    
    init(withTime time:Int){
        //timer=NSDate()
        timer=NSTimer()//.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tick:", userInfo: nil, repeats: true)
        seconds=time
    }
    
    func start(){
        //timer = NSDate()
        //NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tick:", userInfo: nil, repeats: true)
        start(withTarget: self, selector: "dummy:", finally: "dummy:")
    }
    func start(withTarget target:AnyObject, selector:Selector, finally:Selector){
        //timer=NSTimer.scheduledTimerWithTimeInterval(1.0, target: target, selector: selector, userInfo: nil, repeats: true)
        timer=NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tick:", userInfo: nil, repeats: true)
        self.target=target
        self.selector=selector
        self.finalCall=finally
        isRunning=true
        target.performSelector(selector, withObject: seconds)
    }
    func tick(argtimer: NSTimer){
        seconds-=1
        //print("Sekunder kvar: \(seconds)")
        //target!.performSelector(selector)
        target?.performSelector(selector, withObject: seconds)
        if seconds<=0
        {
            target!.performSelector(finalCall)
            stop()
        }
    }
    func stop(){
        print("Stoppar timern.")
        timer.invalidate()
        isRunning=false
    }
    func reset()
    {
        //timer=NSDate()
    }
    func dummy(argtimer:NSTimer){
        //print("Dummyfunktion")
    }
}





