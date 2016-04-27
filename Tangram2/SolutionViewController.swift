//
//  SolutionViewController.swift
//  Tangram2
//
//  Created by Iggy Drougge on 2016-04-15.
//  Copyright © 2016 Iggy Drougge. All rights reserved.
//

import UIKit

class SolutionViewController: PuzzleViewController {
    private let tileColour:UIColor=UIColor.blueColor()  // Detta funkar inte pga diverse skäl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Detta är SolutionViewController.")
        print("tileColour: \(tileColour)")
        print("self.puzzle: \(self.puzzle)")
        print("self.solution: \(self.solution)")
        print("tangram?.playfield.field: \(tangram?.playfield.field)")
        print("tangram?.playfield.solution: \(tangram?.playfield.solution)")

        
        guard let _puzzle=tangram?.playfield.solution
            else { fatalError() }
        self.puzzle=_puzzle
        tiles=[]
        createButtons(_puzzle)
        images=buildGraphicsAssets(viewSize!, tilesPerRow: tangram!.playfield.cols, colour: tileColour)
    }

    override func buttonWithTile(tile: Tiles, size: CGRect) -> TileButton {
        let button=super.buttonWithTile(tile, size: size)
        button.removeTarget(self, action: "tileWasClicked:", forControlEvents: .TouchUpInside)
        return button
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
