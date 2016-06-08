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
    
    return arc4random_uniform((uint32_t)max -  (uint32_t)min) + (uint32_t)min;
    
}

+(CGSize)setNodeSize:(CGSize)size {
    
    return CGSizeMake(size.width/1.2, size.height/1.2);
}



@end
