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
#import "TitleScene.h"
#import "Utils.h"
#import "CreditsViewController.h"
@import AVFoundation;

@interface EndScene ()

@property (nonatomic) AVAudioPlayer *bgMusic;

@end

@implementation EndScene

- (void)setupScoreLabels:(SKLabelNode *)label {
    
    //get highscore
    NSUserDefaults *highScore = [NSUserDefaults standardUserDefaults];
    NSInteger highScoreInt = [highScore integerForKey:@"highScore"];
    
    //create current score label
    SKLabelNode *currentScore = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    currentScore.text = [NSString stringWithFormat:@"Score: %@", [self.userData valueForKey:@"currentScore"]];
    currentScore.fontSize = 30;
    currentScore.zPosition = 1;
    currentScore.position = CGPointMake(self.size.width/2, label.position.y - 40);
    
    [self addChild:currentScore];
    
    //create high score label
    SKLabelNode *highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    highScoreLabel.text = [NSString stringWithFormat:@"Best: %ld", (long)highScoreInt];
    highScoreLabel.fontSize = 30;
    highScoreLabel.position = CGPointMake(self.size.width/2, currentScore.position.y - 40);
    highScoreLabel.zPosition = 1;
    
    
    [self addChild:highScoreLabel];
    
    //only reports score if greater than perivous highscore
    if ((NSInteger)[self.userData valueForKey:@"currentScore"] > highScoreInt) {
        [self reportScoreToGameCenter:highScoreInt];
    }
    
    
}

-(void)didMoveToView:(SKView *)view {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setUpAds" object:nil];
    
    SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
    bg.position = CGPointMake(self.size.width/2, self.size.height/2);
    bg.size = self.size;
    bg.zPosition = -1;
    [self addChild:bg];
    
    //create sklabel
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    label.text = @"Game Over";
    label.position = CGPointMake(self.size.width/2, self.size.height - 70);
    
    if (IS_IPHONE_4_OR_LESS | IS_IPHONE_5) {
        label.fontSize = 40;
        
    } else {
        label.fontSize = 50;
    }
    
    [self addChild:label];
    
    [self setupButtons];
    
    
    [self setupScoreLabels:label];
    
    
    [self setUpBackgroundMusic];
    
    
}


- (void)setUpBackgroundMusic {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"gameover" withExtension:@"caf"];
    
    self.bgMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.bgMusic.numberOfLoops = -1;
    [self.bgMusic setVolume:0.2];
    [self.bgMusic prepareToPlay];
    [self.bgMusic play];
}

- (void)setupButtons {
    //create lable
    SKLabelNode *tryAgain = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    tryAgain.text = @"Try Again";
    tryAgain.fontSize = 30;
    tryAgain.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    tryAgain.zPosition = 1;
    tryAgain.name = @"try";
    [self addChild:tryAgain];
    
    SKLabelNode *home = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    home.text = @"Home";
    home.fontSize = 30;
    home.position = CGPointMake(tryAgain.position.x, tryAgain.position.y - 60);
    home.zPosition = 1;
    home.name = @"home";
    [self addChild:home];
    
    SKLabelNode *credits = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    credits.text = @"Credits";
    credits.fontSize = 30;
    credits.position = CGPointMake(home.position.x, home.position.y - 60);
    credits.zPosition = 1;
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
        GameScene *gameScene = [GameScene sceneWithSize:self.size];
        [self.view presentScene:gameScene transition:[SKTransition pushWithDirection:SKTransitionDirectionUp duration:2.0]];
        [self.bgMusic stop];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeAds" object:nil];
    } else if ([node.name isEqualToString:@"credits"]) {
        [self.view.window.rootViewController performSegueWithIdentifier:@"showCredits" sender:self];
        
    } else if ([node.name isEqualToString:@"home"]) {
        TitleScene *title = [TitleScene sceneWithSize:self.size];
        [self.view presentScene:title transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:2.0]];
        [self.bgMusic stop];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeAds" object:nil];
    }
    
    
    
    
}

- (void)reportScoreToGameCenter:(NSInteger) score {
    int64_t scoreToreport = score;
    [[GameKitHelper sharedGamekitHelper] reportScore:scoreToreport forLeaderboardID:@"com.miller.DodgingAsteroids.high_scores"];
}






@end
