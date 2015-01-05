//
//  GameViewController.swift
//  FastFoodFury
//
//  Created by Ryan Burke on 05/01/2015.
//  Copyright (c) 2015 Ryan Burke. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var scene: GameScene!
    var level: Level!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure the view
        let skView = view as SKView
        skView.multipleTouchEnabled = false;
        
        //Create and configure the scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        //Create the level
        level = Level(fileName: "Level_1")
        scene.level = level
        
        //Show the scene.
        skView.presentScene(scene)

        scene.addTiles()
        
        //Begin the game
        beginGame()

    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func beginGame() {
        shuffle()
    }
    
    func shuffle() {
        let newFoods = level.shuffle()
        scene.addSpritesForFoods(newFoods)
    }
}
