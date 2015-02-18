//
//  PauseStartNode.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/15/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "PauseButtonNode.h"
#import "Utils.h"

@implementation PauseButtonNode

+(instancetype)buttonAtPosition:(CGPoint)position {
    
    PauseButtonNode *pause = [self spriteNodeWithImageNamed:@"pause"];
    pause.position = position;
    pause.name = @"pauseButton";
    pause.alpha = 0.5;
    pause.zPosition = 3;
    
    //changes button size for smaller screen sizes and position
    if (IS_IPHONE_4_OR_LESS | IS_IPHONE_5) {
        pause.size = [Utils setNodeSize:pause.size];
        pause.position = CGPointMake(position.x +15, position.y);
    }
    
    return pause;
    
}

@end
