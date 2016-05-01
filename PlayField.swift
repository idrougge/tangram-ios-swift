//
//  PlayField.swift
//  Tangram2
//
//  Created by Iggy Drougge on 2016-04-11.
//  Copyright © 2016 Iggy Drougge. All rights reserved.
//

import Foundation

public class PlayField {
    static private let MINROWS=3
    static private let MINCOLS=3
    static private let MINTILES=MINROWS*MINCOLS
    public var rows=MINROWS
    public var cols=MINCOLS
    let field:[Int]
    let solution:[Int]
    let className:String
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    init(solution:[Int], puzzle:[Int])
    {
        className=String(self.dynamicType).componentsSeparatedByString(" ").last!
        assert(solution.count>=PlayField.MINTILES,"PlayField: Fel vid init: Antalet rutor får inte vara mindre än \(PlayField.MINTILES)! (var: \(solution.count))")
        assert(Double(solution.count) % sqrt(Double(solution.count)) == 0,"PlayField: Fel vid init: Antalet rutor måste bilda en kvadrat")
        self.field=puzzle
        self.solution=solution
        rows = Int(sqrt(Double(solution.count)))
        cols=rows
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    convenience init(solution:[Int])
    {
        var puzzle:[Int]=[]
        for _ in 0..<solution.count
        {
            puzzle.append(random()%5)
        }
        self.init(solution: solution, puzzle: puzzle)
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func completed() -> Bool
    {
        for i in 0..<field.count
        {
            if field[i] != solution[i]
            {
                return false
            }
        }
        return true
    }
}