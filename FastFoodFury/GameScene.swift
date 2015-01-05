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
    
    var swipeFromColumn: Int?
    var swipeFromRow: Int?
    
    var swipeHandler: ((Swap) -> ())?
    
    let gameLayer = SKNode()
    let foodLayer = SKNode()
    let tilesLayer = SKNode()
    
    var selectionSprite = SKSpriteNode()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        swipeFromColumn = nil
        swipeFromRow = nil
        
    }
    
    override func didMoveToView(view: SKView) {
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        gameLayer.zPosition = Layer.Game
        addChild(gameLayer)
        
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(foodLayer)
        let (success, column, row) = convertPoint(location)
        if success {
            if let food = level.foodAtColumn(column, row: row) {
                swipeFromColumn = column
                swipeFromRow = row
                showSelectionIndicatorForFood(food)
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if swipeFromColumn == nil { return }
        
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(foodLayer)
        
        let (success, column, row) = convertPoint(location)
        if success {
            
            var horzDelta = 0, vertDelta = 0
            if column < swipeFromColumn! {          // swipe left
                horzDelta = -1
            } else if column > swipeFromColumn! {   // swipe right
                horzDelta = 1
            } else if row < swipeFromRow! {         // swipe down
                vertDelta = -1
            } else if row > swipeFromRow! {         // swipe up
                vertDelta = 1
            }
            
            if horzDelta != 0 || vertDelta != 0 {
                trySwapHorizontal(horzDelta, vertical: vertDelta)
                swipeFromColumn = nil
                hideSelectionIndicator()
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if selectionSprite.parent != nil && swipeFromColumn != nil {
            hideSelectionIndicator()
        }
        swipeFromColumn = nil
        swipeFromRow = nil
    }
    
    override func touchesCancelled(touches: NSSet, withEvent event: UIEvent) {
        touchesEnded(touches, withEvent: event)
    }
    
    func trySwapHorizontal(horzDelta: Int, vertical vertDelta: Int) {
        let toColumn = swipeFromColumn! + horzDelta
        let toRow = swipeFromRow! + vertDelta
        if toColumn < 0 || toColumn >= NumColumns { return }
        if toRow < 0 || toRow >= NumRows { return }
        if let toCookie = level.foodAtColumn(toColumn, row: toRow) {
            if let fromCookie = level.foodAtColumn(swipeFromColumn!, row: swipeFromRow!) {
                if let handler = swipeHandler {
                    let swap = Swap(foodA: fromCookie, foodB: toCookie)
                    handler(swap)
                }
            }
        }
    }
    
    func animateSwap(swap: Swap, completion: () -> ()) {
        let spriteA = swap.foodA.sprite!
        let spriteB = swap.foodB.sprite!
        
        spriteA.zPosition = 100
        spriteB.zPosition = 99
        
        let Duration: NSTimeInterval = 0.3
        
        let moveA = SKAction.moveTo(spriteB.position, duration: Duration)
        moveA.timingMode = .EaseOut
        spriteA.runAction(moveA, completion:completion)
        
        let moveB = SKAction.moveTo(spriteA.position, duration: Duration)
        moveB.timingMode = .EaseOut
        spriteB.runAction(moveB)
    }
    
    func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(NumColumns)*TileWidth &&
            point.y >= 0 && point.y < CGFloat(NumRows)*TileHeight {
                return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
        } else {
            return (false, 0, 0)  // invalid location
        }
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
    
    func showSelectionIndicatorForFood(food: Food) {
        
        if selectionSprite.parent != nil {
            selectionSprite.removeFromParent()
        }
        
        if let sprite = food.sprite {
            let texture = SKTexture(imageNamed: food.foodType.highlightedSpriteName)
            selectionSprite.size = sprite.size
            selectionSprite.runAction(SKAction.setTexture(texture))
            sprite.addChild(selectionSprite)
            selectionSprite.alpha = 1.0
        }
    }
    
    func hideSelectionIndicator() {
        selectionSprite.runAction(SKAction.sequence([
            SKAction.fadeOutWithDuration(0.3),
            SKAction.removeFromParent()]))
    }
    
}
