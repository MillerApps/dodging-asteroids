//
//  EndScene.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/15/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "EndScene.h"
#import "GameScene.h"

@implementation EndScene

-(void)didMoveToView:(SKView *)view {
    
    SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
    bg.position = CGPointMake(self.size.width/2, self.size.height/2);
    bg.size = self.size;
    [self addChild:bg];
    
    //create sklabel
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    label.text = @"You Lost!";
    
    label.fontSize = 50;
    label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:label];
    

    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GameScene *firstScene = [GameScene sceneWithSize:self.size];
    [self.view presentScene:firstScene];

}

@end
