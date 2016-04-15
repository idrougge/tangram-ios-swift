//
//  TangramViewController.swift
//  Tangram2
//
//  Created by Iggy Drougge on 2016-04-13.
//  Copyright © 2016 Iggy Drougge. All rights reserved.
//

import UIKit

class TangramViewController: UIViewController {

    var screenSize:CGRect?
    var viewSize:CGRect?
    var images:[UIImage]=[]
    @IBOutlet weak var gameContainer: UIView!
    
    lazy var className=String(self.dynamicType).componentsSeparatedByString(" ").last!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("\(className).viewDidLoad()")
        screenSize=UIScreen.mainScreen().bounds      // Hämta skärmstorlek
        viewSize=view.bounds                         // Hämta vyns storlek
        print("view.bounds: \(viewSize)")
        viewSize=view.frame
        print("view.frame: \(viewSize)")
        //viewSize=gameContainer.frame
        print("container.frame: \(viewSize)")
        //print("container.frame.size: \(gameContainer.frame.size)")
        
        let layer:CALayer=CALayer()
        layer.frame=viewSize!
        layer.backgroundColor=UIColor.brownColor().CGColor
        
        //view.layer.addSublayer(layer)
        //view.layer.insertSublayer(layer, above: view.layer)
        
        images=buildGraphicsAssets(viewSize!, nrOfTiles: 3)
        //let puzzleController=PuzzleViewController()
        //addChildViewController(puzzleController)
    }
    
    func clickTile()
    {
        print("Du klickade på en knapp")
    }
    func clickTile(sender: TileButton!)
    {
        print("Du klickade på en knapp med ruta \(sender.tile.text)")
        sender.tile=sender.tile.next()
        print("Rutan blev \(sender.tile.text)")
        sender.setImage(images[sender.tile.nr],forState: .Normal)
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
        print("\(className).viewDidAppear()")
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        print("\(className).viewWillTransitionToSize(\(size))")
        screenSize=UIScreen.mainScreen().bounds      // Hämta skärmstorlek
        viewSize=view.bounds                         // Hämta vyns storlek
        print("Skärmstorlek: \(screenSize!.width)x\(screenSize!.height)")
        print("Vyns storlek: \(viewSize!.width)x\(viewSize!.height) @ \(viewSize!.origin) max: \(viewSize!.maxX)x\(viewSize!.maxY)")
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
