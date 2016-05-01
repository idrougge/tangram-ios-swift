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
    var score=0
    var puzzleNr=0
    init()
    {
        let puzzle=[4,5,3,
                    5,5,5,
                    1,5,4]
        let solution=[2,5,3,
                      5,5,5,
                      1,5,4]
        playfield=PlayField(solution: solution, puzzle: puzzle)
        next()
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func next() -> Bool
    {
        guard let nextPuzzle:[Int]=readPuzzleFromFile(puzzleNr++)
            else {return false}
        playfield=PlayField(solution: nextPuzzle)
        return true
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func readPuzzleFromFile(nrToLoad:Int) -> [Int]?
    {
        guard let fh=NSBundle.mainBundle().pathForResource("puzzles", ofType: "txt")
            else{print("Kunde inte öppna pusselfilen!");return nil}
        print("readPuzzle: bundle=\(fh)")
        var nextPuzzle:[Int]=[]
        var allPuzzles:String=""
        do{
            try allPuzzles=String(contentsOfFile: fh)
            print("Pusselfilens innehåll:\n\(allPuzzles)")
        }
        catch{
            print("Kunde inte läsa pusselfilen!")
        }
        var puzmap=allPuzzles.characters.filter({Int(String($0)) != nil}).map({Int(String($0))!})
        print("puzmap=\(puzmap)")
        //let nrToLoad=2
        var nr=0
        while nr<nrToLoad
        {
            if puzmap.isEmpty {print("Listan är tom!");return nil}
            let size=puzmap.removeFirst()
            print("size=\(size)")
            if puzmap.count<size*size
            {
                print("Bara \(puzmap.count) siffror kvar!")
                return nil
            }
            puzmap.removeFirst(size*size)
            nr++
        }
        if puzmap.isEmpty {print("Listan är tom!");return nil}
        let size=puzmap.removeFirst()
        print("size=\(size)")
        if puzmap.count<size*size
        {
            print("Bara \(puzmap.count) siffror kvar!")
            return nil
        }
        for i in 0..<size*size
        {
            nextPuzzle.append(puzmap[i])
        }
        print("nextPuzzle: \(nextPuzzle)")
        return nextPuzzle
    }

}