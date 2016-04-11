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
    
    init(solution:[Int], puzzle:[Int])
    {
        assert(solution.count>PlayField.MINTILES,"PlayField: Fel vid init: Antalet rutor får inte vara mindre än \(PlayField.MINTILES)!")
        assert(Double(solution.count) % sqrt(Double(solution.count)) == 0,"PlayField: Fel vid init: Antalet rutor måste bilda en kvadrat")
        self.field=puzzle
        self.solution=solution
        rows = Int(sqrt(Double(solution.count)))
        cols=rows
        print("PlayField: Skapar spelfält med \(solution.count) rutor.")
        
    }
    
    func completed() -> Bool
    {
        for i in field
        {
            if field[i] != solution[i]
            {
                return false
            }
        }
        return true
    }
}