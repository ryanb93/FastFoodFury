//
//  Level.swift
//  FastFoodFury
//
//  Created by Ryan Burke on 05/01/2015.
//  Copyright (c) 2015 Ryan Burke. All rights reserved.
//

import Foundation

let NumColumns = 9
let NumRows = 9

class Level {
    
    private var foods = Array2D<Food>(columns: NumColumns, rows: NumRows)
    private var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    
    init(fileName: String) {
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(fileName) {
            if let tilesArray: AnyObject = dictionary["tiles"] {
                for(row, rowArray) in enumerate(tilesArray as [[Int]]) {
                    let tileRow = NumRows - row - 1
                    for(column, value) in enumerate(rowArray) {
                        println(value)
                        if value == 1 {
                            tiles[column, tileRow] = Tile()
                        }
                    }
                }
            }
        }
    }
    
    func foodAtColumn(column: Int, row: Int) -> Food? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return foods[column, row]
    }
    
    func tileAtColumn(column: Int, row: Int) -> Tile? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tiles[column, row]
    }
    
    func shuffle() -> Set<Food> {
        return createInitialFoods()
    }
    
    func performSwap(swap: Swap) {
        let columnA = swap.foodA.column
        let rowA = swap.foodA.row
        let columnB = swap.foodB.column
        let rowB = swap.foodB.row
        
        foods[columnA, rowA] = swap.foodB
        swap.foodB.column = columnA
        swap.foodB.row = rowA
        
        foods[columnB, rowB] = swap.foodA
        swap.foodA.column = columnB
        swap.foodA.row = rowB
    }
    
    private func createInitialFoods() -> Set<Food> {
        
        var set = Set<Food>()
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if tiles[column, row] != nil {
                    var foodType = FoodType.random()
                    let food = Food(column: column, row: row, foodType: foodType)
                    foods[column, row] = food
                    set.addElement(food)
                }
            }
        }
        return set
    }
    
}
