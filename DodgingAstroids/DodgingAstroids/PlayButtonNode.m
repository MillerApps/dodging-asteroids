//
//  PlayButton.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/15/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "PlayButtonNode.h"
#import "Utils.h"

@implementation PlayButtonNode

+(instancetype)buttonAtPosition:(CGPoint)position {
    
    PlayButtonNode *play = [self spriteNodeWithImageNamed:@"start"];
    play.position = position;
    play.name = @"playButton";
    play.alpha = 0.5;
    play.zPosition = 3;
    
    //changes button size for smaller screen sizes and postion
    if (IS_IPHONE_4_OR_LESS | IS_IPHONE_5) {
        play.size = CGSizeMake(play.size.width/1.5, play.size.height/1.5);
        
    }
    
    return play;
    
}

@end
