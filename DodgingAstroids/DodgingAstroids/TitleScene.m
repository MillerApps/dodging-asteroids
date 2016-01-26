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
@import GameKit;


@implementation TitleScene



- (void)setupScene {
    //add title label
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    titleLabel.text = @"Dodging Asteroids";
    titleLabel.position =  CGPointMake(self.frame.size.width / 2, self.frame.size.height - 60);
    
    
    
    //get highscore
    NSUserDefaults *highScore = [NSUserDefaults standardUserDefaults];
    NSInteger highScoreInt = [highScore integerForKey:@"highScore"];
    
    SKLabelNode *bestScore = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    if (![highScore integerForKey:@"highScore"]) {
        bestScore.text = @"Best: 0";
    } else {
        bestScore.text = [NSString stringWithFormat:@"Best: %ld", (long)highScoreInt];
    }
    
    bestScore.position =  CGPointMake(self.size.width / 2, CGRectGetMidY(self.frame) * 1.30);
    bestScore.fontSize = 22;
    bestScore.zPosition = 1;
    [self addChild:bestScore];
    
    
    
    //add spaceship to scene
    SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:@"ship"];
    //changes ship size for smaller screen sizes and exhaust postion
    if (IS_IPHONE_4_OR_LESS | IS_IPHONE_5) {
        ship.size = [Utils setNodeSize:ship.size];
        ship.position = CGPointMake(self.size.width/2, self.size.height/6);
        titleLabel.fontSize = 20;
        
    } else {
        ship.position = CGPointMake(self.size.width/2, self.size.height/4);
        titleLabel.fontSize = 25;
    }
    ship.zPosition = 1;
    titleLabel.zPosition = 1;
    
    [self addChild:ship];
    NSLog(@"texture name %@", ship.texture);
    [self addChild:titleLabel];
}

-(void)didMoveToView:(SKView *)view {
    
    SKSpriteNode *titleBg = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
    titleBg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    titleBg.size = self.size;
    titleBg.zPosition = -1;
    [self addChild:titleBg];
    
    
   
    [self setupScene];
    [self setupStartButton];
    [self setupLeaderBoardsButton];
    

    
    
}

- (void)setupStartButton {
    SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"start"];
    play.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 20);
    play.zPosition = 1;
    play.name = @"play";
    [self addChild:play];
}

- (void)setupLeaderBoardsButton {
    SKSpriteNode *leaderboards = [SKSpriteNode spriteNodeWithImageNamed:@"leaderboards"];
    leaderboards.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 70);
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
        [self.view presentScene:gamePlay transition:[SKTransition fadeWithDuration:1.0]];
        
        
    } else if ([node.name isEqualToString:@"boards"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showGameCenter" object:nil];
        
    }
    
    
    
}



@end
