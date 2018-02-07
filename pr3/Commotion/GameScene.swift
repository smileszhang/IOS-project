//
//  GameScene.swift
//  Commotion
//
//  Created by Eric Larson on 9/6/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

class GameScene: SKScene {

    
    // MARK: Raw Motion Functions
    let motion = CMMotionManager()
    func startMotionUpdates(){
        // some internal inconsistency here: we need to ask the device manager for device
        
        if self.motion.isDeviceMotionAvailable{
            self.motion.deviceMotionUpdateInterval = 0.1
            self.motion.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: self.handleMotion )
        }
    }
    
    func handleMotion(_ motionData:CMDeviceMotion?, error:Error?){
        if let gravity = motionData?.gravity {
            self.physicsWorld.gravity = CGVector(dx: CGFloat(0*gravity.x), dy: CGFloat(9.8*gravity.y))
        }
    }
    
    // MARK: View Hierarchy Functions
    override func didMove(to view: SKView) {
       
        backgroundColor = SKColor.darkText
        
        // start motion for gravity
        self.startMotionUpdates()
        
        // make sides to the screen
        self.addSidesAndTop()
        
        //self.addStaticBlockAtPoint(CGPoint(x: size.width*0.1,y:size.height*0.25))
        //self.addStaticBlockAtPoint(CGPoint(x:size.width*0.9,y:size.height*0.25))
        // add stepping block
        /*
        for i in stride(from: 1,to: 10,by: 1){
              self.addBlockAtPoint(CGPoint(x: size.width * random(min: CGFloat(0.1), max: CGFloat(0.9)), y: size.height * 0.15 * CGFloat(i)))
        }
    */
        self.addBlockAtPoint(CGPoint(x: size.width * 0.5, y: size.height * 0.35))
        
        self.addSprite()
    }
    
    // MARK: Create Sprites Functions
    func addSprite(){
        let spriteA = SKSpriteNode(imageNamed: "sprite") // this is literally a sprite bottle... 😎
        
        spriteA.size = CGSize(width:size.width*0.1,height:size.height * 0.06)
        
        spriteA.position = CGPoint(x: size.width * random(min: CGFloat(0.1), max: CGFloat(0.9)), y: size.height * 0.75)
        
        
        spriteA.physicsBody = SKPhysicsBody(rectangleOf:spriteA.size)
        spriteA.physicsBody?.restitution=1.2
        //spriteA.physicsBody?.restitution = random(min: CGFloat(1.0), max: CGFloat(1.5))
        spriteA.physicsBody?.isDynamic = true
        
        self.addChild(spriteA)
    }
    
    let block = SKSpriteNode()

    
    func addBlockAtPoint(_ point:CGPoint){
       
        
        block.color = UIColor.brown
        let currency = CGFloat(UserDefaults.standard.float(forKey: "todayTotalStep"))/1000
        if currency >= size.width{
            block.size = CGSize(width:size.width*0.35,height:size.height * 0.05)
        }
        else{
            block.size = CGSize(width:size.width*0.05*currency,height:size.height * 0.05)
        }
        
        
        block.position = point
        block.physicsBody = SKPhysicsBody(rectangleOf:block.size)
        block.physicsBody?.restitution = 1;
      
        block.physicsBody?.affectedByGravity=false
        block.physicsBody?.isDynamic = false
       // block.physicsBody?.pinned = true
        block.physicsBody?.allowsRotation = false



        self.addChild(block)
  
    

    }
    
    func addStaticBlockAtPoint(_ point:CGPoint){
        let 🔲 = SKSpriteNode()
        
        🔲.color = UIColor.brown
        🔲.size = CGSize(width:size.width*0.1,height:size.height * 0.05)
        🔲.position = point
        
        🔲.physicsBody = SKPhysicsBody(rectangleOf:🔲.size)
        🔲.physicsBody?.isDynamic = true
        🔲.physicsBody?.pinned = true
        🔲.physicsBody?.allowsRotation = false
        

        
        self.addChild(🔲)
        
    }
    
    func addSidesAndTop(){
        let left = SKSpriteNode()
        let right = SKSpriteNode()
        let top = SKSpriteNode()
        
        left.size = CGSize(width:size.width*0.1,height:size.height)
        left.position = CGPoint(x:0, y:size.height*0.5)
        
        right.size = CGSize(width:size.width*0.1,height:size.height)
        right.position = CGPoint(x:size.width, y:size.height*0.5)
        
       top.size = CGSize(width:size.width,height:size.height*0.1)
        top.position = CGPoint(x:size.width*0.5, y:size.height)
        
        for obj in [left,right,top]{
            obj.color = UIColor.brown
            obj.physicsBody = SKPhysicsBody(rectangleOf:obj.size)
            obj.physicsBody?.restitution = 1
            obj.physicsBody?.isDynamic = true
            obj.physicsBody?.pinned = true
            obj.physicsBody?.allowsRotation = false
            self.addChild(obj)
        }
    }
    
    // MARK: UI Delegate Functions
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        self.addSprite()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touchLocation = CGPoint()
        for touch in touches{
            touchLocation = touch.location(in: self)
        
            block.position.x=touchLocation.x
            block.position.y=size.height*0.35
 
        }
 
        
    }
 
    // MARK: Utility Functions (thanks ray wenderlich!)
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}
