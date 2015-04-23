//
//  GameScene.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/5/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "GameScene.h"
#import "ShipNode.h"
#import "Utils.h"
#import "AsteroidNode.h"
#import "EndScene.h"
#import "PauseButtonNode.h"
#import "PlayButtonNode.h"
#import "HudNode.h"
#import "SpaceManNode.h"
#import "AchievementHelper.h"
#import "GameKitHelper.h"



@interface GameScene ()

//allows to control astroid spawn rate
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceAsteroidAdded;
@property (nonatomic) NSTimeInterval timeSinceSpaceManAdded;
@property (nonatomic) NSTimeInterval totalGameTime;
@property (nonatomic) NSInteger objectSpeed;
@property (nonatomic) float asteroidRespwanRate;
@property (nonatomic) float spaceManSpawnRate;
@property (nonatomic) float asteroidX;
@property (nonatomic) NSInteger numberOfLives;
@property (nonatomic) NSInteger numberOfHits;
@property (nonatomic) ShipNode *ship;
@property (nonatomic) PauseButtonNode *pauseBtn;
@property (nonatomic) PlayButtonNode *playBtn;
@property (nonatomic) HudNode *hud;
@property (nonatomic) SKLabelNode *healthCount;
@property (nonatomic) BOOL isPaused;
@property (nonatomic) BOOL isPausedByResign;
@property (nonatomic) BOOL isShip;
@property (nonatomic) BOOL isAsteroidTypeC;
@property (nonatomic) BOOL isGameOver;
@property (nonatomic) BOOL hasGamePlayStarted;
@property (nonatomic) BOOL wasPausedByTut;
@property (nonatomic) SKAction *playExpolsionSFX;
@property (nonatomic) SKAction *playShipMovementSFX;
@property (nonatomic) SKAction *powerupSFX;
@property (nonatomic) SKAction *powerdownSFX;

@end

@implementation GameScene



#pragma mark - Add Nodes

-(void)didMoveToView:(SKView *)view {
    
    [self registerAppTransitionObservers];
    
    self.lastUpdateTimeInterval = 0;
    self.timeSinceAsteroidAdded = 0;
    self.timeSinceSpaceManAdded = 0;
    self.totalGameTime = 0;
    self.objectSpeed = objectSpeed;
    self.asteroidRespwanRate = 1.90;
    self.numberOfLives = 0;
    
    
    
    _isPaused = NO;
    _isShip = YES;
    _isGameOver = NO;
    _hasGamePlayStarted = NO;
    _wasPausedByTut = NO;
    //Set the background image
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.size = self.size;
    background.zPosition = 0;
    [self addChild:background];
    
    SKSpriteNode *getReady = [SKSpriteNode spriteNodeWithImageNamed:@"getready"];
    getReady.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 80);
    getReady.zPosition = 1;
    getReady.yScale = getReady.xScale = .7;
    getReady.name = @"getReady";
    [self addChild:getReady];
    
    [self addPauseButton];
    [self addHud];
    [self addBottomEdge];
    [self setUpHealthCouner];
    [self addPlayerShip];
    
    [self preLoadSFX];
    
    
    
    //set physicsbody for scene
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = CollisionCatEdge;
    //physics world gravity
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    //contact deleagte
    self.physicsWorld.contactDelegate = self;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil];
    
    
    
    
}

- (void)addPlayerShip {
    //add spaceship to scene
    self.ship = [ShipNode shipAtPostion:CGPointMake(self.size.width/2, 150)];
    [self addChild:self.ship];
    [self.ship playShipSFXForever];
    
    
}

-(void)addAstroids {
    // astroids Will be added to the scene at random positions in the fully functional Game
    //add astroids to scene
    NSUInteger randomAstroid = [Utils randomWithMin:0 max:3];
    
    AsteroidNode *astroid = [AsteroidNode astroidOfType:randomAstroid];
    //set restarist for where astroids spawn
    float y = self.frame.size.height;
    float x = [Utils randomWithMin:astroid.size.width / 2 max:self.frame.size.width - astroid.size.width /2];
    
    //set postion
    astroid.position = CGPointMake(x, y);
    
    //set velocity of asteroids: large asterod is faster
    NSInteger velcoity = self.objectSpeed;
    if (astroid.type == AstoridTypeC) {
        _isAsteroidTypeC = YES;
        velcoity += 5;
        astroid.physicsBody.velocity = CGVectorMake(0, velcoity);
        //NSLog(@"Velocioty c: %ld", velcoity);
        
    } else {
        _isAsteroidTypeC = NO;
        astroid.physicsBody.velocity = CGVectorMake(0, velcoity);
        //NSLog(@"Velocioty: %ld", velcoity);
        
    }
    
    self.asteroidX = astroid.position.x;
    
    
    
    [self addChild:astroid];
    
    
}

-(void)addSpaceMan {
    //add spaceman at random postions on the screen
    SpaceManNode *spaceMan = [SpaceManNode spaceMan];
    float y = self.frame.size.height;
    float x = [Utils randomWithMin:spaceMan.size.width /2 max:self.frame.size.width - spaceMan.size.width / 2];
    
    //set spaceman position
    spaceMan.position = CGPointMake(x, y);
    //set velcoity
    spaceMan.physicsBody.velocity = CGVectorMake(0, self.objectSpeed);
    
    
    
    [self addChild:spaceMan];
    
    //shows a brief tut only on the fisrt instance of a spaceman
    NSUserDefaults *spaceTutShown = [NSUserDefaults standardUserDefaults];
    
    if (![spaceTutShown boolForKey:@"tutHasShown"]) {
        SKSpriteNode *tut = [SKSpriteNode spriteNodeWithImageNamed:@"spacetut"];
        tut.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        tut.zPosition = 9;
        tut.name = @"spaceTut";
        [self addChild:tut];
        
        [spaceTutShown setBool:YES forKey:@"tutHasShown"];
        [self pauseGamePlay];
    }
    
    
    
}

- (void)addPauseButton {
    //add [ause button
    _pauseBtn = [PauseButtonNode buttonAtPosition:CGPointMake(self.size.width - 40, self.size.height - 30)];
    
    [self addChild:_pauseBtn];
}

-(void)addHud {
    _hud = [HudNode hudAtPostion:CGPointMake(self.size.width / 2, self.size.height - 40)];
    
    [self addChild:_hud];
}

-(void)addBottomEdge {
    SKNode *bottomEdge = [SKNode node];
    bottomEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 1) toPoint:CGPointMake(self.size.width, 1)];
    bottomEdge.physicsBody.categoryBitMask = CollisionCatBottomEdge;
    [self addChild:bottomEdge];
}

- (void)preLoadSFX {
    //preload sound actions
    self.playExpolsionSFX = [SKAction playSoundFileNamed:@"rock.caf" waitForCompletion:NO];
    self.playShipMovementSFX = [SKAction playSoundFileNamed:@"shipMovement.caf" waitForCompletion:NO];
    self.powerupSFX = [SKAction playSoundFileNamed:@"powerup.caf" waitForCompletion:NO];
    self.powerdownSFX = [SKAction playSoundFileNamed:@"powerdown.caf" waitForCompletion:NO];
}



- (void)setUpTut {
    SKSpriteNode *tap = [SKSpriteNode spriteNodeWithImageNamed:@"tap"];
    tap.position = CGPointMake(self.size.width/2, 250);
    tap.zPosition = 4;
    tap.alpha = 0.75;
    
    SKLabelNode *instructions = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    instructions.text = @"Tap left or right to move";
    instructions.fontSize = 11;
    
    instructions.position = CGPointMake(self.size.width/2, tap.position.y - 50);
    instructions.zPosition = 4;
    [self addChild:instructions];
    
    SKAction *scale = [SKAction scaleBy:1.5 duration:1.0];
    SKAction *sequence = [SKAction sequence:@[scale,[scale reversedAction]]];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:1.5];
    
    [tap runAction:[SKAction repeatAction:sequence count:3] completion:^{
        [tap runAction:fadeOut completion:^{
            [tap removeFromParent];
        }];
        [instructions runAction:fadeOut completion:^{
            [instructions removeFromParent];
        }];
        
        
    }];
    [self addChild:tap];
}

-(void)setUpHealthCouner {
    SKSpriteNode *health = [SKSpriteNode spriteNodeWithImageNamed:@"playerLife"];
    health.position = CGPointMake(self.size.width / 11, self.size.height - 30);
    health.zPosition = 4;
    health.alpha = 0.75;
    [health setScale:2.0];
    
    [self addChild:health];
    
    //add label
    _healthCount = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
    _healthCount.text = @"0";
    _healthCount.fontSize = 12;
    _healthCount.position = CGPointMake(15, -5);
    _healthCount.zPosition = 5;
    _healthCount.alpha = 0.75;
    [health addChild:_healthCount];
}




#pragma mark - Touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //COde for moving ship
    
    //get a UITouch object
    UITouch *touch = [touches anyObject];
    //get touch loc
    CGPoint location = [touch locationInNode:self];
    //get selected node
    SKNode *node = [self nodeAtPoint:location];
    
    float moveBy = 20.0;
    float toucable = location.y < self.size.height - 60 && location.y > 50;
    
    
    
    if (_hasGamePlayStarted) {
        
        
        //checks for pause button
        if ([node.name isEqualToString:@"pauseButton"]) {
            
            
            if (_isShip) {
                [self.ship stopShipSFX];
                [node removeFromParent];
                
                //setup start/play button
                _playBtn = [PlayButtonNode buttonAtPosition:node.position];
                [self addChild:_playBtn];
                
                
                
                [self performSelector:@selector(pauseGame) withObject:nil afterDelay:1/60.0];
                
                _isPaused = YES;
            } else {
                _isPaused = NO;
            }
            
            
            
            
        } else if ([node.name isEqualToString:@"playButton"]) {
            
            [node removeFromParent];
            
            
            
            [self addPauseButton];
            _isPaused = NO;
            
            
            if (_isShip) {
                [self.ship playShipSFXForever];//only plays sound back if ship still exists
                
                
            }
            self.scene.paused = NO;
            
        } else if ([node.name isEqualToString:@"spaceTut"]) {
            [node removeFromParent];
            [self unPauseGamePlay];
            
        }
        
        if (!_isPaused && !_wasPausedByTut) {
            
            //detect if the left portion of the scene is touched
            if (location.x < self.size.width / 2 && toucable) {
                //move ship to the left if the touch location.y is higer than the banner ad
                
                
                [self.ship runAction:[SKAction sequence:@[self.playShipMovementSFX,
                                                          [SKAction moveByX:-moveBy y:0.0 duration:0.0]]]];
                
                
                
            }
            
            //detec if the right portion of the scene is touched
            if (location.x > self.size.width / 2 && toucable) {
                //move ship to the right if the touch location.y is higer than the banner ad
                
                
                [self.ship runAction:[SKAction sequence:@[self.playShipMovementSFX,
                                                          [SKAction moveByX:moveBy y:0.0 duration:0.0]]]];
                
            }
        }
    } else if (toucable && !_hasGamePlayStarted) {
        
        _hasGamePlayStarted = YES;
        [[self childNodeWithName:@"getReady"] removeFromParent];
        [self setUpTut];
        
    }
    
    
    
    
}




#pragma mark - Contact Detection

- (void)animateShipExplosion {
    
    _isGameOver = YES;
    
    SKSpriteNode *explosion = [SKSpriteNode spriteNodeWithImageNamed:@"explosion00"];
    explosion.position = self.ship.position; //sets the postion to that of the ship's
    explosion.size = self.ship.size; //sets the size/scale equal tot the ship's
    explosion.zPosition = 1;
    [self addChild:explosion];
    
    NSArray *shipHitAnimation = @[[SKTexture textureWithImageNamed:@"explosion00"],
                                  [SKTexture textureWithImageNamed:@"explosion01"],
                                  [SKTexture textureWithImageNamed:@"explosion02"],
                                  [SKTexture textureWithImageNamed:@"explosion03"],
                                  [SKTexture textureWithImageNamed:@"explosion04"],
                                  [SKTexture textureWithImageNamed:@"explosion05"]];
    
    SKAction *animate = [SKAction animateWithTextures:shipHitAnimation timePerFrame:0.50];
    [explosion runAction:[SKAction repeatAction:animate count:1] completion:^{
        [explosion removeFromParent];
        
        //Transition to end
        EndScene *gameOver = [EndScene sceneWithSize:self.size];
        gameOver.userData = [NSMutableDictionary dictionary];
        [gameOver.userData setObject:[NSString stringWithFormat:@"%ld", (long)_hud.score] forKey:@"currentScore"];
        [self.view presentScene:gameOver transition:[SKTransition fadeWithDuration:0.5]];
        
        //Remove obsever from NSNotificationCenter
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        
    }];
}


-(void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *sceondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        sceondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        sceondBody = contact.bodyA;
    }
   
    
    if (firstBody.categoryBitMask == CollisionCatAstroid && sceondBody.categoryBitMask == CollisionCatBottomEdge) {
        //awrad the player points
        if (_isShip) {
            
            [_hud awardScorePoint:pointsAwradared];
            
            
        }
        
        // NSLog(@"score");
    } else if (firstBody.categoryBitMask == CollisionCatShip && sceondBody.categoryBitMask == CollisionCatSpaceMan) {
        if (_numberOfLives < 3) {
            self.numberOfLives += bounsLife;
            [self updateHealthConter];
            [_hud awardScorePoint:bounsPoints];
            [self runAction:self.powerupSFX];
        }
        
        //remove spaceman node
        SpaceManNode *spaceMan = (SpaceManNode *)sceondBody.node;
        [spaceMan removeFromParent];
        
    } else if (firstBody.categoryBitMask == CollisionCatShip && sceondBody.categoryBitMask == CollisionCatAstroid) {
        
        ShipNode *ship = (ShipNode *)firstBody.node;
        AsteroidNode *asteroid = (AsteroidNode *)sceondBody.node;
        
        if (_numberOfLives == 0) {
            
            
            [self animateShipExplosion];
            
            
            [self runAction:self.playExpolsionSFX];
            [ship removeFromParent];
            [asteroid removeFromParent];
            [self.ship stopShipSFX];
            
            //save highscore to NSUSERDefaults
            
            
            NSUserDefaults *highScore = [NSUserDefaults standardUserDefaults];
            if ([highScore integerForKey:@"highScore"] < _hud.score) {
                [highScore setInteger:_hud.score forKey:@"highScore"];
                
                //save highscore array to NSUSerDefaults
                if (![highScore objectForKey:@"highScoreArray"]) {
                    //create new if it doesn't exist
                    NSArray *highScores = [[NSArray alloc] initWithObjects:[NSNumber numberWithInteger:_hud.score], nil];
                    [highScore setObject:highScores forKey:@"highScoreArray"];
                } else {
                    //add to current array
                    NSMutableArray *scoresArray = [[NSMutableArray alloc] initWithArray:[highScore objectForKey:@"highScoreArray"]];
                    [scoresArray addObject:[NSNumber numberWithInteger:_hud.score]];
                    [highScore setObject:scoresArray forKey:@"highScoreArray"];
                }
                
            }
            
            
            
            
            
            _isShip = NO;
            
        } else {
            
            self.numberOfHits ++;
            self.numberOfLives --;
            [self updateHealthConter];
            [asteroid removeFromParent];
            [self runAction:self.powerdownSFX];
            
        }
        
    }
    
}

-(void)updateHealthConter {
    _healthCount.text = [NSString stringWithFormat:@"%ld", (long)_numberOfLives];
}


#pragma mark - Update Loop

- (void)nodeCleanUp {
    [self enumerateChildNodesWithName:@"astroid" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0) {
            [node removeFromParent];
        }
    }];
    
    [self enumerateChildNodesWithName:@"spaceMan" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0) {
            [node removeFromParent];
        }
    }];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if (_isPaused | _isGameOver) {
        self.lastUpdateTimeInterval = 0;
        return;
    } else if (_hasGamePlayStarted) {
        
        if (_wasPausedByTut) {
            _wasPausedByTut = NO;
        }
        
        //increase the game difficulty by changing the speed pf asteroids
        if (self.totalGameTime > 240) {
            self.objectSpeed = -180;
            if (_isAsteroidTypeC) {
                self.asteroidRespwanRate = 1.0;
            } else {
                self.asteroidRespwanRate = 1.50;
            }
            
            
        } else if (self.totalGameTime > 120) {
            self.objectSpeed = -170;
            if (_isAsteroidTypeC) {
                self.asteroidRespwanRate = 1.05;
            } else {
                self.asteroidRespwanRate = 1.55;
            }
            
            
        } else if (self.totalGameTime > 60) {
            self.objectSpeed = -160;
            if (_isAsteroidTypeC) {
                self.asteroidRespwanRate = 1.10;
            } else {
                self.asteroidRespwanRate = 1.65;
            }
            
            
        } else if (self.totalGameTime > 30) {
            self.objectSpeed = -150;
            if (_isAsteroidTypeC) {
                self.asteroidRespwanRate = 1.15;
            } else {
                self.asteroidRespwanRate = 1.75;
            }
            
            
            
        } else if (self.totalGameTime > 15) {
            self.objectSpeed = -140;
            if (_isAsteroidTypeC) {
                self.asteroidRespwanRate = 1.20;
            } else {
                self.asteroidRespwanRate = 1.85;
            }
            
            
            
        }
        
        //called for astroid spawning
        if (self.lastUpdateTimeInterval) {
            self.timeSinceAsteroidAdded += currentTime - self.lastUpdateTimeInterval;
            self.totalGameTime += currentTime - self.lastUpdateTimeInterval;
            self.timeSinceSpaceManAdded += currentTime - self.lastUpdateTimeInterval;
            self.spaceManSpawnRate = [Utils randomWithMin:20 max:60];
        }
        
        
        if (self.timeSinceAsteroidAdded > self.asteroidRespwanRate) {
            [self addAstroids];
            self.timeSinceAsteroidAdded = 0;
        }
        
        if (self.timeSinceSpaceManAdded > self.spaceManSpawnRate) {
            [self addSpaceMan];
            self.timeSinceSpaceManAdded = 0;
            
        }
        
        
        
        self.lastUpdateTimeInterval = currentTime;
        [self awardAchievements];
        
        [self nodeCleanUp];
        
        
        
        
    }
    
    
    
    
}


#pragma mark - Achievements

- (void)awardAchievements {
    
    NSUserDefaults *hasShown = [NSUserDefaults standardUserDefaults];
    NSMutableArray *achievements = [NSMutableArray array];
    if (_numberOfLives == 1 && ![hasShown boolForKey:@"collectSpaceman"]) {
        
        [achievements addObject:[AchievementHelper collectSpacemanAchievement]];
        [hasShown setBool:YES forKey:@"collectSpaceman"];//makes sure achievement is shown once
    }
    
    if (_hud.score >= 40 && _numberOfHits == 0) {
        
        if (![hasShown boolForKey:@"inOneLife"]) {
            [achievements addObject:[AchievementHelper scoreInOneLife]];
            [hasShown setBool:YES forKey:@"inOneLife"];//makes sure achievement is shown once
        }
        
    }
    
    if (_numberOfHits == 3 && ![hasShown boolForKey:@"takeHit"]) {
        [achievements addObject:[AchievementHelper takeAHitAchievement]];
        [hasShown setBool:YES forKey:@"takeHit"];//makes sure achievement is shown once
    }
    
    
    [achievements addObject:[AchievementHelper incrementalScore:_hud.score]];
    
    [[GameKitHelper sharedGamekitHelper] reportAchievements:achievements];
}



#pragma mark - NSNotificationCenter for Handleing pauses

-(void)registerAppTransitionObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pauseGamePlay)
                                                 name:@"pause"
                                               object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unPauseGamePlay)
                                                 name:@"unPause"
                                               object:Nil];
    
}

#pragma mark - Pause Game

-(void)pauseGame {
    
    if (_isShip && _hasGamePlayStarted) {
        self.scene.paused = YES;
        
        if (_isPausedByResign && !_isPaused) {
            [self.ship stopShipSFX];
            [_pauseBtn removeFromParent];
            
            //setup start/play button
            _playBtn = [PlayButtonNode buttonAtPosition:_pauseBtn.position];
            [self addChild:_playBtn];
            
            _isPaused = YES;
            _isPausedByResign = NO;
            
        }
    }
    
}

-(void)pauseGamePlay {
    _isPausedByResign = YES;
    _wasPausedByTut = YES;
    if (!_isPaused) {
        [self pauseGame];
    }
    
}

-(void)unPauseGamePlay {
    
    _isPaused = NO;
    self.scene.paused = NO;
    [self preLoadSFX]; //possible fix for ad interruprion
    
    [_playBtn removeFromParent];
    
    _pauseBtn = [PauseButtonNode buttonAtPosition:_playBtn.position];
    [self addChild:_pauseBtn];
    
    if (_isShip) {
        [self.ship playShipSFXForever];//only plays sound back if ship still exists
        
        
        
    }
}

-(void)applicationWillResignActive {
    _isPausedByResign = YES;
    if (!_isPaused) {
        [self pauseGame];
    }
    
    
}

-(void)applicationDidEnterBackground {
    self.view.paused = YES;
    [_ship stopShipSFX];
    
    
    
}

-(void)applicationWillEnterForeground {
    self.view.paused = NO;
    if (_isPaused) {
        [self pauseGame];
    } else {
        [_ship playShipSFXForever];
    }
    
}

@end
