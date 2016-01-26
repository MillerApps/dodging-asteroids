//
//  HudNode.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/19/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "HudNode.h"

@implementation HudNode

+(instancetype)hudAtPostion:(CGPoint)position {
    
    HudNode *hud = [self node];
    hud.position = position;
    hud.alpha = 0.5;
    hud.zPosition = 4;
    
    //Create SKLabel for score
    SKLabelNode *score = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    score.text = @"0";
    score.fontSize = 35;
    score.name = @"score";
    
    [hud addChild:score];
    
    return hud;
}

-(void)awardScorePoint:(NSInteger)points {
    self.score += points;
    NSLog(@"Points passed: %ld", (long)points);
    //get label
    SKLabelNode *scoreLabel = (SKLabelNode*) [self childNodeWithName:@"score"];
    scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.score];
}

@end
