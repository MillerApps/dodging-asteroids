//
//  EndScene.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/15/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "EndScene.h"
#import "GameScene.h"
#import "GameKitHelper.h"

@implementation EndScene

- (void)setupScoreLabels:(SKLabelNode *)label {
    
    //get highscore
    NSUserDefaults *highScore = [NSUserDefaults standardUserDefaults];
    NSInteger highScoreInt = [highScore integerForKey:@"highScore"];
    
    [self reportScoreToGameCenter:highScoreInt];
    
    //create current score label
    SKLabelNode *currentScore = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    currentScore.text = [NSString stringWithFormat:@"Score: %@", [self.userData valueForKey:@"currentScore"]];
    currentScore.fontSize = 30;
    currentScore.position = CGPointMake(self.size.width/2, label.position.y - 40);
    
    [self addChild:currentScore];
    
    //create high score label
    SKLabelNode *highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    highScoreLabel.text = [NSString stringWithFormat:@"Best: %ld", highScoreInt];
    highScoreLabel.fontSize = 30;
    highScoreLabel.position = CGPointMake(self.size.width/2, currentScore.position.y - 40);
    
    [self addChild:highScoreLabel];
}

-(void)didMoveToView:(SKView *)view {
    
    SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
    bg.position = CGPointMake(self.size.width/2, self.size.height/2);
    bg.size = self.size;
    [self addChild:bg];
    
    //create sklabel
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    label.text = @"You Lost!";
    
    label.fontSize = 50;
    label.position = CGPointMake(self.size.width/2, self.size.height - 70);
    [self addChild:label];
    
    [self setupButtons];
    
    
    [self setupScoreLabels:label];
    
    NSUserDefaults *playerName = [NSUserDefaults standardUserDefaults];
    
    
    if (![playerName valueForKey:@"playerName"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showPopUp" object:nil];
    }
    
    

    
    

    
}

- (void)setupButtons {
    //create lable
    SKLabelNode *tryAgain = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    tryAgain.text = @"Try Again!";
    tryAgain.fontSize = 30;
    tryAgain.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    tryAgain.name = @"try";
    [self addChild:tryAgain];
    
    SKLabelNode *credits = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    credits.text = @"Credits";
    credits.fontSize = 30;
    credits.position = CGPointMake(tryAgain.position.x, tryAgain.position.y - 60);
    credits.name = @"credits";
    [self addChild:credits];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
        //get a UITouch object
        UITouch *touch = [touches anyObject];
        //get touch loc
        CGPoint location = [touch locationInNode:self];
        //get selected node
        SKNode *node = [self nodeAtPoint:location];
        
        if ([node.name isEqualToString:@"try"]) {
            GameScene *firstScene = [GameScene sceneWithSize:self.size];
            [self.view presentScene:firstScene];
        } else if ([node.name isEqualToString:@"credits"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showCreditsView" object:nil];
        }
    
   
    

}

- (void)reportScoreToGameCenter:(NSInteger) score {
    int64_t scoreToreport = score;
    [[GameKitHelper sharedGamekitHelper] reportScore:scoreToreport forLeaderboardID:@"com.miller.DodgingAsteroids.high_scores"];
}






@end
