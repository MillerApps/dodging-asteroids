//
//  TitleScene.m
//  DodgingAsteroids
//
//  Created by Tyler Miller on 2/26/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "TitleScene.h"
#import "GameScene.h"
#import "ShipNode.h"
#import "Utils.h"

@implementation TitleScene

-(void)didMoveToView:(SKView *)view {
    
    SKSpriteNode *titleBg = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
    titleBg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    titleBg.size = self.size;
    titleBg.zPosition = 0;
    [self addChild:titleBg];
    
    //add spaceship to scene
    SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:@"ship"];
    //changes ship size for smaller screen sizes and exhaust postion
    if (IS_IPHONE_4_OR_LESS | IS_IPHONE_5) {
        ship.size = [Utils setNodeSize:ship.size];
        ship.position = CGPointMake(self.size.width/2, self.size.height/5);
    } else {
        ship.position = CGPointMake(self.size.width/2, self.size.height/4);
    }
    
    [self addChild:ship];
    
    
    
    //add title label
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    titleLabel.text = @"Dodging Asteroids";
    titleLabel.position =  CGPointMake(self.size.width/2, self.size.height - 70);
    titleLabel.fontSize = 25;
    [self addChild:titleLabel];
    
    //get highscore
    NSUserDefaults *highScore = [NSUserDefaults standardUserDefaults];
    NSInteger highScoreInt = [highScore integerForKey:@"highScore"];
    
    SKLabelNode *bestScore = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    if (![highScore integerForKey:@"highScore"]) {
        bestScore.text = @"Best: 0";
    } else {
        bestScore.text = [NSString stringWithFormat:@"Best: %ld", (long)highScoreInt];
    }
    
    bestScore.position =  CGPointMake(self.size.width/2, titleLabel.position.y - 80);
    bestScore.fontSize = 20;
    [self addChild:bestScore];
    
    SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"start"];
    play.position = CGPointMake(CGRectGetMidX(self.frame) - 60, CGRectGetMidY(self.frame));
    play.zPosition = 1;
    play.name = @"play";
    [self addChild:play];
    
    SKSpriteNode *score = [SKSpriteNode spriteNodeWithImageNamed:@"scores"];
    score.position = CGPointMake(CGRectGetMidX(self.frame) + 60, CGRectGetMidY(self.frame));
    score.zPosition = 1;
    score.name = @"score";
    [self addChild:score];
    
    SKSpriteNode *leaderboards = [SKSpriteNode spriteNodeWithImageNamed:@"leaderboards"];
    leaderboards.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 60);
    leaderboards.zPosition = 1;
    leaderboards.name = @"boards";
    [self addChild:leaderboards];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //get a UITouch object
    UITouch *touch = [touches anyObject];
    //get touch loc
    CGPoint location = [touch locationInNode:self];
    //get selected node
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"play"]) {
        GameScene *gamePlay = [GameScene sceneWithSize:self.size];
        [self.view presentScene:gamePlay transition:[SKTransition fadeWithDuration:0.5]];
    } else if ([node.name isEqualToString:@"score"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showLeaderBoard" object:nil];
        
    } else if ([node.name isEqualToString:@"boards"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showGameCenter" object:nil];
    }
    
    
    
}

@end
