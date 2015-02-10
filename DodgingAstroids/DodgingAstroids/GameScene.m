//
//  GameScene.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/5/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "GameScene.h"
#import "ShipNode.h"
#import "Utils.h"
#import "AstroidNode.h"

@interface GameScene ()

//allows to control astroid spawn rate
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceAdded;
@property (nonatomic) ShipNode *ship;
@property (nonatomic) BOOL canMove;

@end

@implementation GameScene

- (void)addPlayerShip {
    //add spaceship to scene
    self.ship = [ShipNode shipAtPostion:CGPointMake(self.size.width/2, 100)];
    [self addChild:self.ship];
    [self.ship playShipSFXForever];
    
    
    
}

-(void)addAstroids {
    // astroids Will be added to the scene at random positions in the fully functional Game
    //add astroids to scene
    NSUInteger randomAstroid = [Utils randomWithMin:0 max:3];
    
    AstroidNode *astroid = [AstroidNode astroidOfType:randomAstroid];
    //set restarist for where astroids spawn
    float y = self.frame.size.height;
    float x = [Utils randomWithMin:astroid.size.width / 2 max:self.frame.size.width - astroid.size.width /2];
    
    //set postion
    astroid.position = CGPointMake(x, y);
    [self addChild:astroid];
    
}

-(void)didMoveToView:(SKView *)view {
    //Set the background image
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
    background.position = CGPointMake(self.size.width/2, self.size.height/2);
    background.size = self.size;
    [self addChild:background];
    
    //set physicsbody for scene
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    //physics world gravity
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    //contact deleagte
    self.physicsWorld.contactDelegate = self;
    
    
    [self addPlayerShip];
    //called once to have astroid spawn immediately
    [self addAstroids];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //COde for moving ship
    
    //get a UITouch object
    UITouch *touch = [touches anyObject];
    //get touch loc
    CGPoint location = [touch locationInNode:self];
    
    float moveBy = 20.0;
    
    
    
    //detect if the left portion of the scene is touched
    if (location.x < self.size.width / 2 && _canMove) {
        //move ship to the left
        
        
        [self.ship runAction:[SKAction moveByX:-moveBy y:0.0 duration:0.0]];
        
    }
    
    //detec if the right portion of the scene is touched
    if (location.x > self.size.width / 2 && _canMove) {
        //move ship to the right
        
        [self.ship runAction:[SKAction moveByX:moveBy y:0.0 duration:0.0]];
        
    }
    
    
}




-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    
    //check ships position to kepp it on screen
    if (self.ship.position.x < self.ship.size.width / 2) {
        
        
        self.ship.position = CGPointMake(self.ship.size.width / 2, 100);
        _canMove = NO;
        
    } else {
        _canMove = YES;
    }
    
    if (self.ship.position.x > self.size.width - (self.ship.size.width / 2)) {
        
        self.ship.position = CGPointMake(self.size.width - (self.ship.size.width / 2), 100);
        _canMove = NO;
    } else {
        _canMove = YES;
    }
    
    
    
    //called for astroid spawning
    if (self.lastUpdateTimeInterval) {
        self.timeSinceAdded += currentTime - self.lastUpdateTimeInterval;
    }
    
    if (self.timeSinceAdded > 2.25) {
        [self addAstroids];
        self.timeSinceAdded = 0;
    }
    
    self.lastUpdateTimeInterval = currentTime;
    
    
}

@end
