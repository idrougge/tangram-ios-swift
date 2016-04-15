//
//  TileButton.swift
//  Tangram2
//
//  Created by Iggy Drougge on 2016-04-11.
//  Copyright © 2016 Iggy Drougge. All rights reserved.
//

import UIKit

class TileButton: UIButton {
    var tile:Tiles

    init(withFrame frame: CGRect, tile:Tiles) {
        self.tile=tile
        super.init(frame: frame)
        print("TileButton: \(self.tile.text)")
    }
    required init?(coder aDecoder: NSCoder) {
        self.tile=Tiles(nr: 0)
        super.init(coder: aDecoder)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
