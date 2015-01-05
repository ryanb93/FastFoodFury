//
//  GameScene.swift
//  FastFoodFury
//
//  Created by Ryan Burke on 05/01/2015.
//  Copyright (c) 2015 Ryan Burke. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var level: Level!
    
    let TileWidth: CGFloat = 32.0
    let TileHeight: CGFloat = 36.0
    
    let gameLayer = SKNode()
    let foodLayer = SKNode()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    

    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "Background")
        addChild(background)
        
        addChild(gameLayer)
        
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(NumColumns) / 2,
            y: -TileHeight * CGFloat(NumRows) / 2)
        
        foodLayer.position = layerPosition
        gameLayer.addChild(foodLayer)
        
    }
    
    func addSpritesForFoods(foods: Set<Food>) {
        
        for food in foods {
            let sprite = SKSpriteNode(imageNamed: food.foodType.spriteName)
            sprite.position = pointForColumn(food.column, row: food.row)
            foodLayer.addChild(sprite)
            food.sprite = sprite
        }
    }
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column) * TileWidth + TileWidth/2,
            y: CGFloat(row) * TileHeight + TileHeight/2)
    }
    
}
