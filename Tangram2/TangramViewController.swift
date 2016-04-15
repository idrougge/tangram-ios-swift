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
               
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("\(className).prepareForSegue(\(segue.identifier))")
        switch segue.identifier! {
        case "ShowSolution": return
        case "SolutionEmbed":
            let vc=segue.destinationViewController as! SolutionViewController
            vc.puzzle=[4,4,4,
                       5,5,5,
                       1,5,4]
        case "PuzzleEmbed":
            let vc=segue.destinationViewController as! PuzzleViewController
            vc.puzzle=[4,5,2,
                5,5,5,
                1,5,4]
        default: print("Okänd segue: \(segue.identifier)")
        }
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