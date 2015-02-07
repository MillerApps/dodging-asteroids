//
//  ShipNode.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/7/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "ShipNode.h"

@implementation ShipNode

+(instancetype)shipAtPostion:(CGPoint)position {
    ShipNode *ship = [self spriteNodeWithImageNamed:@"playerShip"];
    ship.position = position;
    ship.name = @"ship";
    
    
    
    //add spaceship exhaust
    
    SKEmitterNode *exhaust = [SKEmitterNode nodeWithFileNamed:@"ExhaustParticle.sks"];
    exhaust.position = CGPointMake(0, -40);
    [ship addChild:exhaust];
    
    return ship;

}

@end
