//
//  AstroidNode.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/8/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "AsteroidNode.h"
#import "Utils.h"

@implementation AsteroidNode

+(instancetype)astroidOfType:(AstoridType)type {
    AsteroidNode *astroid;
    
    if (type == AstoridTypeA) {
        astroid = [self spriteNodeWithImageNamed:@"rock_a"];
    } else if (type == AstoridTypeB) {
        astroid = [self spriteNodeWithImageNamed:@"rock_b"];
    } else {
        astroid = [self spriteNodeWithImageNamed:@"rock_c"];
    }
    
    astroid.name = @"astroid";
    astroid.zPosition = 1;
    
    //changes asteroid size for smaller screen sizes
    if ( IS_IPHONE_4_OR_LESS | IS_IPHONE_5) {
        astroid.size = [Utils setNodeSize:astroid.size];
       
    }
    
    [astroid setUpPhysicsBody];
    
    
    return astroid;
}

-(void)setUpPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.height / 2];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.friction = 0;
    self.physicsBody.linearDamping = 0;
    
    
    self.physicsBody.categoryBitMask = CollisionCatAstroid;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionCatShip;
    
}

@end
