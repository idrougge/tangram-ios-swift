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
    var tangram:Tangram=Tangram()
    //var timer:GameTimer=GameTimer(withTime: 5)
    @IBOutlet weak var gameContainer: UIView!
    @IBOutlet weak var GameButton: UIButton!
    lazy var className=String(self.dynamicType).componentsSeparatedByString(" ").last!
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("\(className).viewDidLoad()")
        screenSize=UIScreen.mainScreen().bounds      // Hämta skärmstorlek
        viewSize=view.bounds                         // Hämta vyns storlek
        viewSize=view.frame
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func tick(seconds:AnyObject){
        GameButton.setTitle(String(seconds), forState: .Normal)
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func timeout(){
        print("Tiden är ute!")
        let alert=UIAlertController(title: NSLocalizedString("sadnews", comment: "Tyvärr…"),
            message: NSLocalizedString("timeisout", comment: "Tiden tog slut"),
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"),
            style: UIAlertActionStyle.Default,
            handler: {_ in
                self.navigationController?.popViewControllerAnimated(true)}))
        presentViewController(alert, animated: true, completion: nil)
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("\(className).prepareForSegue(\(segue.identifier))")
        switch segue.identifier! {
        case "ShowSolution":
            let vc=segue.destinationViewController as! TangramViewController
            vc.tangram=tangram
        case "SolutionEmbed":
            let vc=segue.destinationViewController as! SolutionViewController
            vc.tangram=tangram
        case "PuzzleEmbed":
            let vc=segue.destinationViewController as! PuzzleViewController
            vc.tangram=tangram
        default: print("Okänd segue: \(segue.identifier)")
        }
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("\(className).viewDidAppear()")
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        print("\(className).viewWillTransitionToSize(\(size))")
        screenSize=UIScreen.mainScreen().bounds      // Hämta skärmstorlek
        viewSize=view.bounds                         // Hämta vyns storlek
        print("Skärmstorlek: \(screenSize!.width)x\(screenSize!.height)")
        print("Vyns storlek: \(viewSize!.width)x\(viewSize!.height) @ \(viewSize!.origin) max: \(viewSize!.maxX)x\(viewSize!.maxY)")
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func next()
    {
        print("\(className).next()")
        if tangram.next()
        {
            
            if shouldPerformSegueWithIdentifier("PuzzleEmbed", sender: self)
            {
                performSegueWithIdentifier("PuzzleEmbed", sender: self)
            }
        }
        else
        {
            navigationController?.popViewControllerAnimated(true)
        }
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////
/* Vid rotation av enheten anropas följande metoder:
     UIViewController.willRotateToInterfaceOrientation:duration:
     UIViewController.viewWillLayoutSubviews
     UIView.layoutSubviews
     UIViewController.viewDidLayoutSubviews
     UIViewController.willAnimateRotationToInterfaceOrientation:duration:
     UIViewController.shouldAutorotateToInterfaceOrientation:
     UIViewController.didRotateFromInterfaceOrientation:

   Vid presentation av en ViewController anropas:
     loadView
     viewDidLoad
     viewWillAppear:
     shouldAutorotateToInterfaceOrientation:
     viewWillLayoutSubviews
     UIView.layoutSubviews
     viewDidLayoutSubviews
     viewDidAppear:

   När den försvinner anropas:
     UIViewController.viewWillAppear:bounds
     UIViewController.viewWillLayoutSubviews
     UIView.layoutSubviews
     UIViewController.viewDidLayoutSubviews
     UIViewController.viewDidAppear:
*/