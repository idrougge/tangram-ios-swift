//
//  Tangram.swift
//  Tangram2
//
//  Created by Iggy Drougge on 2016-04-11.
//  Copyright © 2016 Iggy Drougge. All rights reserved.
//

import Foundation

class Tangram {
    var playfield:PlayField
    var solutions:[[Int]]=[]
    init()
    {
        let puzzle=[4,5,3,
                    5,5,5,
                    1,5,4]
        let solution=[2,5,3,
                      5,5,5,
                      1,5,4]
        solutions.append(solution)
        solutions.append([0,2,3,0,
            2,5,5,3,
            1,5,5,4,
            0,1,4,0])
        //playfield=PlayField(solution: solution, puzzle: puzzle)
        //playfield=PlayField(solution: solution)
        playfield=PlayField(solution: solution, puzzle: puzzle)
        //next()
    }
    func next() -> Bool
    {
        if !solutions.isEmpty
        {
            playfield=PlayField(solution: solutions.popLast()!)
            return true
        }
        return false
    }
}