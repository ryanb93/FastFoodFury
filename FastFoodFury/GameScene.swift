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
    
    var TileWidth: CGFloat!
    var TileHeight: CGFloat!
    
    let gameLayer = SKNode()
    let foodLayer = SKNode()
    let tilesLayer = SKNode()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        gameLayer.zPosition = Layer.Game
        addChild(gameLayer)
        
    }
    
    override func didMoveToView(view: SKView) {
        
        let viewWidth = self.view!.bounds.size.width;
        let viewHeight = self.view!.bounds.size.height;
        
        TileWidth = CGFloat(viewWidth - 40) / CGFloat(NumColumns)
        TileHeight = TileWidth + 5
        
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(NumColumns) / 2,
            y: -TileHeight * CGFloat(NumRows) / 2)
        
        foodLayer.position = layerPosition
        foodLayer.zPosition = Layer.Food
        gameLayer.addChild(foodLayer)
        
        tilesLayer.position = layerPosition
        tilesLayer.zPosition = Layer.Tiles
        gameLayer.addChild(tilesLayer)

        
        let background = SKSpriteNode(imageNamed: "Background")
        background.zPosition = Layer.Background
        background.size = CGSize(width: viewWidth, height:viewHeight)
        addChild(background)
    }
    
    func addSpritesForFoods(foods: Set<Food>) {
        
        for food in foods {
            let sprite = SKSpriteNode(imageNamed: food.foodType.spriteName)
            sprite.position = pointForColumn(food.column, row: food.row)
            sprite.size = CGSize(width: TileWidth - 3, height: TileHeight - 3)
            foodLayer.addChild(sprite)
            food.sprite = sprite
        }
    }
    
    func addTiles() {
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let tile = level.tileAtColumn(column, row: row) {
                    let tileNode = SKSpriteNode(imageNamed: "Tile")
                    tileNode.position = pointForColumn(column, row: row)
                    tileNode.size = CGSize(width: TileWidth, height: TileHeight)
                    tilesLayer.addChild(tileNode)
                }
            }
        }
    }
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column) * TileWidth + TileWidth/2,
            y: CGFloat(row) * TileHeight + TileHeight/2)
    }
    
}
