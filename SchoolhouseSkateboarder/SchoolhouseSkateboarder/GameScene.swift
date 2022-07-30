//
//  GameScene.swift
//  SchoolhouseSkateboarder
//
//  Created by Арсентий Халимовский on 28.07.2022.
//

import SpriteKit
import GameplayKit


// This structure contains different physical categories and we can set
// which is will be contact or collide with each other

struct PhysicsCategory {
    
    static let skater: UInt32 = 0x1 << 0
    static let brick: UInt32 = 0x1 << 1
    static let gem: UInt32 = 0x1 << 2
    
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Enum for position of sections in Y axis
    // Sections on the ground is low and section in the upper platform is high
    enum BrickLevel: CGFloat {
        case low = 0.0
        case high = 100.0
    }
    
    // array for all sections of sidewalk
    var bricks = [SKSpriteNode]()
    
    // size of the sections
    var brickSize = CGSize.zero
    
    // Current level defines position on axis Y for new sections
    var brickLevel = BrickLevel.low
    
    // Settings for the bricks speed on our scene
    // This value can be increased in game
    var scrollSpeed: CGFloat = 5.0
    
    let startingScrollSpeed: CGFloat = 5.0
    
    // Constant for gravitation
    let gravitySpeed: CGFloat = 1.5
    
    // Time of last call of update method
    var lastUpdateTime: TimeInterval?
    
    let skater = Skater(imageNamed: "skater")
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -6.0)
        physicsWorld.contactDelegate = self
        
        anchorPoint = CGPoint.zero
        
        let background = SKSpriteNode(imageNamed: "background")
        let xMid = frame.midX
        let yMid = frame.midY
        background.position = CGPoint(x: xMid, y: yMid)
        addChild(background)
        
        // Creation of skater and adding her to the scene
        skater.setupPhysicsBody()
        
        addChild(skater)
        
        // Adding click recognizer to find out when user clicks screen of the phone
        let tapMethod = #selector(GameScene.handleTap(tapGesture:))
        let tapGesture = UITapGestureRecognizer(target: self, action: tapMethod)
        view.addGestureRecognizer(tapGesture)
        
        startGame()
        
    
    }
    
    
    func resetSkater() {
        // Defining start position for skater, zPosition and minimumY
        let skaterX = frame.midX / 2.0
        let skaterY = skater.frame.height / 2.0 + 64.0
        skater.position = CGPoint(x: skaterX, y: skaterY)
        skater.zPosition = 10
        skater.minimumY = skaterY
        
        skater.zRotation = 0.0
        skater.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        skater.physicsBody?.angularVelocity = 0.0
    }
    
    func startGame() {
        
        // Return to the start condition when you run a new game
        resetSkater()
        
        scrollSpeed = startingScrollSpeed
        brickLevel = .low
        lastUpdateTime = nil
        
        for brick in bricks {
            brick.removeFromParent()
        }
        
        bricks.removeAll(keepingCapacity: true)
    }
    
    func gameOver() {
        startGame()
    }
    
    func spawnBrick (atPosition position: CGPoint) -> SKSpriteNode {
        
        // Creating sprite of the break section of our sidewalk and adding him to the scene
        let brick = SKSpriteNode(imageNamed: "sidewalk")
        brick.position = position
        brick.zPosition = 8
        addChild(brick)
        
        // Updating property of brickSize with real value of section size
        brickSize = brick.size
        
        // Adding new section to the array of bricks
        bricks.append(brick)
        
        // Setting of physical body of the section
        let center = brick.centerRect.origin
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size, center: center)
        brick.physicsBody?.affectedByGravity = false
        
        brick.physicsBody?.categoryBitMask = PhysicsCategory.brick
        brick.physicsBody?.collisionBitMask = 0
        
        // Return of new section for calling code
        return brick
    }
    
    func updateBricks(withScrollAmount currentScrollAmount: CGFloat) {
        
        // Monitoring for biggest value of X axis for all current sections
        var farthestRightBrickX: CGFloat = 0.0
        
        for brick in bricks {
            
            let newX = brick.position.x - currentScrollAmount
            
            // If section shifted to much to the left (out from screen), delete it
            if newX < -brickSize.width {
                brick.removeFromParent()
                
                if let brickIndex = bricks.firstIndex(of: brick) {
                    bricks.remove(at: brickIndex)
                }
                
            } else {
                
                // for section which is staying on the screen, update position
                brick.position = CGPoint(x: newX, y: brick.position.y)
                
                // Updating value for far right section
                if brick.position.x > farthestRightBrickX {
                    farthestRightBrickX = brick.position.x
                }
            }
        }
            
            // cycle While, providing non stop filing the display with sections
            while farthestRightBrickX < frame.width {
                
                var brickX = farthestRightBrickX + brickSize.width + 1.0
                let brickY = (brickSize.height / 2.0) + brickLevel.rawValue
                
                // Making some gaps in the sidewalk so our hero should jump over them
                let randomNumber = arc4random_uniform(99)
                
                if randomNumber < 5 {
                    
                    // 5 % chance to spawn gaps between the sections
                    let gap = 20.0 * scrollSpeed
                    brickX += gap
                }
                
                else if randomNumber < 10 {
                    // 5 % chance to change lower section to the upper section and vice versa
                    if brickLevel == .high {
                        brickLevel = .low
                    }
                    else if brickLevel == .low {
                        brickLevel = .high
                    }
                }
                
                // Adding new section and updating position of farthest right
                let newBrick = spawnBrick(atPosition: CGPoint(x: brickX, y: brickY))
                farthestRightBrickX = newBrick.position.x
            
        }
    }
    
    func updateSkater() {
        
        // Check is skater is on the ground or not
        if let velocityY = skater.physicsBody?.velocity.dy {
            
            if velocityY < -100.0 || velocityY > 100.0 {
                skater.isOnGround = false
            }
        }
        
        // Check should new game end or not
        let isOffScreen = skater.position.y < 0.0 || skater.position.x < 0.0
        
        let maxRotation = CGFloat(GLKMathDegreesToRadians(85.0))
        let isTippedOver = skater.zRotation > maxRotation || skater.zRotation < -maxRotation
        
        if isOffScreen || isTippedOver {
            gameOver()
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // calling after drowing each shot
        
        // Slowly increasing value of scrollSpeed during the game
        scrollSpeed += 0.01
        
        // Count the time that left from last moment of call update method
        var elapsedTime: TimeInterval = 0.0
        if let lastTimeStamp = lastUpdateTime {
            elapsedTime = currentTime - lastTimeStamp
        }
        
        lastUpdateTime = currentTime
        
        let expectedElapsedTime: TimeInterval = 1.0 / 60.0
        
        // Calculating how far objects should move with current update
        let scrollAdjustment = CGFloat(elapsedTime / expectedElapsedTime)
        let currentScrollAmount = scrollSpeed * scrollAdjustment
        
        updateBricks(withScrollAmount: currentScrollAmount)
        
        updateSkater()
    }
    
    @objc func handleTap(tapGesture: UITapGestureRecognizer) {
        
        // Skater jumps when user clicks on the screen when she is on the ground
        if skater.isOnGround {
            
            skater.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 260.0))
        }
    }
    
    // MARK: - SKPhysicsContactDelegate Methods
    func didBegin(_ contact: SKPhysicsContact) {
        // Check up for contact between skater and brick of sidewalk
        if contact.bodyA.categoryBitMask == PhysicsCategory.skater &&
            contact.bodyB.categoryBitMask == PhysicsCategory.brick {
            
            skater.isOnGround = true
        }
    }
}
