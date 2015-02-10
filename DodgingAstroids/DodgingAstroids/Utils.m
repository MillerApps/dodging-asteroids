//
//  Utils.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/8/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max {
    
    return arc4random()%(max - min) + min;
    
}

@end
