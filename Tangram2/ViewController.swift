//
//  ViewController.swift
//  Tangram2
//
//  Created by Iggy Drougge on 2016-04-08.
//  Copyright © 2016 Iggy Drougge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var screenSize:CGRect?
    var viewSize:CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("viewDidLoad()")
        screenSize=UIScreen.mainScreen().bounds      // Hämta skärmstorlek
        viewSize=view.bounds                         // Hämta vyns storlek
        
        let layer:CALayer=CALayer()
        layer.frame=viewSize!
        layer.backgroundColor=UIColor.brownColor().CGColor
        
        view.layer.addSublayer(layer)
        
        let size:CGSize=CGSizeMake(200, 100)
        
        //image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        UIGraphicsBeginImageContext(size)
        let context=UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetLineWidth(context, 2.0)
        CGContextMoveToPoint(context, 0.0, 0.0)             // Flytta "pennan" till övre vänstra hörnet
        CGContextAddLineToPoint(context, 100, 100)          // Dra ett streck till koordinat 100,100
        CGContextStrokePath(context)                        // Rita slutligen strecket i kontexten
        
        //let bild=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        for i in 1...4 {
            let button:UIButton=UIButton()
            button.setTitle("Hej", forState: .Normal)
            button.setTitle("Nej", forState: UIControlState.Highlighted)
            button.setImage(drawTriangleWithAngle(i*90, size: CGRect(origin: CGPoint(x:10,y:10), size: CGSize(width: 200, height: 200))), forState: UIControlState.Normal)
            //button.setImage(drawRectFilled(true, size: CGRect(origin: CGPoint(x:10,y:10), size: CGSize(width: 200, height: 200))), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blueColor(), forState: .Normal)
            button.frame=CGRectMake(100, 100+(CGFloat(i)*100), 200, 100)
            //button.frame=CGRectMake(10,10,200,200)
            view.addSubview(button)
        }
        
    }
    
    func buildGraphicsAssets(size: CGRect, nrOfTiles: Int) -> [UIImage]
    {
        var images:[UIImage]=[]
        let tileWidth=size.size.width/CGFloat(nrOfTiles)     // Fan så fult -- ska det vara så här?
        let tileSize=CGRect(origin: CGPointZero, size: CGSize(width: tileWidth, height: tileWidth))
        images.append(drawRectFilled(false, size: tileSize))
        for i in 1...4
        {
            images.append(drawTriangleWithAngle(i*90, size: tileSize))
        }
        images.append(drawRectFilled(true, size: tileSize))
        return images
    }
    
    func drawTriangleWithAngle(angle:Int, size:CGRect) -> UIImage
    {
        UIGraphicsBeginImageContext(size.size)
        let context=UIGraphicsGetCurrentContext()
        //let l=size.width
        //let r=size.width
        let point:CGPoint
        switch(angle)
        {
        case 90:
            point=CGPoint(x: size.width,y: size.origin.y)
        case 180:
            point=CGPoint(x: size.width,y: size.height)
        case 270:
            point=CGPoint(x: size.origin.x, y: size.height)
        case 360:
            point=CGPoint(x: size.origin.x, y: size.origin.y)
        default: return UIGraphicsGetImageFromCurrentImageContext()
        }
        // 90:  200-200=0     200-0  =200
        // 180: 200-200=0     200-200=0
        // 270: 200-0  =200   200-200=0
        // 360: 200-0  =200   200-0  =200
        let x=size.width-point.x
        let y=size.height-point.y
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetLineWidth(context, 2.0)
        CGContextMoveToPoint(context, point.x, point.y)
        CGContextAddLineToPoint(context, point.x, y)
        CGContextMoveToPoint(context, point.x, point.y)
        CGContextAddLineToPoint(context, x, point.y)
        CGContextAddLineToPoint(context, point.x, y)
        //CGContextStrokePath(context)
        CGContextSetFillColorWithColor(context,UIColor.purpleColor().CGColor)
        //CGContextFillPath(context)
        CGContextDrawPath(context, CGPathDrawingMode.Fill)
        let image=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    func drawRectFilled(filled:Bool, size:CGRect) -> UIImage
    {
        UIGraphicsBeginImageContext(size.size)
        let context=UIGraphicsGetCurrentContext()
        if filled
        {
            let rect=CGRectMake(size.origin.x, size.origin.y, size.width, size.height)
            CGContextSetFillColorWithColor(context,UIColor.purpleColor().CGColor)
            CGContextFillRect(context,rect)
        }
        let image=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear()")
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        print("viewWillTransitionToSize()")
        screenSize=UIScreen.mainScreen().bounds      // Hämta skärmstorlek
        viewSize=view.bounds                         // Hämta vyns storlek
        print("Skärmstorlek: \(screenSize!.width)x\(screenSize!.height)")
        print("Vyns storlek: \(viewSize!.width)x\(viewSize!.height) @ \(viewSize!.origin) max: \(viewSize!.maxX)x\(viewSize!.maxY)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

