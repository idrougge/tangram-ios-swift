//
//  PuzzleViewController.swift
//  Tangram2
//
//  Created by Iggy Drougge on 2016-04-15.
//  Copyright © 2016 Iggy Drougge. All rights reserved.
//

import UIKit

class PuzzleViewController: UIViewController {

    var screenSize:CGRect?
    var viewSize:CGRect?
    var images:[UIImage]=[]
    var tiles:[TileButton]=[] //{didSet {print("Något petade på tiles")} }
    var tangram:Tangram?
    var puzzle:[Int]=[]
    var solution:[Int]=[]
    
    static let path:NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
    let file:String=path.stringByAppendingPathComponent("Score.plist")
    
    let timer=GameTimer(withTime: 60)
    private let tileColour:UIColor=UIColor.grayColor()
    lazy var className=String(self.dynamicType).componentsSeparatedByString(" ").last!
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("\(className).viewDidLoad()")
        screenSize=UIScreen.mainScreen().bounds      // Hämta skärmstorlek
        viewSize=view.bounds                         // Hämta vyns storlek
        viewSize=view.frame                          //       --''--
        
        guard let _puzzle=tangram?.playfield.field, let _solution=tangram?.playfield.solution
            else { fatalError() }
        self.puzzle=_puzzle
        self.solution=_solution
        
        images=buildGraphicsAssets(viewSize!, tilesPerRow: tangram!.playfield.cols, colour: tileColour)
        createButtons(self.puzzle)
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func createButtons(fromPuzzle:[Int])
    {
        let buttonSize=CGRectMake(view.frame.origin.x, view.frame.origin.y,
            view.frame.width/CGFloat(tangram!.playfield.cols), view.frame.height/CGFloat(tangram!.playfield.rows))
        for i in 0..<fromPuzzle.count
        {
            tiles.append(buttonWithTile(Tiles(nr: fromPuzzle[i]), size: buttonSize))
        }
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func buttonWithTile(tile: Tiles, size: CGRect) -> TileButton
    {
        let button:TileButton=TileButton(withFrame: size, tile: tile)
        button.setImage(images[tile.nr], forState: .Normal)
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.tintColor=tileColour
        button.addTarget(self, action: "tileWasClicked:", forControlEvents: .TouchUpInside)  // Kolonet efteråt anger att knappen ska skickas som parameter
        return button
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func layoutButtons(frame:CGRect)
    {
        print("\(className).layoutButtons(frame: \(frame))")
        var buttonSize=CGRectMake(frame.origin.x, frame.origin.y,
            frame.width/CGFloat(tangram!.playfield.rows),
            frame.height/CGFloat(tangram!.playfield.cols))
        for button in tiles{
            button.frame=buttonSize
            view.addSubview(button)
            buttonSize=CGRectMake(buttonSize.origin.x+buttonSize.width, buttonSize.origin.y,
                buttonSize.width, buttonSize.height)
            if buttonSize.origin.x>=viewSize!.width
            {
                buttonSize=CGRectMake(viewSize!.origin.x, buttonSize.origin.y+buttonSize.height,
                    buttonSize.width, buttonSize.height)
            }
        }
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func tileWasClicked(sender: TileButton!)
    {
        sender.tile=sender.tile.next()
        sender.setImage(images[sender.tile.nr],forState: .Normal)
        if completed() {
            timer.stop()
            let title=navigationController?.navigationBar.topItem?.title
            navigationController?.navigationBar.topItem?.title=NSLocalizedString("You won", comment: "Du vann!")
            let alert=UIAlertController(title: NSLocalizedString("Congratulations", comment: "Grattis"),
                message: NSLocalizedString("You solved the puzzle", comment: "Du klarade pusslet!"),
                preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"),
                style: UIAlertActionStyle.Default,
                handler: {_ in
                self.navigationController?.navigationBar.topItem?.title=title
                self.goBack()}))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func completed() ->Bool
    {
        for i in 0..<puzzle.count {
            if tiles[i].tile.nr != solution[i] { return false }
        }
        let currentScore=timer.seconds
        if currentScore>highscore {
            print("Nytt highscore: \(currentScore) > \(highscore)")
            highscore=currentScore
        }
        return true
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func goBack()
    {
        print("\(className).goBack()")
        //navigationController?.popViewControllerAnimated(true)

        let vc=parentViewController as! TangramViewController
        self.willMoveToParentViewController(vc)
        view.removeFromSuperview()
        self.removeFromParentViewController()

        vc.next()
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    var highscore:Int{
        get{
            guard let scoredict=NSDictionary(contentsOfFile: file)
                else{return 0}
            return scoredict.valueForKey("Highscore") as! Int
        }
        set{
            guard let scoredict=NSDictionary(contentsOfFile: file)
                else{print("Kunde inte öppna poänglistan för skrivning");return}
            scoredict.setValue(newValue, forKey: "Highscore")
            scoredict.writeToFile(file, atomically: true)
        }
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func buildGraphicsAssets(size: CGRect, tilesPerRow: Int, colour: UIColor) -> [UIImage]
    {
        var images:[UIImage]=[]
        let tileWidth=size.size.width/CGFloat(tilesPerRow)     // Fan så fult -- ska det vara så här?
        let tileSize=CGRect(origin: CGPointZero, size: CGSize(width: tileWidth, height: tileWidth))
        images.append(drawRectFilled(false, size: tileSize, colour: colour))
        for i in 1...4
        {
            images.append(drawTriangleWithAngle(i*90, size: tileSize, colour: colour))
        }
        images.append(drawRectFilled(true, size: tileSize, colour: colour))
        return images
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func drawTriangleWithAngle(angle:Int, size:CGRect, colour: UIColor) -> UIImage
    {
        UIGraphicsBeginImageContext(size.size)
        let context=UIGraphicsGetCurrentContext()
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
        let x=size.width-point.x
        let y=size.height-point.y
        CGContextSetStrokeColorWithColor(context, colour.CGColor)
        CGContextSetLineWidth(context, 2.0)
        CGContextMoveToPoint(context, point.x, point.y)
        CGContextAddLineToPoint(context, point.x, y)
        CGContextMoveToPoint(context, point.x, point.y)
        CGContextAddLineToPoint(context, x, point.y)
        CGContextAddLineToPoint(context, point.x, y)
        CGContextSetFillColorWithColor(context,colour.CGColor)
        CGContextDrawPath(context, CGPathDrawingMode.Fill)
        let image=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func drawRectFilled(filled:Bool, size:CGRect, colour: UIColor) -> UIImage
    {
        UIGraphicsBeginImageContext(size.size)
        let context=UIGraphicsGetCurrentContext()
        if filled
        {
            let rect=CGRectMake(size.origin.x, size.origin.y, size.width, size.height)
            CGContextSetFillColorWithColor(context,colour.CGColor)
            //CGContextSetFillColorWithColor(context,tileColour.CGColor)
            CGContextFillRect(context,rect)
        }
        let image=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("\(className).viewWillAppear()")
        screenSize=UIScreen.mainScreen().bounds      // Hämta skärmstorlek
        viewSize=view.bounds                         // Hämta vyns storlek
        print("Vyns storlek: \(viewSize!.width)x\(viewSize!.height) @ \(viewSize!.origin) max: \(viewSize!.maxX)x\(viewSize!.maxY)")
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("\(className).viewWillLayoutSubViews()")
        viewSize=view.bounds                         // Hämta vyns storlek
        print("Vyns storlek: \(viewSize!.width)x\(viewSize!.height) @ \(viewSize!.origin) max: \(viewSize!.maxX)x\(viewSize!.maxY)")
        layoutButtons(viewSize!)
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("\(className).viewDidLayoutSubViews()")
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        screenSize=UIScreen.mainScreen().bounds      // Hämta skärmstorlek
        print("\(className).viewDidAppear()")
        
        additonalSetupAfterViewDidAppear()
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func additonalSetupAfterViewDidAppear() {
        if !timer.isRunning && timer.seconds>0 {
            timer.start(withTarget: parentViewController!, selector: "tick:", finally: "timeout")
        }
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(className).viewWillDisappear()")
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(className).viewDidDisappear()")
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        print("\(className).viewWillTransitionToSize()")
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
