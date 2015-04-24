//
//  Utils.h
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/8/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

static const int objectSpeed = -135;
static const int pointsAwradared = 1;
static const int bounsPoints = 5;
static const int bounsLife = 1;


typedef NS_OPTIONS(uint32_t, CollisionCat) {
    CollisionCatShip = 1 << 0,
    CollisionCatAstroid = 1 << 1,
    CollisionCatEdge = 1 << 2,
    CollisionCatBottomEdge = 1 << 3,
    CollisionCatSpaceMan = 1 << 4
    
};

@interface Utils : NSObject



+(NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max;
+(CGSize)setNodeSize:(CGSize)size;

@end
