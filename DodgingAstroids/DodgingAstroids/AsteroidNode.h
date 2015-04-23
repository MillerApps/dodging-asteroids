//
//  AstroidNode.h
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/8/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, AstoridType) {
    AstoridTypeA = 0,
    AstoridTypeB = 1,
    AstoridTypeC = 2
    
};

@interface AsteroidNode : SKSpriteNode

@property (nonatomic) AstoridType type;


+(instancetype)astroidOfType:(AstoridType)type;

@end
