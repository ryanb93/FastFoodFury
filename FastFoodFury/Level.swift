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
    
    func foodAtColumn(column: Int, row: Int) -> Food? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return foods[column, row]
    }
    
    func shuffle() -> Set<Food> {
        return createInitialFoods()
    }
    
    private func createInitialFoods() -> Set<Food> {
        
        var set = Set<Food>()
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                var foodType = FoodType.random()
                let food = Food(column: column, row: row, foodType: foodType)
                foods[column, row] = food
                set.addElement(food)
            }
        }
        
        return set
        
    }
    
}
