//
//  Tiles.swift
//  Tangram2
//
//  Created by Iggy Drougge on 2016-04-08.
//  Copyright © 2016 Iggy Drougge. All rights reserved.
//

import Foundation
import UIKit
struct Tiles {
    let tileValues=["◻︎","◥","◢","◣","◤","█"]
    typealias TileValue = (String,String,CGPoint)
    var bitar:[TileValue]=[("hej","svej",CGPointZero),("blö","bla",CGPointZero)]
    enum Text:String {
        case _TOM="◻︎",_90DEG="◥",_180DEG="◢",_270DEG="◣",_360DEG="◤",_FULL="█"
    }
    enum Drawable:String {
        case _TOM="rutatom",_90DEG="ruta90grd"
        case _180DEG="ruta180grd",_270DEG="ruta270grd"
        case _360DEG="ruta360grd",_FULL="rutahel"
        
    }
    func filterTest()
    {
        let filtered=tileValues.filter{$0=="█"}         // Returnerar [5]
        let matches=filtered.count                      // Returnerar 1
        let filledIndex=tileValues.indexOf("█")         // Returnerar 5
        let nonEmptyIndex=tileValues.indexOf({$0 != "◻︎"})// Returnerar 1
        var mylist=[[1,"hej",14],[2,"svej",15]]
    }
    let text:Text
    let drawable:Drawable
    var toString:String
    {
        return "Ruta \(self.text) och bild \(self.drawable)"
    }
}
/*
package org.kristallpojken.tangram1;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.Log;

/**
* Spelet har sex rutor: Tom, ifylld och halvifylld roterad i 90-graderssteg
*/
public enum Tiles{
_EMPTY("︎◻︎",R.drawable.rutatom),_90DEG("◥",R.drawable.ruta90grd),
_180DEG("◢",R.drawable.ruta180grd),_270DEG("◣",R.drawable.ruta270grd),
_360DEG("◤",R.drawable.ruta360grd),_FULL("█",R.drawable.rutahel);
//private final String text;
//private final int drawable;
private String text;
private int drawable;
// Nedanstående statiska block är för att kunna hämta med withNr()
public static Tiles[] tiles = new Tiles[Tiles.values().length];
static{
int i=0;
for (Tiles tile: Tiles.values())
{
tiles[i++]=tile;
}
}
Tiles(String text, int drawable)
{
this.text=text;
this.drawable=drawable;
}
public int nr()
{
// Här borde kan kunna använda ordinal()
//return nr;
return ordinal();
}
public String text()
{
return text;
}
public static Tiles withNr(int nr)
{
if(nr<=Tiles.values().length)
return tiles[nr];
else
Log.e("Tiles","Ogiltigt tal vid hämtning av ruta!");
return null;
}
public Drawable getDrawable(Context context)
{
return context.getDrawable(drawable);
}
public Tiles next()
{
if(ordinal()<values().length-1)
return withNr(ordinal()+1);
else
return withNr(0);
}
public void cycle()
{
//nr++;
withNr(ordinal()+1);
Log.i("Tiles",toString());
}
@Override
public String toString()
{
return "Ruta med nr "+ordinal()+": "+text;
}
}
*/