//
//  PauseStartNode.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/15/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "PauseButtonNode.h"

@implementation PauseButtonNode

+(instancetype)buttonAtPosition:(CGPoint)position {
    
    PauseButtonNode *pause = [self spriteNodeWithImageNamed:@"pause"];
    pause.position = position;
    pause.name = @"pauseButton";
    pause.alpha = 0.5;
    pause.zPosition = 3;
    
    return pause;
    
}

@end
