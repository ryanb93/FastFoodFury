//
//  Food.swift
//  FastFoodFury
//
//  Created by Ryan Burke on 05/01/2015.
//  Copyright (c) 2015 Ryan Burke. All rights reserved.
//

import SpriteKit

enum FoodType: Int, Printable {
    
    case Unknown = 0, Burger, Fries, Hotdog, Pizza, Kebab, Chicken
    
    var spriteName: String {
        
        let spriteNames = [
            "Croissant",
            "Cupcake",
            "Danish",
            "Donut",
            "Macaroon",
            "SugarCookie"]
        
        return spriteNames[rawValue - 1]
    }
    
    var highlightedSpriteName: String {
        return spriteName + "-Highlighted"
    }
    
    static func random() -> FoodType {
        return FoodType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
    
    var description: String {
        return spriteName
    }
    
    
}

class Food: Printable, Hashable {
    
    var column: Int
    var row: Int
    
    let foodType: FoodType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, foodType: FoodType) {
        self.column = column
        self.row = row
        self.foodType = foodType
    }
    
    var description: String {
        return "type:\(foodType) square:(\(column), \(row))"
    }
    
    var hashValue: Int {
        return row*10 + column
    }
    
}

func == (lhs: Food, rhs: Food) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}
