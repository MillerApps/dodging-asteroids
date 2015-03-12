//
//  SpaceManNode.m
//  DodgingAsteroids
//
//  Created by Tyler Miller on 3/11/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "SpaceManNode.h"
#import "Utils.h"

@implementation SpaceManNode

+(instancetype)spaceMan {
    
    SpaceManNode *spaceMan = [self spriteNodeWithImageNamed:@"spaceman01"];
    spaceMan.zPosition = 0;
    spaceMan.name = @"spaceMan";
    [spaceMan setScale:0.4];
    NSArray *animationTextures = @[[SKTexture textureWithImageNamed:@"spaceman01"],
                                   [SKTexture textureWithImageNamed:@"spaceman02"],
                                   [SKTexture textureWithImageNamed:@"spaceman03"],
                                   [SKTexture textureWithImageNamed:@"spaceman04"],
                                   [SKTexture textureWithImageNamed:@"spaceman05"],
                                   [SKTexture textureWithImageNamed:@"spaceman06"],
                                   [SKTexture textureWithImageNamed:@"spaceman07"],
                                   [SKTexture textureWithImageNamed:@"spaceman08"],
                                   [SKTexture textureWithImageNamed:@"spaceman09"],
                                   [SKTexture textureWithImageNamed:@"spaceman10"],
                                   [SKTexture textureWithImageNamed:@"spaceman11"]];
    
    SKAction *animate = [SKAction animateWithTextures:animationTextures timePerFrame:0.1];
    [spaceMan runAction:[SKAction repeatActionForever:animate]];
    
    //changes spaceman size for smaller screen sizes
    if ( IS_IPHONE_4_OR_LESS | IS_IPHONE_5) {
        spaceMan.size = [Utils setNodeSize:spaceMan.size];
        
    }

    
    [spaceMan setUpPhysicsBody];
    
    return spaceMan;
}

-(void)setUpPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.friction = 0;
    self.physicsBody.linearDamping = 0;
    self.physicsBody.categoryBitMask = CollisionCatSpaceMan;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionCatShip;
    
}

@end
