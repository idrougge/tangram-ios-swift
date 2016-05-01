//
//  Tiles.swift
//  Tangram2
//
//  Created by Iggy Drougge on 2016-04-08.
//  Copyright © 2016 Iggy Drougge. All rights reserved.
//

import Foundation
import UIKit
enum TilesEnum:String {
    case _TOM="◻︎",_90DEG="◥",_180DEG="◢",_270DEG="◣",_360DEG="◤",_FULL="█"
    func next()
    {
        print("\(self.rawValue)")
    }
}

class Tiles {
    static let tilesAsText=["◻︎","◥","◢","◣","◤","█"]
    static let tileNames=["_TOM","_90DEG","_180DEG","_270DEG","_360DEG","_FULL"]
    typealias TileType=(String,String)
    static var allTiles:[TileType]{
        var list:[TileType]=[]
        for i in 0..<tilesAsText.count
        {
            list.append((tilesAsText[i],tileNames[i]))
        }
        return list
    }
    var nr:Int=0
    var text:String
    var name:String
    
    init(nr:Int)
    {
        assert(nr<Tiles.tilesAsText.count)
        self.nr=nr
        text=Tiles.tilesAsText[nr]
        name=Tiles.tilesAsText[nr]
    }
    
    func next() -> Tiles
    {
        nr+=1
        if nr==Tiles.allTiles.count
        {
            let newTile=Tiles(nr: 0)
            return newTile
        }
        let newTile=Tiles(nr: nr)
        return newTile
    }
}