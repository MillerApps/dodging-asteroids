//
//  Utils.h
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/8/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(uint32_t, CollisionCat) {
    CollisionCatShip = 1 << 0,
    CollisionCatAstroid = 1 << 1,
    
};

@interface Utils : NSObject

+(NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max;

@end
