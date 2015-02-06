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
}

-(void)didMoveToView:(SKView *)view {
    //Set the background image
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"darkPurple"];
    background.position = CGPointMake(self.size.width/2, self.size.height/2);
    background.size = self.size;
    [self addChild:background];
    
    [self addPlayerShip];
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
