//
//  ShipNode.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/7/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "ShipNode.h"
#import <AVFoundation/AVFoundation.h>

@interface ShipNode ()

@property (nonatomic) AVAudioPlayer *playExhaustSFX;

@end

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



-(void)playShipSFXForever {
    
    //add ship exhaust sound
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"thrusters" withExtension:@"caf"];
    _playExhaustSFX = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    _playExhaustSFX.numberOfLoops = -1;
    
    [_playExhaustSFX setVolume:0.2];
    
    [_playExhaustSFX prepareToPlay];
    
    [_playExhaustSFX play];
    
    

}

@end
