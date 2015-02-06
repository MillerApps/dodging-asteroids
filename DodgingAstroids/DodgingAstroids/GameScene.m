//
//  GameScene.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/5/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

- (void)addPlayerShip {
    //add spaceship to scene
    SKSpriteNode *spaceShip = [SKSpriteNode spriteNodeWithImageNamed:@"playerShip"];
    spaceShip.position = CGPointMake(self.size.width/2, 100);
    
    [self addChild:spaceShip];
    
    //add spaceship exhaust
    
    SKEmitterNode *exhaust = [SKEmitterNode nodeWithFileNamed:@"ExhaustParticle.sks"];
    exhaust.position = CGPointMake(0, -35);
    [spaceShip addChild:exhaust];
    
    
    
}

-(void)addAstroids {
    // astroids Will be added to the scene at random positions in the fully functional Game
    //add astroids to scene
    SKSpriteNode *astroid = [SKSpriteNode spriteNodeWithImageNamed:@"meteorBrown_big1"];
    astroid.position = CGPointMake(50, self.size.height/2);
    [self addChild:astroid];
    
    SKSpriteNode *astroidTwo = [SKSpriteNode spriteNodeWithImageNamed:@"meteorBrown_big3"];
    astroidTwo.position = CGPointMake(320, self.size.height - 60);
    [self addChild:astroidTwo];
}

-(void)didMoveToView:(SKView *)view {
    //Set the background image
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"darkPurple"];
    background.position = CGPointMake(self.size.width/2, self.size.height/2);
    background.size = self.size;
    [self addChild:background];
    
    //set physicsbody for scene
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    [self addPlayerShip];
    [self addAstroids];
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
