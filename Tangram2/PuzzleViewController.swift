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
    
    let timer=GameTimer(withTime: 20)
    private let tileColour:UIColor=UIColor.grayColor()
    lazy var className=String(self.dynamicType).componentsSeparatedByString(" ").last!
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("\(className).viewDidLoad()")
        screenSize=UIScreen.mainScreen().bounds      // Hämta skärmstorlek
        viewSize=view.bounds                         // Hämta vyns storlek
        viewSize=view.frame
        
        guard let _puzzle=tangram?.playfield.field, let _solution=tangram?.playfield.solution
            else { fatalError() }
        self.puzzle=_puzzle
        self.solution=_solution
        print("\(className): self.puzzle: \(self.puzzle)")
        print("\(className): self.solution: \(self.solution)")
        
        images=buildGraphicsAssets(viewSize!, tilesPerRow: tangram!.playfield.cols, colour: tileColour)
        if puzzle.isEmpty
        {
            print("Pusslet är tomt.")
            self.puzzle=[4,5,3,
                    5,5,5,
                    1,5,4]
        }
        createButtons(self.puzzle)
        
        writeScore(2000)
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
        //button.setTitle("Hej", forState: .Normal)
        //button.setTitle("Nej", forState: UIControlState.Highlighted)
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
        //for i in 0..<tiles.count {
        //var i=0
        for button in tiles{
            button.frame=buttonSize
            //print("Ruta nr \(i++): \(button.tile.text)")
            view.addSubview(button)
            //print("button.frame: \(button.frame)")
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
        //print("Du klickade på en knapp med ruta \(sender.tile.text)")
        sender.tile=sender.tile.next()
        //print("Rutan blev \(sender.tile.text)")
        sender.setImage(images[sender.tile.nr],forState: .Normal)
        if completed() {
            timer.stop()
            let title=navigationController?.navigationBar.topItem?.title
            navigationController?.navigationBar.topItem?.title=NSLocalizedString("You won", comment: "Du vann!")
            //performSelector("goBack", withObject: nil, afterDelay: 2.0)
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
    func writeScore(score:Int)
    {
        print("\(className).writeScore()")
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        //let file:NSString?
        let file:String
        var data:NSMutableDictionary
        do {
            /*
            file = path.stringByAppendingPathComponent("Setting.plist")
            try "Bög".writeToFile(file as! String, atomically: true, encoding: NSUTF8StringEncoding)
            try "120".writeToFile(file as! String, atomically: true, encoding: NSUTF8StringEncoding)
            */
            file=path.stringByAppendingPathComponent("Score.plist")
            //data=NSMutableDictionary(contentsOfFile: file)!
            data=NSMutableDictionary()
            data.setObject(120, forKey: "Highscore")
            data.writeToFile(file, atomically: true)
            var bla:NSMutableDictionary=NSMutableDictionary(contentsOfFile: file)!
            print("Filens innehåll: \(file)")
            print("Highscore: \(bla.valueForKey("Highscore"))")
        }
        catch
        {
            print("Filhanteringsfel: Kunde inte skriva till filen")
        }
        var gurka:NSString="test"
        do {
            try gurka=NSString(contentsOfFile: file as! String, encoding: NSUTF8StringEncoding)
        }
        catch
        {
            print("Filhanteringsfel: Kunde inte öppna filen")
        }
        print("Filens innehåll: \(gurka)")

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
