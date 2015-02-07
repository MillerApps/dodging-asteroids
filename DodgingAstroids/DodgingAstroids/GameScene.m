//
//  GameScene.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/5/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "GameScene.h"
#import "ShipNode.h"

@implementation GameScene

- (void)addPlayerShip {
    //add spaceship to scene
    ShipNode *ship = [ShipNode shipAtPostion:CGPointMake(self.size.width/2, 100)];
    [self addChild:ship];
    [ship playShipSFXForever];
   
    
    
}

-(void)addAstroids {
    // astroids Will be added to the scene at random positions in the fully functional Game
    //add astroids to scene
    SKSpriteNode *astroid = [SKSpriteNode spriteNodeWithImageNamed:@"meteorBrown_big1"];
    astroid.position = CGPointMake(50, self.size.height/2);
    astroid.name = @"astroid";
    [self addChild:astroid];
    
    SKSpriteNode *astroidTwo = [SKSpriteNode spriteNodeWithImageNamed:@"meteorBrown_big3"];
    astroidTwo.position = CGPointMake(self.size.width - 60, self.size.height - 60);
    astroidTwo.name = @"astroid";
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //this code will be removed in the coming weeks
    for (UITouch *touch in touches) {
        NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
        for (SKNode *node in nodes) {
            if ([node.name isEqualToString:@"astroid"]) {
                
                [self runAction:[SKAction playSoundFileNamed:@"rock.caf" waitForCompletion:NO]];
            }
           
        }
    }
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
