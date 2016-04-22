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
    private let tileColour:UIColor=UIColor.redColor()
    lazy var className=String(self.dynamicType).componentsSeparatedByString(" ").last!
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("\(className).viewDidLoad()")
                print("superview: \(view.superview.dynamicType)")
                print("superview: \(view.superview?.bounds)")
        screenSize=UIScreen.mainScreen().bounds      // Hämta skärmstorlek
        viewSize=view.bounds                         // Hämta vyns storlek
        print("view.bounds: \(viewSize)")
        viewSize=view.frame
        print("view.frame: \(viewSize)")
        print("view.bounds: \(view.bounds)")
        
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
        print("Du klickade på en knapp med ruta \(sender.tile.text)")
        sender.tile=sender.tile.next()
        print("Rutan blev \(sender.tile.text)")
        sender.setImage(images[sender.tile.nr],forState: .Normal)
        if completed() {
            navigationController?.navigationBar.topItem?.title="Du vann!"
            let alphaView=UIView(frame: screenSize!)
            alphaView.backgroundColor=UIColor.whiteColor().colorWithAlphaComponent(0.5)
            view.superview!.superview!.addSubview(alphaView)
            performSelector("goBack", withObject: nil, afterDelay: 2.0)
        }
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func completed() ->Bool
    {
        for i in 0..<puzzle.count {
            print(i)
            print("\(tiles[i].tile.nr) <> \(solution[i])")
            if tiles[i].tile.nr != solution[i] { return false }
        }
        return true
        
        //return tangram!.playfield.completed()
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func goBack()
    {
        print("\(className).goBack()")
        //navigationController?.popViewControllerAnimated(true)
        //let vc=view.superview?.nextResponder() as! TangramViewController
        let vc=parentViewController as! TangramViewController
        self.willMoveToParentViewController(vc)
        view.removeFromSuperview()
        self.removeFromParentViewController()

        //print(vc.tangram.next())
        vc.next()
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func buildGraphicsAssets(size: CGRect, tilesPerRow: Int, colour: UIColor) -> [UIImage]
    {
        var images:[UIImage]=[]
        let tileWidth=size.size.width/CGFloat(tilesPerRow)     // Fan så fult -- ska det vara så här?
        let tileSize=CGRect(origin: CGPointZero, size: CGSize(width: tileWidth, height: tileWidth))
        images.append(drawRectFilled(false, size: tileSize))
        for i in 1...4
        {
            images.append(drawTriangleWithAngle(i*90, size: tileSize))
        }
        images.append(drawRectFilled(true, size: tileSize))
        return images
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func drawTriangleWithAngle(angle:Int, size:CGRect) -> UIImage
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
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func drawRectFilled(filled:Bool, size:CGRect) -> UIImage
    {
        UIGraphicsBeginImageContext(size.size)
        let context=UIGraphicsGetCurrentContext()
        if filled
        {
            let rect=CGRectMake(size.origin.x, size.origin.y, size.width, size.height)
            CGContextSetFillColorWithColor(context,UIColor.purpleColor().CGColor)
            //CGContextSetFillColorWithColor(context,tileColour.CGColor)
            CGContextFillRect(context,rect)
        }
        let image=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("\(className).prepareForSegue(\(segue.identifier))")
        if segue.identifier=="ShowSolution"
        {
            if let vc=segue.destinationViewController as? SolutionViewController
            {
                vc.puzzle=[4,4,4,
                    5,5,5,
                    1,5,4]
            }
        }
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
