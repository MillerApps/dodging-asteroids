//
//  SpaceManNode.m
//  DodgingAsteroids
//
//  Created by Tyler Miller on 3/11/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "SpaceManNode.h"

@implementation SpaceManNode

+(instancetype)spaceManAtPostion:(CGPoint)position {
    
    SpaceManNode *spaceMan = [self spriteNodeWithImageNamed:@"spaceman01"];
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
    
    return spaceMan;
}

@end
