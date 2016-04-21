//
//  Tangram.swift
//  Tangram2
//
//  Created by Iggy Drougge on 2016-04-11.
//  Copyright © 2016 Iggy Drougge. All rights reserved.
//

import Foundation

class Tangram {
    let playfield:PlayField
    
    init()
    {
        let puzzle=[4,5,3,
                    5,5,5,
                    1,5,4]
        let solution=[2,5,3,
                      5,5,5,
                      1,5,4]
        //playfield=PlayField(solution: solution, puzzle: puzzle)
        playfield=PlayField(solution: solution)
        
    }
}