//
//  ShipNode.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/7/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "ShipNode.h"
#import <AVFoundation/AVFoundation.h>
#import "Utils.h"

@interface ShipNode ()

@property (nonatomic) AVAudioPlayer *playExhaustSFX;

@end

@implementation ShipNode

+(instancetype)shipAtPostion:(CGPoint)position {
    ShipNode *ship = [self spriteNodeWithImageNamed:@"ship"];
    ship.position = position;
    ship.zPosition = 1;
    ship.name = @"ship";
    
    
    
    
    
    //add spaceship exhaust
    
    SKEmitterNode *exhaust = [SKEmitterNode nodeWithFileNamed:@"ExhaustParticle.sks"];
    exhaust.position = CGPointMake(0, -40);
    exhaust.zPosition = 1;
    [ship addChild:exhaust];
    
    [ship setUpPhysicsBody];
    
    

    
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

-(void)stopShipSFX {
    [_playExhaustSFX stop];
}



-(void)setUpPhysicsBody {
    
    //Create a mutable path in the shape of a triangle, using the sprite bounds as a guideline
    CGMutablePathRef physicsPath = CGPathCreateMutable();
    CGPathMoveToPoint(physicsPath, nil, -self.size.width/2, -self.size.height/2);
    CGPathAddLineToPoint(physicsPath, nil, self.size.width/2, -self.size.height/2);
    CGPathAddLineToPoint(physicsPath, nil, 0, self.size.height/2);
    CGPathAddLineToPoint(physicsPath, nil, -self.size.width/2, -self.size.height/2);
    
    self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:physicsPath];
    self.physicsBody.categoryBitMask = CollisionCatShip;
    self.physicsBody.collisionBitMask = CollisionCatEdge;
    self.physicsBody.contactTestBitMask = CollisionCatAstroid;
    self.physicsBody.allowsRotation = NO;
    
    
}

@end
