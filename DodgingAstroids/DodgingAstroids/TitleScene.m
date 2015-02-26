//
//  TitleScene.m
//  DodgingAsteroids
//
//  Created by Tyler Miller on 2/26/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "TitleScene.h"
#import "GameScene.h"

@implementation TitleScene

-(void)didMoveToView:(SKView *)view {
    
    SKSpriteNode *titleBg = [SKSpriteNode spriteNodeWithImageNamed:@"titleScreen"];
    titleBg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    titleBg.size = self.size;
    titleBg.zPosition = 0;
    [self addChild:titleBg];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GameScene *gamePlay = [GameScene sceneWithSize:self.size];
    [self.view presentScene:gamePlay transition:[SKTransition fadeWithDuration:0.5]];
}

@end
