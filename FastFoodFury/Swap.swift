//
//  Swap.swift
//  FastFoodFury
//
//  Created by Ryan Burke on 05/01/2015.
//  Copyright (c) 2015 Ryan Burke. All rights reserved.
//

import Foundation

struct Swap: Printable {
    
    let foodA: Food
    let foodB: Food
    
    init(foodA: Food, foodB: Food) {
        self.foodA = foodA
        self.foodB = foodB
    }
    
    var description: String {
        return "swap \(foodA) with \(foodB)"
    }
    
}