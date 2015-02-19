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


@interface GameScene ()

//allows to control astroid spawn rate
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceAdded;
@property (nonatomic) NSTimeInterval totalGameTime;
@property (nonatomic) NSInteger asteroidSpeed;
@property (nonatomic) float smallPhoneRate;
@property (nonatomic) float largePhoneRate;
@property (nonatomic) ShipNode *ship;
@property (nonatomic) PauseButtonNode *pauseBtn;
@property (nonatomic) HudNode *hud;
@property (nonatomic) BOOL isPaused;
@property (nonatomic) BOOL isPausedByResign;
@property (nonatomic) BOOL isShip;
@property (nonatomic) SKAction *playExpolsionSFX;
@property (nonatomic) SKAction *playShipMovementSFX;

@end

@implementation GameScene



#pragma mark - Add Nodes

- (void)addPlayerShip {
    //add spaceship to scene
    self.ship = [ShipNode shipAtPostion:CGPointMake(self.size.width/2, 100)];
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
    
    astroid.physicsBody.velocity = CGVectorMake(0, self.asteroidSpeed);
    
    
    [self addChild:astroid];
    
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
}

-(void)didMoveToView:(SKView *)view {
    
    [self registerAppTransitionObservers];
    
    self.lastUpdateTimeInterval = 0;
    self.timeSinceAdded = 0;
    self.totalGameTime = 0;
    self.asteroidSpeed = asteroidSpeed;
    self.smallPhoneRate = 2.0;
    self.largePhoneRate = 2.25;
    
    
    _isPaused = NO;
    _isShip = YES;
    //Set the background image
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
    background.position = CGPointMake(self.size.width/2, self.size.height/2);
    background.size = self.size;
    background.zPosition = 0;
    [self addChild:background];
    
    [self addPauseButton];
    [self addHud];
    [self addBottomEdge];
    
    
    //set physicsbody for scene
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = CollisionCatEdge;
    //physics world gravity
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    //contact deleagte
    self.physicsWorld.contactDelegate = self;
    
    
    [self addPlayerShip];
    //called once to have astroid spawn immediately
    [self addAstroids];
    
    [self preLoadSFX];
    
    
    
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
    
    //checks for pause button
    if ([node.name isEqualToString:@"pauseButton"]) {
        
        
        if (_isShip) {
            [self.ship stopShipSFX];
            [node removeFromParent];
            
            //setup start/play button
            PlayButtonNode *play = [PlayButtonNode buttonAtPosition:node.position];
            [self addChild:play];
            
            
            
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
        
    }
    
    if (!_isPaused) {
        
        //detect if the left portion of the scene is touched
        if (location.x < self.size.width / 2 && location.y < self.size.height - 50) {
            //move ship to the left
            
            
            [self.ship runAction:[SKAction sequence:@[self.playShipMovementSFX,
                                                      [SKAction moveByX:-moveBy y:0.0 duration:0.0]]]];
            
        }
        
        //detec if the right portion of the scene is touched
        if (location.x > self.size.width / 2 && location.y < self.size.height - 50) {
            //move ship to the right
            
            
            [self.ship runAction:[SKAction sequence:@[self.playShipMovementSFX,
                                                      [SKAction moveByX:moveBy y:0.0 duration:0.0]]]];
        }
    }
    
    
    
    
}


#pragma mark - Pause Game

-(void)pauseGame {
    
    if (_isShip) {
        self.scene.paused = YES;
        
        if (_isPausedByResign && !_isPaused) {
            [self.ship stopShipSFX];
            [_pauseBtn removeFromParent];
            
            //setup start/play button
            PlayButtonNode *play = [PlayButtonNode buttonAtPosition:_pauseBtn.position];
            [self addChild:play];
            
            _isPaused = YES;
            _isPausedByResign = NO;
        }
    }
    
}

#pragma mark - Contact Detection

- (void)animateShipExplosion {
    
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
    [explosion runAction:[SKAction repeatAction:animate count:2] completion:^{
        [explosion removeFromParent];
        
        //Transition to end
        EndScene *gameOver = [EndScene sceneWithSize:self.size];
        [self.view presentScene:gameOver transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
        
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
    NSLog(@"Body: %u", firstBody.categoryBitMask);
    
    if (firstBody.categoryBitMask == CollisionCatBottomEdge | sceondBody.categoryBitMask == CollisionCatBottomEdge) {
        //awrad the player points
        if (_isShip) {
            [_hud awardScorePoint:pointsAwradared];
        }
        
        NSLog(@"score");
    } else if (firstBody.categoryBitMask == CollisionCatShip && sceondBody.categoryBitMask == CollisionCatAstroid) {
            ShipNode *ship = (ShipNode *)firstBody.node;
            AsteroidNode *asteroid = (AsteroidNode *)sceondBody.node;
    
            [self animateShipExplosion];
    
    
            [self runAction:self.playExpolsionSFX];
            [ship removeFromParent];
            [asteroid removeFromParent];
            [self.ship stopShipSFX];
    
            _isShip = NO;
        }
    
}


#pragma mark - Update Loop

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if (_isPaused) {
        self.lastUpdateTimeInterval = 0;
        return;
    } else {
        
        
        
        //called for astroid spawning
        if (self.lastUpdateTimeInterval) {
            self.timeSinceAdded += currentTime - self.lastUpdateTimeInterval;
            self.totalGameTime += currentTime - self.lastUpdateTimeInterval;
        }
        //checks device size then adjusts speeds
        if (IS_IPHONE_4_OR_LESS | IS_IPHONE_5) {
            if (self.timeSinceAdded > self.smallPhoneRate) {
                [self addAstroids];
                self.timeSinceAdded = 0;
            }
        } else {
            
            
            if (self.timeSinceAdded > self.largePhoneRate) {
                [self addAstroids];
                self.timeSinceAdded = 0;
            }
        }
        
        
        self.lastUpdateTimeInterval = currentTime;
    }
    
    
    //increase the game difficulty by changing the speed pf asteroids
    if (self.totalGameTime > 240) {
        self.asteroidSpeed = -150;
        if (IS_IPHONE_4_OR_LESS | IS_IPHONE_5) {
            self.smallPhoneRate =  1.50;
        } else {
            self.largePhoneRate = 1.75;
        }
        
    } else if (self.totalGameTime > 120) {
        self.asteroidSpeed = -140;
        if (IS_IPHONE_4_OR_LESS | IS_IPHONE_5) {
            self.smallPhoneRate =  1.60;
        } else {
            self.largePhoneRate = 1.85;
        }
        
    } else if (self.totalGameTime > 60) {
        self.asteroidSpeed = -130;
        if (IS_IPHONE_4_OR_LESS | IS_IPHONE_5) {
            self.smallPhoneRate =  1.70;
        } else {
            self.largePhoneRate = 1.95;
        }
        
    } else if (self.totalGameTime > 30) {
        self.asteroidSpeed = -120;
        if (IS_IPHONE_4_OR_LESS | IS_IPHONE_5) {
            self.smallPhoneRate =  1.80;
        } else {
            self.largePhoneRate = 2.05;
        }
        
    } else if (self.totalGameTime > 15) {
        self.asteroidSpeed = -110;
        if (IS_IPHONE_4_OR_LESS | IS_IPHONE_5) {
            self.smallPhoneRate =  1.90;
        } else {
            self.largePhoneRate = 2.15;
        }
        
    }
    //NSLog(@"Speed: %ld", (long)self.asteroidSpeed);
    
    
    
    
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
    }
    
}

@end
