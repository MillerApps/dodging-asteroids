//
//  PlayButton.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/15/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "PlayButtonNode.h"

@implementation PlayButtonNode

+(instancetype)buttonAtPosition:(CGPoint)position {
    
    PlayButtonNode *play = [self spriteNodeWithImageNamed:@"start"];
    play.position = position;
    play.name = @"playButton";
    play.alpha = 0.5;
    play.zPosition = 3;
    
    return play;
    
}

@end
