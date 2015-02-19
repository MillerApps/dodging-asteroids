//
//  HudNode.h
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/19/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HudNode : SKNode

@property (nonatomic) NSInteger score;


+(instancetype)hudAtPostion:(CGPoint)position;
-(void)awardScorePoint:(NSInteger)points;

@end
