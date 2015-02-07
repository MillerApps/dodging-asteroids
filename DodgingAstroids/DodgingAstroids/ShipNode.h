//
//  ShipNode.h
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/7/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ShipNode : SKSpriteNode

+(instancetype)shipAtPostion:(CGPoint)position;
-(void)playShipSFXForever;

@end
